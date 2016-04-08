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
ENV REPO kr.archive.ubuntu.com
# ENV REPO ftp.daum.net
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10 && \
echo "deb     http://$REPO/ubuntu/ trusty main"                                          | tee    /etc/apt/sources.list && \
echo "deb-src http://$REPO/ubuntu/ trusty main"                                          | tee -a /etc/apt/sources.list && \
echo "deb     http://$REPO/ubuntu/ trusty-updates main"                                  | tee -a /etc/apt/sources.list && \
echo "deb-src http://$REPO/ubuntu/ trusty-updates main"                                  | tee -a /etc/apt/sources.list && \
echo "deb     http://$REPO/ubuntu/ trusty universe"                                      | tee -a /etc/apt/sources.list && \
echo "deb-src http://$REPO/ubuntu/ trusty universe"                                      | tee -a /etc/apt/sources.list && \
echo "deb     http://$REPO/ubuntu/ trusty-updates universe"                              | tee -a /etc/apt/sources.list && \
echo "deb-src http://$REPO/ubuntu/ trusty-updates universe"                              | tee -a /etc/apt/sources.list && \
echo "deb     http://$REPO/ubuntu/ trusty multiverse"                                    | tee -a /etc/apt/sources.list && \
echo "deb-src http://$REPO/ubuntu/ trusty multiverse"                                    | tee -a /etc/apt/sources.list && \
echo "deb     http://$REPO/ubuntu/ trusty-updates multiverse"                            | tee -a /etc/apt/sources.list && \
echo "deb-src http://$REPO/ubuntu/ trusty-updates multiverse"                            | tee -a /etc/apt/sources.list && \
echo "deb     http://$REPO/ubuntu/ trusty-backports main restricted universe multiverse" | tee -a /etc/apt/sources.list && \
echo "deb-src http://$REPO/ubuntu/ trusty-backports main restricted universe multiverse" | tee -a /etc/apt/sources.list && \
echo "deb     http://security.ubuntu.com/ubuntu trusty-security main"                    | tee -a /etc/apt/sources.list && \
echo "deb-src http://security.ubuntu.com/ubuntu trusty-security main"                    | tee -a /etc/apt/sources.list && \
echo "deb     http://security.ubuntu.com/ubuntu trusty-security universe"                | tee -a /etc/apt/sources.list && \
echo "deb-src http://security.ubuntu.com/ubuntu trusty-security universe"                | tee -a /etc/apt/sources.list && \
echo "deb     http://security.ubuntu.com/ubuntu trusty-security multiverse"              | tee -a /etc/apt/sources.list && \
echo "deb-src http://security.ubuntu.com/ubuntu trusty-security multiverse"              | tee -a /etc/apt/sources.list && \
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

# login profile
COPY .bash_profile /home/$USER_ID/
RUN chown -R $USER_ID /home/$USER_ID/

################################################################################
# Python
################################################################################

# Change user to $USER_ID
USER $USER_ID
WORKDIR /home/$USER_ID
ENV HOME /home/$USER_ID

# Anaconda2 2.5.0
RUN mkdir -p ~/downloads && cd ~/downloads && \ 
wget https://3230d63b5fc54e62148e-c95ac804525aac4b6dba79b00b39d1d3.ssl.cf1.rackcdn.com/Anaconda2-2.5.0-Linux-x86_64.sh
RUN /bin/bash ~/downloads/Anaconda2-2.5.0-Linux-x86_64.sh -b
ENV PATH /home/$USER_ID/anaconda2/bin:$PATH 
RUN conda update conda && conda update anaconda

# Python Packages
################################################################################

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
################################################################################

# Bash kernel 
RUN python -m bash_kernel.install

# IJavascript kernel
USER root
RUN npm install -g npm@latest
RUN npm install -g ijavascript && ijs --ijs-install=global
USER $USER_ID

RUN ipython profile create 
COPY ipython_config.py /home/$USER_ID/.ipython/profile_default/ipython_config.py
COPY ipython_kernel_config.py /home/$USER_ID/.ipython/profile_default/ipython_kernel_config.py
COPY 00.py /home/$USER_ID/.ipython/profile_default/startup/00.py
COPY jupyter_notebook_config.py /home/$USER_ID/jupyter_notebook_config.py
RUN jupyter notebook --generate-config && \
mv /home/$USER_ID/jupyter_notebook_config.py /home/$USER_ID/.jupyter/jupyter_notebook_config.py
USER root
RUN chown -R $USER_ID:$USER_ID /home/$USER_ID/.jupyter/
RUN chmod -R u+rwx /home/$USER_ID/.jupyter/ 
USER $USER_ID

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

# install nbextensions
RUN pip install https://github.com/ipython-contrib/IPython-notebook-extensions/archive/master.zip

# Prevent config conflict
RUN mv /home/$USER_ID/.jupyter/jupyter_notebook_config.json /home/$USER_ID/.jupyter/jupyter_notebook_config.json.old

# upgrade MathJax
USER root
RUN \
cd ~/anaconda2/lib/python2.7/site-packages/notebook/static/components && \
wget https://github.com/mathjax/MathJax/archive/master.zip && \
unzip master.zip && \
mv MathJax MathJax-old && \
mv MathJax-master MathJax
USER $USER_ID

################################################################################
# R packages  
################################################################################

USER root
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
USER $USER_ID

################################################################################
# Supervisor Settings
################################################################################

USER root
RUN chown $USER_ID:$USER_ID /var/log/supervisor

# Set TLS certifates
RUN mkdir -p /etc/pki/tls/certs/ && \
cp /etc/ssl/certs/ca-certificates.crt /etc/pki/tls/certs/ca-bundle.crt

USER $USER_ID

################################################################################
# Clean
################################################################################

USER root

RUN \
apt-get clean && \
apt-get autoremove && \
rm -rf /downloads && \
rm -rf /rstudio-server-0.99.891-amd64.deb

USER $USER_ID

RUN \
conda clean -y -i -p -s && \
rm -rf ~/downloads

################################################################################
# User Env
################################################################################

USER $USER_ID
RUN echo "export LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lz=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.axa=00;36:*.oga=00;36:*.spx=00;36:*.xspf=00;36:'" | tee -a /home/$USER_ID/.bashrc 
COPY .bash_profile /home/$USER_ID/

################################################################################
# Run
################################################################################

USER root
# Add Tini. Tini operates as a process subreaper for jupyter. This prevents kernel crashes.
ENV TINI_VERSION v0.6.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/bin/tini
RUN chmod a+x /usr/bin/tini

# Fix RStudio bug
# see https://support.rstudio.com/hc/en-us/community/posts/202190728-install-rstudio-server-error
RUN echo "server-app-armor-enabled=0" | tee -a /etc/rstudio/rserver.conf 

USER $USER_ID
EXPOSE 8888
ADD ".docker-entrypoint.sh" "/home/$USER_ID/"
ENTRYPOINT ["/usr/bin/tini", "--", "/bin/bash", ".docker-entrypoint.sh"]
