R and Python for Data Science School
-----------------------------------------------------

This images has the components:

* Ubuntu 18.04
* Python 3.7 (Anaconda3-2018.12)
* R-3.5.2 with rstudio-server 1.1.463
* Databases: PostgreSQL, Redis
* Tools: git, emacs, tex-live, pandoc, graphviz, imagemagick, etc.
* Services

  * jupyter notebook (port 8888)
  * R-studio server (port 8787)
  * ssh (port 22)


Running Docker Machine
--------------------------------------------

```
docker run --name=rpython -Pit -p 8888:8888 -p 8787:8787 -p 8022:22 -p 6006:6006 datascienceschool/rpython
```

    
Boot2Docker Account
---------------------
* user id: docker
* password: tcuser


Docker Account
---------------------
* user id: dockeruser
* password: dockeruserpass
