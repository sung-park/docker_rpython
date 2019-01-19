# docker_rpython

dockerfile for datascienceschool/rpython2 and datascienceschool/rpython


## Git configuration on Mac OSX

```
git config --global core.precomposeunicode true
```

## Running Docker Container with GDB Debuging Enabled

```
docker run -Pit --name rpython -p 8888:8888 -p 8787:8787 -p 6006:6006 -p 8022:22 --cap-add=SYS_PTRACE --security-opt seccomp=unconfined -v /Users/user:/home/dockeruser/hosthome datascienceschool/rpython
```
