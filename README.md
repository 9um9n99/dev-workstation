# dev-workstation

Codyssey 올인원 입학 연수 미션: 내 컴퓨터에 개발자용 '작업실' 꾸미기

## 1. 프로젝트 개요

(작성 예정: 이 미션의 목표를 내 말로 2~3문장 정리)

## 2. 실행 환경

| 항목 | 값 |
| --- | --- |
| OS | macOS 26.6.2 (build 25G83), Apple Silicon (arm64) |
| 쉘 / 터미널 | zsh (`/bin/zsh`) / macOS 터미널 |
| Docker | Docker Desktop, `Docker version 29.9.3, build 5457199` |
| Git | `git version 2.39.5 (Apple Git-154)` |

## 3. 수행 항목 체크리스트

- [x] 터미널 (이동/생성/복사/이름변경/삭제/내용 확인)
- [x] 권한 (파일 644→600, 디렉토리 755→700 변경 전/후)
- [x] Docker 설치 및 점검 (`docker --version`, `docker info`)
- [x] Docker 기본 운영 (images / ps / logs / stats, hello-world, ubuntu, exec vs attach)
- [x] Dockerfile 커스텀 이미지 (nginx:alpine 기반)
- [x] 포트 매핑 (8080:80) 및 접속 증거
- [x] 바인드 마운트 (변경 반영)
- [x] 볼륨 (컨테이너 삭제 전/후 데이터 유지)
- [x] Git 설정 (`git config --list`)
- [ ] GitHub 연동 (VS Code 로그인/저장소 연동 증거)

## 4. 검증 방법과 증거

| 항목 | 확인한 방법 | 증거 위치 |
| --- | --- | --- |
| 터미널 조작 | `pwd`, `ls -la`, `mkdir`, `cp`, `mv`, `rm`, `cat`, `touch` | [docs/01-terminal-log.md](docs/01-terminal-log.md) |
| 권한 | `ls -l`, `ls -ld`, `chmod` 전/후 비교 | [docs/02-permission-log.md](docs/02-permission-log.md) |
| Docker 점검 | `docker --version`, `docker info` | [docs/03-docker-check-log.md](docs/03-docker-check-log.md) |
| Docker 운영 | `docker images/ps/ps -a/logs/stats`, `exec`, `attach` | [docs/04-docker-ops-log.md](docs/04-docker-ops-log.md) |
| Dockerfile / 포트 | `docker build`, `docker run -p 8080:80`, `curl`, 브라우저 | [docs/05-dockerfile-port-log.md](docs/05-dockerfile-port-log.md), [브라우저 화면](docs/images/port-mapping-browser.png) |
| 바인드 마운트 / 볼륨 | `-v` 바인드, `docker volume create/ls/inspect` | [docs/06-mount-volume-log.md](docs/06-mount-volume-log.md) |
| Git / GitHub | `git config --list`, `git remote -v` | [docs/08-git-github-log.md](docs/08-git-github-log.md) |

## 5. 트러블슈팅

자세한 기록: [docs/07-troubleshooting-log.md](docs/07-troubleshooting-log.md)

### 5-1. `docker` 명령을 찾을 수 없음
- **문제**: 터미널에서 `docker`를 실행하면 명령을 찾을 수 없다고 나옴
- **원인 가설**: Docker는 설치됐지만, 쉘이 명령을 찾는 경로(PATH)에 `~/.docker/bin`이 없다
- **확인**: `ls -l /usr/local/bin/docker`는 없음, `ls ~/.docker/bin`에는 docker가 있음
- **해결**: `~/.zshrc`에 `export PATH="$HOME/.docker/bin:$PATH"` 추가 후 `source ~/.zshrc` → `docker --version` 정상

### 5-2. PATH 줄의 공백 오타
- **문제**: `$HOME/ .docker/bin`처럼 공백이 들어가 경로가 틀림
- **원인 가설**: 명령을 입력하면서 `/` 뒤에 공백이 섞였다
- **확인**: `~/.zshrc` 내용을 확인
- **해결**: `sed -i '' '/HOME\/ \.docker/d' ~/.zshrc`로 잘못된 줄만 삭제

### 5-3. `mv` 뒤 공백 누락
- **문제**: `zsh: no such file or directory: mv/Users/...`
- **원인 가설**: `mv`와 경로 사이에 공백이 없어 하나의 이름으로 읽힘
- **확인**: 입력한 명령 확인
- **해결**: `mv ~/Desktop/port-mapping-browser.png docs/images/port-mapping-browser.png`

## 6. 개념 정리

(작성 예정: exec와 attach, Dockerfile 커스텀 포인트, 바인드 마운트와 볼륨의 차이를 내 말로 정리)
