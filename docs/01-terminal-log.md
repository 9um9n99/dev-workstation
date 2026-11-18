# 터미널 조작 로그

## 1. 현재 위치 확인 / 폴더 생성 / 이동 / 목록 확인

```
$ mkdir practice
$ cd practice
$ pwd
/Users/<사용자>/codyssey/dev-workstation/practice
$ ls -la
total 0
drwxr-xr-x  2 <사용자>  staff  64 11월 11 19:28 .
drwxr-xr-x  3 <사용자>  staff  96 11월 11 19:28 ..
```

## 2. 빈 파일 생성 / 파일 쓰기 / 내용 확인

```
$ touch empty.txt
$ echo "hello codyssey" > hello.txt
$ ls -l
total 8
-rw-r--r--  1 <사용자>  staff   0 11월 11 19:29 empty.txt
-rw-r--r--  1 <사용자>  staff  15 11월 11 19:29 hello.txt
$ cat hello.txt
hello codyssey
```

## 3. 복사 / 이름 변경 / 삭제

```
$ cp hello.txt copy.txt
$ mv copy.txt renamed.txt
$ ls -l
total 16
-rw-r--r--  1 <사용자>  staff   0 11월 11 19:29 empty.txt
-rw-r--r--  1 <사용자>  staff  15 11월 11 19:29 hello.txt
-rw-r--r--  1 <사용자>  staff  15 11월 11 19:30 renamed.txt
$ rm renamed.txt
$ rm empty.txt
$ ls -l
total 8
-rw-r--r--  1 <사용자>  staff  15 11월 11 19:29 hello.txt
```
