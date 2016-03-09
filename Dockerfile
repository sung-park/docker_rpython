FROM ubuntu:latest
MAINTAINER "Joel Kim" admin@datascienceschool.net

# Set environment
ENV HOME /root
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8

# Replace sh with bash
RUN cd /bin && rm sh && ln -s bash sh

# Config for unicode input/output
RUN locale-gen en_US.UTF-8 && dpkg-reconfigure locales && \
echo "set input-meta on" >> ~/.inputrc && \
echo "set output-meta on" >> ~/.inputrc && \
echo "set convert-meta off" >> ~/.inputrc && \
bind -f ~/.inputrc 

# Ubuntu repository
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10 && \
echo 'deb http://ftp.daum.net/ubuntu/ trusty main' | tee /etc/apt/sources.list && \
echo 'deb-src http://ftp.daum.net/ubuntu/ trusty main' | tee -a /etc/apt/sources.list && \
echo 'deb http://ftp.daum.net/ubuntu/ trusty-updates main' | tee -a /etc/apt/sources.list && \
echo 'deb-src http://ftp.daum.net/ubuntu/ trusty-updates main' | tee -a /etc/apt/sources.list && \
echo 'deb http://ftp.daum.net/ubuntu/ trusty universe' | tee -a /etc/apt/sources.list && \
echo 'deb-src http://ftp.daum.net/ubuntu/ trusty universe' | tee -a /etc/apt/sources.list && \
echo 'deb http://ftp.daum.net/ubuntu/ trusty-updates universe' | tee -a /etc/apt/sources.list && \
echo 'deb-src http://ftp.daum.net/ubuntu/ trusty-updates universe' | tee -a /etc/apt/sources.list && \
echo 'deb http://ftp.daum.net/ubuntu/ trusty multiverse' | tee -a /etc/apt/sources.list && \
echo 'deb-src http://ftp.daum.net/ubuntu/ trusty multiverse' | tee -a /etc/apt/sources.list && \
echo 'deb http://ftp.daum.net/ubuntu/ trusty-updates multiverse' | tee -a /etc/apt/sources.list && \
echo 'deb-src http://ftp.daum.net/ubuntu/ trusty-updates multiverse' | tee -a /etc/apt/sources.list && \
echo 'deb http://ftp.daum.net/ubuntu/ trusty-backports main restricted universe multiverse' | tee -a /etc/apt/sources.list && \
echo 'deb-src http://ftp.daum.net/ubuntu/ trusty-backports main restricted universe multiverse' | tee -a /etc/apt/sources.list && \
echo 'deb http://security.ubuntu.com/ubuntu trusty-security main' | tee -a /etc/apt/sources.list && \
echo 'deb-src http://security.ubuntu.com/ubuntu trusty-security main' | tee -a /etc/apt/sources.list && \
echo 'deb http://security.ubuntu.com/ubuntu trusty-security universe' | tee -a /etc/apt/sources.list && \
echo 'deb-src http://security.ubuntu.com/ubuntu trusty-security universe' | tee -a /etc/apt/sources.list && \
echo 'deb http://security.ubuntu.com/ubuntu trusty-security multiverse' | tee -a /etc/apt/sources.list && \
echo 'deb-src http://security.ubuntu.com/ubuntu trusty-security multiverse' | tee -a /etc/apt/sources.list && \
echo

