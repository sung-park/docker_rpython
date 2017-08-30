R and Python for Data Science School
-----------------------------------------------------

This images has the components:

* Ubuntu 16.04

* Python 3.6 (Anaconda3-4.4.0)
 - ipython, numpy, scipy, pandas, matplotlib, seaborn, pymc3
 - jupyter qtconsole, ipyparallel, notebook
 - scikit-learn, nlpy, gensim, theano, tensorflow, keras
 - other 250 packages

* R-3.3.2
 - rstudio-server-1.0.153

* Libraries
 - ZeroMQ, Boost, Open-JDK, QuantLib, HDF5

* Tools
 - git, vim, emacs, tex-live, pandoc, graphviz, imagemagick

* Running Services
 - jupyter notebook (port 8888)
 - R-studio server (port 8787)
 - ssh (port 22)


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
