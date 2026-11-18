# Docker 기본 운영 명령 및 컨테이너 실행 로그

## 1. 실습 전 상태 (이미지/컨테이너 없음)

```
$ docker images
                                                                  i Info →   U  In Use
IMAGE   ID             DISK USAGE   CONTENT SIZE   EXTRA
$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
$ docker ps -a
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
```

## 2. hello-world 실행

```
$ docker run hello-world
Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world
58dee6a49ef1: Pull complete 
c3bdf82c34d1: Download complete 
Digest: sha256:cf1b20a0c89a666b6950fecda7ccbc1b1a86520e7c53f908f3a21e79d0d60458
Status: Downloaded newer image for hello-world:latest

Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (arm64v8)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://hub.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/get-started/
```

## 3. 실행 후 이미지/컨테이너 목록

```
$ docker images
                                                                  i Info →   U  In Use
IMAGE                ID             DISK USAGE   CONTENT SIZE   EXTRA
hello-world:latest   cf1b20a0c89a       22.6kB         10.3kB    U   
$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
$ docker ps -a
CONTAINER ID   IMAGE         COMMAND    CREATED          STATUS                      PORTS     NAMES
4b9dfe883960   hello-world   "/hello"   36 seconds ago   Exited (0) 36 seconds ago             confident_wescoff
```

## 4. 컨테이너 로그 확인

```
$ docker logs confident_wescoff

Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (arm64v8)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://hub.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/get-started/
```

## 5. ubuntu 컨테이너 실행 및 내부 진입

```
$ docker run -it --name ubuntu-test ubuntu bash
Unable to find image 'ubuntu:latest' locally
latest: Pulling from library/ubuntu
cedc468d06b2: Pull complete 
7f2c2ca81066: Pull complete 
9d297c90b98f: Download complete 
Digest: sha256:065aa8626841f16057b78b027b464cd59c4fac36c204c72dcbf48d66f5fa8a96
Status: Downloaded newer image for ubuntu:latest
root@7f8f2afffef9:/# ls
bin   dev  home  media  opt   root  sbin  sys  usr
boot  etc  lib   mnt    proc  run   srv   tmp  var
root@7f8f2afffef9:/# echo "hello from ubuntu"
hello from ubuntu
root@7f8f2afffef9:/# cat /etc/os-release
PRETTY_NAME="Ubuntu 26.04.1 LTS"
NAME="Ubuntu"
VERSION_ID="26.04"
VERSION="26.04.1 LTS (Resolute Raccoon)"
VERSION_CODENAME=resolute
ID=ubuntu
ID_LIKE=debian
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
UBUNTU_CODENAME=resolute
LOGO=ubuntu-logo
root@7f8f2afffef9:/# exit
exit
```

## 6. 컨테이너 유지 실행 및 상태/리소스 확인

```
$ docker ps -a
CONTAINER ID   IMAGE         COMMAND    CREATED         STATUS                     PORTS     NAMES
7f8f2afffef9   ubuntu        "bash"     2 minutes ago   Exited (0) 2 minutes ago             ubuntu-test
4b9dfe883960   hello-world   "/hello"   4 minutes ago   Exited (0) 4 minutes ago             confident_wescoff
$ docker run -dit --name ubuntu-keep ubuntu bash
ffac306b1e119d1a560457fd12b3f7fadf1f4a071b10e61528a7d85696f0af00
$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED         STATUS         PORTS     NAMES
ffac306b1e11   ubuntu    "bash"    6 seconds ago   Up 5 seconds             ubuntu-keep
$ docker stats --no-stream
CONTAINER ID   NAME          CPU %     MEM USAGE / LIMIT     MEM %     NET I/O         BLOCK I/O   PIDS
ffac306b1e11   ubuntu-keep   0.00%     2.684MiB / 7.748GiB   0.03%     1.17kB / 126B   0B / 0B     1
```

## 7. exec 관찰: 나와도 컨테이너는 계속 실행

```
$ docker exec -it ubuntu-keep bash
root@ffac306b1e11:/# echo hi
hi
root@ffac306b1e11:/# exit
exit
$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED         STATUS         PORTS     NAMES
ffac306b1e11   ubuntu    "bash"    2 minutes ago   Up 2 minutes             ubuntu-keep
```

## 8. attach 관찰: 나오면 컨테이너도 종료

```
$ docker attach ubuntu-keep
root@ffac306b1e11:/# echo attached
attached
root@ffac306b1e11:/# exit
exit
$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
$ docker ps -a
CONTAINER ID   IMAGE         COMMAND    CREATED          STATUS                          PORTS     NAMES
ffac306b1e11   ubuntu        "bash"     5 minutes ago    Exited (0) About a minute ago             ubuntu-keep
7f8f2afffef9   ubuntu        "bash"     8 minutes ago    Exited (0) 8 minutes ago                  ubuntu-test
4b9dfe883960   hello-world   "/hello"   10 minutes ago   Exited (0) 10 minutes ago                 confident_wescoff
```

## 9. exec와 attach 차이 정리

| | exec | attach |
|---|---|---|
| 동작 | 실행 중인 컨테이너 안에 새 프로그램을 추가로 실행 | 컨테이너의 메인 프로그램에 터미널을 연결 |
| `exit` 후 컨테이너 | 계속 실행 (`Up`) | 종료 (`Exited (0)`) |
| 이유 | 끝난 것은 추가로 띄운 bash뿐이고 메인 프로그램은 살아 있음 | 끝난 것이 컨테이너의 메인 프로그램이라서 컨테이너도 종료됨 |
