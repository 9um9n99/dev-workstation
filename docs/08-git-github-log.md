# 08. Git 설정 및 GitHub 연동 로그

## 1. Git 설정 확인 (이메일·사용자명 경로는 마스킹)

```bash
$ git --version
git version 2.39.5 (Apple Git-154)

$ git config --list
credential.helper=osxkeychain
init.defaultbranch=main
filter.lfs.clean=git-lfs clean -- %f
filter.lfs.smudge=git-lfs smudge -- %f
filter.lfs.process=git-lfs filter-process
filter.lfs.required=true
user.name=sumin
user.email=<이메일 마스킹>
core.excludesfile=/Users/<사용자>/.gitignore_global
init.defaultbranch=main
```

## 2. 저장소 초기화와 원격 연결

```bash
$ git init
Initialized empty Git repository in /Users/<사용자>/codyssey/dev-workstation/.git/
$ git branch --show-current
main
$ git remote add origin https://github.com/9um9n99/dev-workstation.git
$ git remote -v
origin	https://github.com/9um9n99/dev-workstation.git (fetch)
origin	https://github.com/9um9n99/dev-workstation.git (push)
```
