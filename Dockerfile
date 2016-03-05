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

# Ubuntu packages
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

RUN \ 
rm -rf /var/lib/apt/lists/* && apt-get clean && \
apt-get update -y -q && apt-get upgrade -y -q && apt-get dist-upgrade -y -q && \
apt-get install -y -q \
apt-file sudo man ed vim emacs24 curl wget zip unzip bzip2 git htop tmux screen ncdu dos2unix \
gdebi-core make build-essential gfortran libtool autoconf automake pkg-config \
uuid-dev libpgm-dev libpng12-dev libpng++-dev libssh2-1-dev \
libboost-all-dev libclang1 libclang-dev swig \
openssh-server libapparmor1 libmemcached-dev libcurl4-gnutls-dev libevent-dev \
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

# TTF Fonts
RUN \
echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections && \
apt-get install -y -q ttf-mscorefonts-installer

# ZMQ master
RUN \
mkdir -p /downloads && cd /downloads && \
git clone https://github.com/zeromq/libzmq.git && cd libzmq && \
./autogen.sh && ./configure && make && make install && ldconfig 

# Anaconda2 2.5.0
RUN \
mkdir -p /downloads && cd /downloads && \
wget https://3230d63b5fc54e62148e-c95ac804525aac4b6dba79b00b39d1d3.ssl.cf1.rackcdn.com/Anaconda2-2.5.0-Linux-x86_64.sh && \
/bin/bash /downloads/Anaconda2-2.5.0-Linux-x86_64.sh -b -p /anaconda/
ENV PATH /anaconda/bin:$PATH 
RUN conda update conda && conda update anaconda

# Additional Anaconda packages
RUN \
conda install -y \
dateutil django fabric gensim ipyparallel ipython jedi jinja2 jupyter markdown \
matplotlib notebook numpy numpydoc pandas pip psutil pymc pymongo pyzmq \
scipy scikit-image scikit-learn seaborn setuptools simplejson sphinx sphinx_rtd_theme \
statsmodels tornado twisted ujson virtualenv \
&& echo

# set requests version to 2.8.1
RUN conda install -y 'requests==2.8.1'

# Additional pip packages
RUN \
pip install \
apscheduler django-allauth django-bootstrap3 django-cms docker-py \
fysom JPype1 keras konlpy log4mongo nlpy pelican pudb pweave redis typogrify \
&& \
pip install git+git://github.com/Theano/Theano.git && \
pip install https://storage.googleapis.com/tensorflow/linux/cpu/tensorflow-0.7.1-cp27-none-linux_x86_64.whl && \
echo

# Create user dockeruser:dockeruserpass
RUN \
groupadd --system -r dockeruser -g 1999 && \
adduser --system --uid=1999 --gid=1999 --home /home/dockeruser --shell /bin/bash dockeruser && \
echo dockeruser:dockeruserpass | chpasswd

# QuantLib
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
apt-get install -y -q r-base r-base-dev && \
wget https://download2.rstudio.org/rstudio-server-0.99.891-amd64.deb && \
gdebi --n rstudio-server-0.99.891-amd64.deb

# RQuantLib
RUN cd /downloads/QuantLib-SWIG && make -C R && make install -C R && ldconfig 
                  
# R packages
RUN \
echo 'install.packages(c(\"RMySQL\",\"RMongo\",\"rmongodb\",\"rredis\"),\"/usr/lib/R/library\",repos=\"http://cran.rstudio.com\")' | xargs R --vanilla --slave -e && \
echo 'install.packages(c(\"fImport\",\"fBasics\",\"fArma\",\"fGarch\",\"fNonlinear\",\"fUnitRoots\",\"fTrading\",\"fMultivar\",\"fRegression\",\"fExtremes\",\"fCopulae\",\"fBonds\",\"fOptions\",\"fExoticOptions\",\"fAsianOptions\",\"fAssets\",\"fPortfolio\",\"BLCOP\",\"FKF\",\"ghyp\",\"HyperbolicDist\",\"randtoolbox\",\"rngWELL\",\"schwartz97\",\"SkewHyperbolic\",\"VarianceGamma\",\"stabledist\"),\"/usr/lib/R/library\",repos=\"http://cran.rstudio.com\")' | xargs R --vanilla --slave -e && \
echo 'install.packages(c(\"chron\",\"libridate\",\"mondate\",\"timeDate\"),\"/usr/lib/R/library\",repos=\"http://cran.rstudio.com\")' | xargs R --vanilla --slave -e && \
echo 'install.packages(c(\"ggplot2\",\"colorspace\"),\"/usr/lib/R/library\",repos=\"http://cran.rstudio.com\")' | xargs R --vanilla --slave -e && \
echo 'install.packages(c(\"knitr\",\"extrafont\",\"DMwR\",\"nortest\",\"tseries\",\"faraway\",\"car\",\"lmtest\",\"dlm\",\"forecast\",\"timeSeries\"),\"/usr/lib/R/library\",repos=\"http://cran.rstudio.com\")' | xargs R --vanilla --slave -e && \
echo 'install.packages(\"RQuantLib\",\"/usr/lib/R/library\",repos=\"http://cran.rstudio.com\")' | xargs R --vanilla --slave -e && \
echo 'install.packages(c(\"devtools\",\"RJSONIO\"),\"/usr/lib/R/library\",repos=\"http://cran.rstudio.com\")' | xargs R --vanilla --slave -e && \
echo 'install.packages(\"yaml\",\"/usr/lib/R/library\",repos=\"http://cran.rstudio.com\")' | xargs R --vanilla --slave -e && \
echo 'source(\"http://bioconductor.org/biocLite.R\");biocLite(\"zlibbioc\")' | xargs R --vanilla --slave -e && \
echo 'source(\"http://bioconductor.org/biocLite.R\");biocLite(\"rhdf5\")' | xargs R --vanilla --slave -e && \
echo 'install.packages(c(\"devtools\"),\"/usr/lib/R/library\",repos=\"http://cran.rstudio.com\")' | xargs R --vanilla --slave -e && \
echo 'library("devtools");install_github(\"rCharts\",\"ramnathv\")' | xargs R --vanilla --slave -e && \
echo 'install.packages(c(\"rzmq\",\"repr\",\"IRkernel\",\"IRdisplay\"),\"/usr/lib/R/library\",repos=c(\"http://irkernel.github.io\",\"http://cran.rstudio.com\"))' | xargs R --vanilla --slave -e && \ 
echo 'IRkernel::installspec(user=FALSE)' | xargs R --vanilla --slave -e 

# rpy2
RUN pip install rpy2 

# Change user to dockeruser
USER dockeruser
WORKDIR /home/dockeruser
ENV HOME /home/dockeruser

# Config IPython and Jupyter notebook
RUN ipython profile create
COPY ipython_config.py /home/dockeruser/.ipython/profile_default/ipython_config.py
COPY ipython_kernel_config.py /home/dockeruser/.ipython/profile_default/ipython_kernel_config.py
COPY 00.py /home/dockeruser/.ipython/profile_default/startup/00.py
RUN jupyter notebook --generate-config
COPY ipython_notebook_config.py /home/dockeruser/.jupyter/jupyter_notebook_config.py
COPY mycert.pem /home/dockeruser/mycert.pem
COPY mykey.key /home/dockeruser/mykey.key

# Add Tini. Tini operates as a process subreaper for jupyter. This prevents kernel crashes.
ENV TINI_VERSION v0.6.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/bin/tini
USER root
RUN chmod +x /usr/bin/tini

ENTRYPOINT ["/usr/bin/tini", "--"]
EXPOSE 8888
VOLUME ["/host"]

CMD ["jupyter", "notebook", "--port=8888", "--no-browser", "--ip=0.0.0.0", "--notebook-dir=/host", "--certfile=mycert.pem", "--keyfile mykey.key"]

# clean
RUN chown -R dockeruser:dockeruser /home/dockeruser && \
rm -rf /downloads && rm -rf /home/dockeruser/rstudio-server-0.99.891-amd64.deb

# change user
USER dockeruser

# Run .bashrc
RUN cp /etc/skel/.bashrc /home/dockeruser/.bashrc && source /home/dockeruser/.bashrc
