# 권한 실습 로그

## 1. 변경 전 상태

```
$ mkdir perm-dir
$ ls -l hello.txt
-rw-r--r--  1 <사용자>  staff  15 11월 11 19:29 hello.txt
$ ls -ld perm-dir
drwxr-xr-x  2 <사용자>  staff  64 11월 11 19:44 perm-dir
```

## 2. 권한 변경 후 상태

```
$ chmod 600 hello.txt
$ chmod 700 perm-dir
$ ls -l hello.txt
-rw-------  1 <사용자>  staff  15 11월 11 19:29 hello.txt
$ ls -ld perm-dir
drwx------  2 <사용자>  staff  64 11월 11 19:44 perm-dir
```

## 3. 권한 효과 확인 (읽기 권한 제거 후 접근 시도)

```
$ chmod 000 hello.txt
$ ls -l hello.txt
----------  1 <사용자>  staff  15 11월 11 19:29 hello.txt
$ cat hello.txt
cat: hello.txt: Permission denied
$ chmod 644 hello.txt
$ ls -l hello.txt
-rw-r--r--  1 <사용자>  staff  15 11월 11 19:29 hello.txt
$ cat hello.txt
hello codyssey
```

## 4. 비교 요약

| 대상 | 변경 전 | 변경 후 |
|---|---|---|
| hello.txt (파일) | 644 (rw-r--r--) | 600 (rw-------) |
| perm-dir (디렉토리) | 755 (rwxr-xr-x) | 700 (rwx------) |
