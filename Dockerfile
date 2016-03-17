FROM ubuntu:latest
MAINTAINER "Joel Kim" admin@datascienceschool.net

# Set environment
ENV TERM xterm
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

################################################################################
# Basic Softwares
################################################################################

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

RUN \ 
rm -rf /var/lib/apt/lists/* && apt-get clean && \
apt-get update -y -q && apt-get upgrade -y -q && apt-get dist-upgrade -y -q && \
apt-get install -y -q \
apt-file sudo man ed vim emacs24 curl wget zip unzip bzip2 git htop tmux screen ncdu dos2unix \
gdebi-core make build-essential gfortran libtool autoconf automake pkg-config \
software-properties-common \
libboost-all-dev libclang1 libclang-dev swig libcurl4-gnutls-dev \
uuid-dev libpgm-dev libpng12-dev libpng++-dev libevent-dev \
openssh-server apparmor libapparmor1 libssh2-1-dev openssl libssl-dev \
default-jre default-jdk openjdk-7-jdk \
hdf5-tools hdf5-helpers libhdf5-dev \
nodejs-legacy npm \
haskell-platform pandoc \
graphviz imagemagick pdf2svg \ 
fonts-nanum fonts-nanum-coding fonts-nanum-extra ttf-unfonts-core ttf-unfonts-extra \ 
xzdec texlive texlive-latex-base texlive-latex3 texlive-xetex \
texlive-latex-recommended texlive-fonts-recommended \
texlive-lang-cjk ko.tex-base ko.tex-extra-hlfont ko.tex-extra \
&& apt-get clean

# TTF Fonts
RUN \
echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections && \
apt-get install -y -q ttf-mscorefonts-installer

# ZMQ (master branch)
RUN \
mkdir -p /downloads && cd /downloads && \
git clone https://github.com/zeromq/libzmq.git && cd libzmq && \
./autogen.sh && ./configure && make && make install && ldconfig 

################################################################################
# Python
################################################################################
# Anaconda2 2.5.0
RUN \
mkdir -p /downloads && cd /downloads && \
wget https://3230d63b5fc54e62148e-c95ac804525aac4b6dba79b00b39d1d3.ssl.cf1.rackcdn.com/Anaconda2-2.5.0-Linux-x86_64.sh && \
/bin/bash /downloads/Anaconda2-2.5.0-Linux-x86_64.sh -b -p /anaconda/
ENV PATH /anaconda/bin:$PATH 
RUN conda update conda && conda update anaconda

################################################################################
# R
################################################################################
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

# RStudio-server
RUN \
apt-get install -y -q r-base r-base-dev r-cran-rcpp && \
wget https://download2.rstudio.org/rstudio-server-0.99.891-amd64.deb && \
gdebi --n rstudio-server-0.99.891-amd64.deb

# Settings for RStudio-Server
EXPOSE 8787
RUN mkdir -p /var/log/supervisor
COPY supervisord.conf /etc/supervisord.conf

################################################################################
# Python packages
################################################################################
# Additional Anaconda packages
RUN \
conda install -y \
dateutil gensim ipyparallel ipython jupyter \
matplotlib notebook numpy pandas pip pymc pymongo pytables pyzmq \
scipy scikit-image scikit-learn seaborn setuptools statsmodels supervisor \
virtualenv \
&& echo

# set requests version to 2.8.1
RUN conda install -y 'requests==2.8.1'

# Additional pip packages (including theano and tensorflow) 
RUN \
pip install \
bash_kernel filterpy fysom JPype1 keras konlpy nlpy pudb rpy2 \
&& \
pip install git+https://github.com/pymc-devs/pymc3 && \
pip install git+https://github.com/Theano/Theano && \
pip install https://storage.googleapis.com/tensorflow/linux/cpu/tensorflow-0.7.1-cp27-none-linux_x86_64.whl && \
echo

# Jupyter Notebook Kernels

# Bash kernel 
RUN \
/anaconda/bin/python -m bash_kernel.install

# IJavascript kernel
RUN \
npm install -g ijavascript && \
ijs --ijs-install=global

################################################################################
# R packages
################################################################################
RUN echo 'install.packages(c(\"yaml\",\"devtools\",\"RJSONIO\"),\"/usr/lib/R/library\",repos=\"http://cran.rstudio.com\")' | xargs R --vanilla --slave -e
RUN echo 'source(\"http://bioconductor.org/biocLite.R\");biocLite(\"zlibbioc\")' | xargs R --vanilla --slave -e
RUN echo 'source(\"http://bioconductor.org/biocLite.R\");biocLite(\"rhdf5\")' | xargs R --vanilla --slave -e
RUN echo 'library("devtools");install_github(\"ramnathv/rCharts\")' | xargs R --vanilla --slave -e
RUN echo 'install.packages(c(\"rzmq\",\"repr\",\"IRkernel\",\"IRdisplay\"),\"/usr/lib/R/library\",repos=c(\"http://irkernel.github.io\",\"http://cran.rstudio.com\"))' | xargs R --vanilla --slave -e 
RUN echo 'IRkernel::installspec(user=FALSE)' | xargs R --vanilla --slave -e
RUN echo 'install.packages(c(\"chron\",\"libridate\",\"mondate\",\"timeDate\"),\"/usr/lib/R/library\",repos=\"http://cran.rstudio.com\")' | xargs R --vanilla --slave -e
RUN echo 'install.packages(c(\"knitr\",\"extrafont\",\"DMwR\",\"nortest\",\"tseries\",\"faraway\",\"car\",\"lmtest\",\"dlm\",\"forecast\",\"timeSeries\"),\"/usr/lib/R/library\",repos=\"http://cran.rstudio.com\")' | xargs R --vanilla --slave -e 
RUN echo 'install.packages(c(\"ggplot2\",\"colorspace\",\"plyr\"),\"/usr/lib/R/library\",repos=\"http://cran.rstudio.com\")' | xargs R --vanilla --slave -e
RUN echo 'install.packages(c(\"fImport\",\"fBasics\",\"fArma\",\"fGarch\",\"fNonlinear\",\"fUnitRoots\",\"fTrading\",\"fMultivar\",\"fRegression\",\"fExtremes\",\"fCopulae\",\"fBonds\",\"fOptions\",\"fExoticOptions\",\"fAsianOptions\",\"fAssets\",\"fPortfolio\"),\"/usr/lib/R/library\",repos=\"http://cran.rstudio.com\")' | xargs R --vanilla --slave -e
RUN echo 'install.packages(c(\"BLCOP\",\"FKF\",\"ghyp\",\"HyperbolicDist\",\"randtoolbox\",\"rngWELL\",\"schwartz97\",\"SkewHyperbolic\",\"VarianceGamma\",\"stabledist\"),\"/usr/lib/R/library\",repos=\"http://cran.rstudio.com\")' | xargs R --vanilla --slave -e

################################################################################
# clean
################################################################################
RUN \
apt-get clean && \
apt-get autoremove && \
conda clean -y -i -p -s && \
rm -rf /downloads && \
rm -rf /rstudio-server-0.99.891-amd64.deb


################################################################################
# User
################################################################################

# Create user 
ARG USER_ID=dockeruser
ENV USER_ID $USER_ID
ARG USER_PASS=dockeruserpass
ENV USER_PASS $USER_PASS
ARG USER_UID=1999
ENV USER_UID $USER_UID
ARG USER_GID=1999
ENV USER_GID $USER_GID

RUN \
groupadd --system -r $USER_ID -g $USER_GID && \
adduser --system --uid=$USER_UID --gid=$USER_GID --home /home/$USER_ID --shell /bin/bash $USER_ID && \
echo $USER_ID:$USER_PASS | chpasswd && \
cp /etc/skel/.bashrc /home/$USER_ID/.bashrc && source /home/$USER_ID/.bashrc && \
adduser $USER_ID sudo

################################################################################
# Jupyter Settings
################################################################################

COPY jupyter_notebook_config.py /home/$USER_ID/jupyter_notebook_config.py
RUN chown $USER_ID:$USER_ID /home/$USER_ID/jupyter_notebook_config.py

# Change user to $USER_ID
USER $USER_ID
WORKDIR /home/$USER_ID
ENV HOME /home/$USER_ID

# Config IPython and Jupyter notebook
# create certificate
# see http://jupyter-notebook.readthedocs.org/en/latest/public_server.html
EXPOSE 8888
RUN ipython profile create 
COPY ipython_config.py /home/$USER_ID/.ipython/profile_default/ipython_config.py
COPY ipython_kernel_config.py /home/$USER_ID/.ipython/profile_default/ipython_kernel_config.py
COPY 00.py /home/$USER_ID/.ipython/profile_default/startup/00.py

RUN jupyter notebook --generate-config && \
mv /home/$USER_ID/jupyter_notebook_config.py /home/$USER_ID/.jupyter/jupyter_notebook_config.py
RUN \
echo "c.NotebookApp.password = u\"$(python -c "from notebook.auth import passwd; print passwd(\"$USER_PASS\")")\"" | tee -a /home/$USER_ID/.jupyter/jupyter_notebook_config.py && \
echo "c.NotebookApp.keyfile = u\"/home/$USER_ID/.cert/mykey.key\"" | tee -a /home/$USER_ID/.jupyter/jupyter_notebook_config.py && \
echo "c.NotebookApp.certfile = u\"/home/$USER_ID/.cert/mycert.pem\"" | tee -a /home/$USER_ID/.jupyter/jupyter_notebook_config.py && \
echo "c.NotebookApp.notebook_dir = u\"/home/$USER_ID\"" | tee -a /home/$USER_ID/.jupyter/jupyter_notebook_config.py && \
echo

RUN \
mkdir -p /home/$USER_ID/.cert && \
cd /home/$USER_ID/.cert && \
openssl req -x509 -nodes -days 365 -newkey rsa:1024 -keyout mykey.key -out mycert.pem -subj "/C=''/ST=''/L=''/O=''/CN=''" -passout pass:$USER_PASS 

################################################################################
# ITorch 
################################################################################

USER root
RUN \
mkdir -p /torch && \
git clone https://github.com/torch/distro.git /torch --recursive && \
cd /torch && bash install-deps && ./install.sh

RUN \
mkdir -p /downloads && cd /downloads && \
git clone https://github.com/facebook/iTorch.git && \
cd /downloads/iTorch && /torch/install/bin/luarocks make

RUN chown -R $USER_ID $(dirname $(ipython locate profile)) 

################################################################################
# Supervisor Settings
################################################################################

USER root
RUN chown $USER_ID:$USER_ID /var/log/supervisor

# Add Tini. Tini operates as a process subreaper for jupyter. This prevents kernel crashes.
ENV TINI_VERSION v0.6.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/bin/tini
RUN chmod +x /usr/bin/tini

# Set TLS certifates
RUN mkdir -p /etc/pki/tls/certs/ && \
cp /etc/ssl/certs/ca-certificates.crt /etc/pki/tls/certs/ca-bundle.crt


################################################################################
# Run
################################################################################

ADD ".docker-entrypoint.sh" "/home/$USER_ID/"
ENTRYPOINT ["/usr/bin/tini", "--", "/bin/bash", ".docker-entrypoint.sh"]

