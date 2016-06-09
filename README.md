# docker_rpython
dockerfile for datascienceschool/rpython in https://hub.docker.com/r/datascienceschool/rpython/

R and Python for Data Science School
-----------------------------------------------------


This images has the components:

* Ubuntu 14.04


* Python 2.7 (Anaconda2-4.0.0)
 - ipython, numpy, scipy, pandas, matplotlib, seaborn, pymc3 
 - jupyter qtconsole,, ipyparallel, notebook
 - scikit-learn, nlpy, gensim, theano, tensorflow, keras
 - other 250 packages


* R-3.2.3
 - rstudio-server-0.99.902


* Libraries
 - ZeroMQ, Boost, Open-JDK, HDF5


* Tools
 - git, vim, emacs, tex-live, pandoc, graphviz imagemagick



* Running Services
 -  jupyter notebook (https port 8888)
 -  R-studio server (http port 8787)



Running Docker Machine
--------------------------------------------


```
docker-machine ssh
docker run --name=rpython -it -p 8888:8888 -p 8787:8787 datascienceschool/rpython
```


Docker Account
---------------------
* user id: dockeruser
* password: dockeruserpass
