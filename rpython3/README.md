# docker_rpython3
dockerfile for datascienceschool/rpython3 in https://hub.docker.com/r/datascienceschool/rpython3/

R and Python for Data Science School
-----------------------------------------------------

This images has the components:

* Ubuntu 14.04


* Python 2.7 (Anaconda2-4.1.1)
 - ipython, numpy, scipy, pandas, matplotlib, seaborn, pymc3 
 - jupyter qtconsole,, ipyparallel, notebook
 - scikit-learn, nlpy, gensim, theano, tensorflow, keras
 - other 250 packages


* R-3.2.3
 - rstudio-server-0.99.903


* Libraries
 - ZeroMQ, Boost, Open-JDK, QuantLib, HDF5


* Tools
 - git, vim, emacs, tex-live, pandoc, graphviz, imagemagick



* Running Services
 -  jupyter notebook (http port 8888)
 -  R-studio server (http port 8787)



Running Docker Machine
--------------------------------------------


```
docker run --name=rpython3 -it -p 8888:8888 -p 8787:8787 -p 6006:6006 datascienceschool/rpython3
```


Boot2Docker Account
---------------------
* user id: docker
* password: tcuser


Docker Account
---------------------
* user id: dockeruser
* password: dockeruserpass
