# 트러블슈팅 로그

## 1. Docker 설치 후 `docker` 명령을 찾지 못함

### 문제

Docker Desktop을 설치한 뒤 터미널에서 `docker --version`을 실행하면 `command not found` 오류가 났다. (최초 오류 화면은 보존하지 못했다. 아래 "확인"은 원인을 현재 상태에서 다시 확인한 결과다.)

### 원인 가설

터미널은 환경 변수 `PATH`에 적힌 폴더에서만 명령을 찾는다. `docker`가 설치된 폴더가 `PATH`에 없어서 찾지 못했을 것이다.

### 확인

```
$ ls -l /usr/local/bin/docker
ls: /usr/local/bin/docker: No such file or directory
$ ls ~/.docker/bin
docker				docker-credential-osxkeychain
docker-compose			kubectl
docker-credential-desktop	kubectl.docker
```

- 일반적으로 명령을 찾는 위치(`/usr/local/bin`)에는 `docker`가 없었다.
- Docker Desktop은 `~/.docker/bin`에 `docker`를 설치했다.

### 해결

`~/.docker/bin`을 `PATH`에 추가하는 줄을 `~/.zshrc`에 넣고, 설정을 현재 터미널에 적용했다.

```
$ echo 'export PATH="$HOME/.docker/bin:$PATH"' >> ~/.zshrc
$ source ~/.zshrc
```

해결 후 상태는 다음과 같다.

```
$ tail -n 3 ~/.zshrc
export PATH="/Users/<사용자>/.local/bin:$PATH"
export PATH="$HOME/.docker/bin:$PATH"
$ which docker
/Users/<사용자>/.docker/bin/docker
$ docker --version
Docker version 29.9.3, build 5457199
```

## 2. `~/.zshrc`의 PATH 줄에 공백 오타

### 문제

PATH 설정 줄을 입력할 때 `$HOME/ .docker/bin`처럼 `/` 뒤에 공백이 들어갔다. (오타가 있던 당시의 출력은 보존하지 못했다.)

### 원인 가설

공백이 들어가면 경로가 `$HOME/`와 `.docker/bin`으로 나뉘어 올바른 폴더를 가리키지 못하므로, 이 줄은 `docker`를 찾는 데 쓸 수 없었을 것이다.

### 확인

`tail`로 설정 파일의 마지막 줄들을 확인하여 오타가 있는 줄을 찾았다.

```
$ tail -n 4 ~/.zshrc
```

### 해결

오타가 있는 줄만 `sed`로 삭제하고, 올바른 줄을 다시 추가했다.

```
$ sed -i '' '/HOME\/ \.docker/d' ~/.zshrc
```

삭제 후 현재 상태는 문제 1의 "해결 후 상태"와 같다. 오타 줄은 없고 올바른 PATH 줄만 남아 있다.

## 3. `mv` 명령의 공백 누락으로 파일 이동 실패

### 문제

캡처 이미지를 프로젝트 폴더로 옮기려고 `mv`를 입력했는데 오류가 났다.

```
$ mv/Users/<사용자>/Desktop/port-mapping-browser.png 
zsh: no such file or directory: mv/Users/<사용자>/Desktop/port-mapping-browser.png
```

### 원인 가설

1. `mv`와 경로 사이에 공백이 없어서 `mv/Users/...` 전체가 하나의 명령 이름으로 해석되었을 것이다.
2. 목적지가 입력되지 않았다. `mv`는 옮길 파일과 목적지가 모두 필요하다.

### 확인

옮길 파일이 실제로 바탕화면에 있는지 확인했다. 파일은 존재했으므로 파일 문제가 아니라 명령 입력 방식의 문제였다.

```
$ ls -l ~/Desktop/port-mapping-browser.png
-rw-r--r--@ 1 <사용자>  staff  408483 11월 12 16:41 /Users/<사용자>/Desktop/port-mapping-browser.png
```

### 해결

`mv` 뒤에 공백을 넣고 목적지까지 지정하여 다시 실행했다.

```
$ mv ~/Desktop/port-mapping-browser.png docs/images/port-mapping-browser.png
$ ls -l docs/images
total 800
-rw-r--r--@ 1 <사용자>  staff  408483 11월 12 16:41 port-mapping-browser.png
```
