# 바인드 마운트 및 Docker 볼륨 영속성 로그

## 1. 바인드 마운트: 호스트 파일 변경이 컨테이너에 반영되는지 확인

### 1-1. 변경 전

```
$ docker rm -f dev-web
dev-web
$ docker run -d -p 8080:80 -v "$(pwd)/app":/usr/share/nginx/html --name dev-web-bind dev-workstation-web:1.0
9c224f75c8b1abc0c4a1dbb4e7b89724069c4e8a75e349277cc2d124e538c692
$ docker ps
CONTAINER ID   IMAGE                     COMMAND                   CREATED                  STATUS                  PORTS                                     NAMES
9c224f75c8b1   dev-workstation-web:1.0   "/docker-entrypoint.…"   Less than a second ago   Up Less than a second   0.0.0.0:8080->80/tcp, [::]:8080->80/tcp   dev-web-bind
$ grep "<h1>" app/index.html
  <h1>Hello from my Docker container!</h1>
$ curl -s http://localhost:8080 | grep "<h1>"
  <h1>Hello from my Docker container!</h1>
```

### 1-2. 호스트에서 파일 수정 후 (이미지 재빌드, 컨테이너 재시작 없음)

```
$ sed -i '' 's/Hello from my Docker container!/Hello from bind mount!/' app/index.html
$ grep "<h1>" app/index.html
  <h1>Hello from bind mount!</h1>
$ curl -s http://localhost:8080 | grep "<h1>"
  <h1>Hello from bind mount!</h1>
```

### 1-3. 비교

| | 호스트 `app/index.html` | 컨테이너 응답 |
|---|---|---|
| 변경 전 | Hello from my Docker container! | Hello from my Docker container! |
| 변경 후 | Hello from bind mount! | Hello from bind mount! |

## 2. Docker 볼륨: 컨테이너를 삭제해도 데이터가 유지되는지 확인

### 2-1. 볼륨 생성, 연결, 데이터 저장 (컨테이너 삭제 전)

```
$ docker volume create dev-data
dev-data
$ docker volume ls
DRIVER    VOLUME NAME
local     dev-data
$ docker run -dit --name vol-test -v dev-data:/data ubuntu bash
6a6d068a2647d48a5262baaf21b4902bae112784016cebc9744626d50ba7f8b8
$ docker exec vol-test sh -c 'echo "persistent data" > /data/hello.txt'
$ docker exec vol-test cat /data/hello.txt
persistent data
$ docker volume inspect dev-data
[
    {
        "CreatedAt": "2026-11-12T07:44:45Z",
        "Driver": "local",
        "Labels": null,
        "Mountpoint": "/var/lib/docker/volumes/dev-data/_data",
        "Name": "dev-data",
        "Options": null,
        "Scope": "local"
    }
]
```

### 2-2. 컨테이너 삭제 후 데이터 확인

```
$ docker rm -f vol-test
vol-test
$ docker ps -a
CONTAINER ID   IMAGE                     COMMAND                   CREATED              STATUS                      PORTS                                     NAMES
9c224f75c8b1   dev-workstation-web:1.0   "/docker-entrypoint.…"   About a minute ago   Up About a minute           0.0.0.0:8080->80/tcp, [::]:8080->80/tcp   dev-web-bind
ffac306b1e11   ubuntu                    "bash"                    34 minutes ago       Exited (0) 30 minutes ago                                             ubuntu-keep
7f8f2afffef9   ubuntu                    "bash"                    37 minutes ago       Exited (0) 37 minutes ago                                             ubuntu-test
4b9dfe883960   hello-world               "/hello"                  39 minutes ago       Exited (0) 39 minutes ago                                             confident_wescoff
$ docker volume ls
DRIVER    VOLUME NAME
local     dev-data
$ docker run --rm -v dev-data:/data ubuntu cat /data/hello.txt
persistent data
```

### 2-3. 확인 결과

- 컨테이너 `vol-test`를 삭제하자 `docker ps -a` 목록에서 사라졌다.
- 그러나 볼륨 `dev-data`는 `docker volume ls`에 그대로 남아 있었다.
- 새 컨테이너에 같은 볼륨을 연결하자 `persistent data`가 그대로 읽혔다.
- 따라서 볼륨에 저장한 데이터는 컨테이너가 삭제되어도 유지된다.

## 3. 바인드 마운트와 볼륨 비교 (초안)

| | 바인드 마운트 | Docker 볼륨 |
|---|---|---|
| `-v` 앞부분 | 호스트의 폴더 경로 (`$(pwd)/app`) | 볼륨 이름 (`dev-data`) |
| 저장 위치 | 내가 지정한 호스트 폴더 | Docker가 관리하는 공간 |
| 이번 실습에서 확인한 것 | 호스트 파일 수정이 컨테이너에 바로 반영됨 | 컨테이너를 삭제해도 데이터가 유지됨 |