# Ubuntu packages
RUN \ 
rm -rf /var/lib/apt/lists/* && apt-get clean && \
apt-get update -y -q && apt-get upgrade -y -q && apt-get dist-upgrade -y -q && \
apt-get install -y -q \
apt-file sudo man ed vim emacs24 curl wget zip unzip bzip2 git htop tmux screen ncdu dos2unix \
gdebi-core make build-essential gfortran libtool autoconf automake pkg-config \
uuid-dev libpgm-dev libpng12-dev libpng++-dev libssh2-1-dev \
libboost-all-dev libclang1 libclang-dev swig \
openssh-server apparmor libapparmor1 libmemcached-dev libcurl4-gnutls-dev libevent-dev \
openssl libssl-dev \
default-jre default-jdk openjdk-7-jdk \
hdf5-tools hdf5-helpers libhdf5-dev \
haskell-platform pandoc \
graphviz imagemagick pdf2svg \ 
fonts-nanum fonts-nanum-coding fonts-nanum-extra ttf-unfonts-core ttf-unfonts-extra \ 
xzdec texlive texlive-latex-base texlive-latex3 texlive-xetex \
texlive-latex-recommended texlive-fonts-recommended \
texlive-lang-cjk ko.tex-base ko.tex-extra-hlfont \
texlive-latex-extra texlive-generic-extra ko.tex-extra \
&& apt-get clean

# Rebuild and istall libpam with --disable-audit option
# RUN apt-get update -y -q && apt-get -y build-dep pam && \
# export CONFIGURE_OPTS=--disable-audit && cd /root && \
# apt-get -b source pam && dpkg -i libpam-doc*.deb libpam-modules*.deb libpam-runtime*.deb libpam0g*.deb

# TTF Fonts
RUN \
echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections && \
apt-get install -y -q ttf-mscorefonts-installer

# ZMQ (master branch)
RUN \
mkdir -p /downloads && cd /downloads && \
git clone https://github.com/zeromq/libzmq.git && cd libzmq && \
./autogen.sh && ./configure && make && make install && ldconfig 

# QuantLib (master branch)
RUN \
mkdir -p /downloads && cd /downloads && \
git clone https://github.com/lballabio/QuantLib.git && cd QuantLib && \
autoreconf --force --install 
RUN cd /downloads/QuantLib && ./configure 
RUN cd /downloads/QuantLib && make 
RUN cd /downloads/QuantLib && make install && ldconfig 
RUN cd /downloads && \
git clone https://github.com/lballabio/QuantLib-SWIG.git && cd QuantLib-SWIG && \
autoreconf --force --install 
RUN cd /downloads/QuantLib-SWIG && ./configure 
RUN cd /downloads/QuantLib-SWIG && make -C Python 
RUN cd /downloads/QuantLib-SWIG && make install -C Python && ldconfig 

# Anaconda2 2.5.0
RUN \
mkdir -p /downloads && cd /downloads && \
wget https://3230d63b5fc54e62148e-c95ac804525aac4b6dba79b00b39d1d3.ssl.cf1.rackcdn.com/Anaconda2-2.5.0-Linux-x86_64.sh && \
/bin/bash /downloads/Anaconda2-2.5.0-Linux-x86_64.sh -b -p /anaconda/
ENV PATH /anaconda/bin:$PATH 
RUN conda update conda && conda update anaconda

# R
RUN \ 
rm -rf /var/lib/apt/lists/* && apt-get clean && apt-get update && \
gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys E084DAB9 && \
gpg -a --export E084DAB9 | apt-key add - && \
echo 'deb http://cran.rstudio.com/bin/linux/ubuntu trusty/' | tee /etc/apt/sources.list.d/R.list && \
echo 'deb http://cran.nexr.com/bin/linux/ubuntu trusty/' | tee -a /etc/apt/sources.list.d/R.list && \
echo 'deb http://cran.biodisk.org/bin/linux/ubuntu trusty/' | tee -a /etc/apt/sources.list.d/R.list && \
echo 'deb http://healthstat.snu.ac.kr/CRAN/bin/linux/ubuntu trusty/' | tee -a /etc/apt/sources.list.d/R.list && \
apt-get update -y -q && \
echo

# RStudio
RUN \
apt-get install -y -q r-base r-base-dev r-cran-rcpp && \
wget https://download2.rstudio.org/rstudio-server-0.99.891-amd64.deb && \
gdebi --n rstudio-server-0.99.891-amd64.deb

# RQuantLib
RUN cd /downloads/QuantLib-SWIG && make -C R && make install -C R && ldconfig 
                  
# R packages
RUN echo 'install.packages(c(\"yaml\",\"devtools\",\"RJSONIO\"),\"/usr/lib/R/library\",repos=\"http://cran.rstudio.com\")' | xargs R --vanilla --slave -e
RUN echo 'source(\"http://bioconductor.org/biocLite.R\");biocLite(\"zlibbioc\")' | xargs R --vanilla --slave -e
RUN echo 'source(\"http://bioconductor.org/biocLite.R\");biocLite(\"rhdf5\")' | xargs R --vanilla --slave -e
RUN echo 'library("devtools");install_github(\"ramnathv/rCharts\")' | xargs R --vanilla --slave -e
RUN echo 'install.packages(c(\"rzmq\",\"repr\",\"IRkernel\",\"IRdisplay\"),\"/usr/lib/R/library\",repos=c(\"http://irkernel.github.io\",\"http://cran.rstudio.com\"))' | xargs R --vanilla --slave -e 
RUN echo 'IRkernel::installspec(user=FALSE)' | xargs R --vanilla --slave -e
RUN echo 'install.packages(\"RQuantLib\",\"/usr/lib/R/library\",repos=\"http://cran.rstudio.com\")' | xargs R --vanilla --slave -e 
RUN echo 'install.packages(c(\"chron\",\"libridate\",\"mondate\",\"timeDate\"),\"/usr/lib/R/library\",repos=\"http://cran.rstudio.com\")' | xargs R --vanilla --slave -e
RUN echo 'install.packages(c(\"knitr\",\"extrafont\",\"DMwR\",\"nortest\",\"tseries\",\"faraway\",\"car\",\"lmtest\",\"dlm\",\"forecast\",\"timeSeries\"),\"/usr/lib/R/library\",repos=\"http://cran.rstudio.com\")' | xargs R --vanilla --slave -e 
RUN echo 'install.packages(c(\"ggplot2\",\"colorspace\",\"plyr\"),\"/usr/lib/R/library\",repos=\"http://cran.rstudio.com\")' | xargs R --vanilla --slave -e
RUN echo 'install.packages(c(\"RMySQL\",\"RMongo\",\"rmongodb\",\"rredis\"),\"/usr/lib/R/library\",repos=\"http://cran.rstudio.com\")' | xargs R --vanilla --slave -e 
RUN echo 'install.packages(c(\"fImport\",\"fBasics\",\"fArma\",\"fGarch\",\"fNonlinear\",\"fUnitRoots\",\"fTrading\",\"fMultivar\",\"fRegression\",\"fExtremes\",\"fCopulae\",\"fBonds\",\"fOptions\",\"fExoticOptions\",\"fAsianOptions\",\"fAssets\",\"fPortfolio\"),\"/usr/lib/R/library\",repos=\"http://cran.rstudio.com\")' | xargs R --vanilla --slave -e
RUN echo 'install.packages(c(\"BLCOP\",\"FKF\",\"ghyp\",\"HyperbolicDist\",\"randtoolbox\",\"rngWELL\",\"schwartz97\",\"SkewHyperbolic\",\"VarianceGamma\",\"stabledist\"),\"/usr/lib/R/library\",repos=\"http://cran.rstudio.com\")' | xargs R --vanilla --slave -e

# Additional Anaconda packages
RUN \
conda install -y \
dateutil django fabric gensim html5lib ipyparallel ipython jedi jinja2 jupyter markdown \
matplotlib nbconvert notebook numpy numpydoc pandas pip psutil pymc pymongo pyzmq \
scipy scikit-image scikit-learn seaborn setuptools simplejson sphinx sphinx_rtd_theme \
statsmodels supervisor tornado twisted ujson virtualenv \
&& echo

# set requests version to 2.8.1
RUN conda install -y 'requests==2.8.1'

# Additional pip packages (including theano and tensorflow) 
RUN \
pip install \
apscheduler django-allauth django-bootstrap3 django-cms docker-py \
fysom JPype1 keras konlpy log4mongo nlpy pelican pudb pweave redis rpy2 typogrify \
&& \
pip install git+git://github.com/Theano/Theano.git && \
pip install https://storage.googleapis.com/tensorflow/linux/cpu/tensorflow-0.7.1-cp27-none-linux_x86_64.whl && \
echo

# clean
RUN \
apt-get clean && \
apt-get autoremove && \
conda clean -y -i -p -s && \
rm -rf /downloads && \
rm -rf /rstudio-server-0.99.891-amd64.deb

# Create user dockeruser:dockeruserpass
RUN \
groupadd --system -r dockeruser -g 1999 && \
adduser --system --uid=1999 --gid=1999 --home /home/dockeruser --shell /bin/bash dockeruser && \
echo dockeruser:dockeruserpass | chpasswd && \
cp /etc/skel/.bashrc /home/dockeruser/.bashrc && source /home/dockeruser/.bashrc && \
adduser dockeruser sudo

# Run RStudio-Server
EXPOSE 8787
RUN (adduser --disabled-password --gecos "" guest && echo "guest:guest"|chpasswd)
RUN mkdir -p /var/log/supervisor
COPY supervisord.conf /etc/supervisord.conf

# Change user to dockeruser
USER dockeruser
WORKDIR /home/dockeruser
ENV HOME /home/dockeruser

# Config IPython and Jupyter notebook
EXPOSE 8888
RUN ipython profile create
COPY ipython_config.py /home/dockeruser/.ipython/profile_default/ipython_config.py
COPY ipython_kernel_config.py /home/dockeruser/.ipython/profile_default/ipython_kernel_config.py
COPY 00.py /home/dockeruser/.ipython/profile_default/startup/00.py
RUN jupyter notebook --generate-config
COPY ipython_notebook_config.py /home/dockeruser/.jupyter/jupyter_notebook_config.py
RUN mkdir -p /home/dockeruser/.cert
COPY mycert.pem /home/dockeruser/.cert/mycert.pem
COPY mykey.key /home/dockeruser/.cert/mykey.key

USER root
RUN chown dockeruser:dockeruser /var/log/supervisor

# Add Tini. Tini operates as a process subreaper for jupyter. This prevents kernel crashes.
ENV TINI_VERSION v0.6.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/bin/tini
RUN chmod +x /usr/bin/tini

# Set TLS certifates
RUN mkdir -p /etc/pki/tls/certs/ && \
cp /etc/ssl/certs/ca-certificates.crt /etc/pki/tls/certs/ca-bundle.crt

# Run tini and supervisord
ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["/anaconda/bin/supervisord"]

