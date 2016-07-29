FROM ubuntu:14.04
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
# ENV REPO kr.archive.ubuntu.com
ENV REPO ftp.daum.net
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
libboost-all-dev libclang1 libclang-dev swig libcurl4-gnutls-dev libspatialindex-dev libgeos-dev libgdal-dev \
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

# Fonts
RUN \
echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections && \
apt-get install -y -q ttf-mscorefonts-installer

RUN \
mkdir -p /downloads && cd /downloads && \
wget -O NotoSansCJKkr-hinted.zip https://noto-website-2.storage.googleapis.com/pkgs/NotoSansCJKkr-hinted.zip && \
unzip -d NotoSansCJKkr-hinted NotoSansCJKkr-hinted.zip && \
mkdir -p /usr/share/fonts/opentype && \
mv -fv ./NotoSansCJKkr-hinted /usr/share/fonts/opentype/NotoSansCJKkr-hinted && \
rm -rfv NotoSansCJKkr-hinted.zip

RUN chmod a+rwx -R /usr/share/fonts/* && fc-cache -fv

# ZMQ (master branch)
RUN \
mkdir -p /downloads && cd /downloads && \
git clone https://github.com/zeromq/libzmq.git && cd libzmq && \
./autogen.sh && ./configure && make && make install && ldconfig 

# QuantLib

RUN \
mkdir -p /downloads && cd /downloads && \
wget -O QuantLib-1.8.tar.gz http://downloads.sourceforge.net/project/quantlib/QuantLib/1.8/QuantLib-1.8.tar.gz && \
tar xzf QuantLib-1.8.tar.gz && \
cd QuantLib-1.8 && \
./configure && make && make install && ldconfig && make clean 
RUN rm -rf /downloads/QuantLib-1.8


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

# R and RStudio-server
RUN \
apt-get install -y -q r-base r-base-dev r-cran-rcpp && \
wget https://download2.rstudio.org/rstudio-server-0.99.903-amd64.deb && \
gdebi --n rstudio-server-0.99.903-amd64.deb

# Disable app-armor
# see https://support.rstudio.com/hc/en-us/community/posts/202190728-install-rstudio-server-error
RUN echo "server-app-armor-enabled=0" | tee -a /etc/rstudio/rserver.conf

# Settings for RStudio-Server
EXPOSE 8787

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
ARG HTTPS_COMMENT=#
ENV HTTPS_COMMENT $HTTPS_COMMENT

RUN \
groupadd --system -r $USER_ID -g $USER_GID && \
adduser --system --uid=$USER_UID --gid=$USER_GID --home /home/$USER_ID --shell /bin/bash $USER_ID && \
echo $USER_ID:$USER_PASS | chpasswd && \
cp /etc/skel/.bashrc /home/$USER_ID/.bashrc && source /home/$USER_ID/.bashrc && \
adduser $USER_ID sudo

################################################################################
# Python
################################################################################

# Change user to $USER_ID
USER $USER_ID
WORKDIR /home/$USER_ID
ENV HOME /home/$USER_ID

# Anaconda2 4.1.1
RUN mkdir -p ~/downloads && cd ~/downloads && \ 
wget http://repo.continuum.io/archive/Anaconda2-4.1.1-Linux-x86_64.sh
RUN /bin/bash ~/downloads/Anaconda2-4.1.1-Linux-x86_64.sh -b
ENV PATH /home/$USER_ID/anaconda2/bin:$PATH 
RUN conda update conda && conda update anaconda
RUN pip install --upgrade pip

# Python Packages
################################################################################

RUN \
conda install -y \
dateutil feedparser gensim ipyparallel ipython jupyter \
matplotlib notebook numpy pandas pip pydot-ng pymc pymongo pytables pyzmq requests \
scipy scikit-image scikit-learn scrapy seaborn service_identity setuptools supervisor unidecode \
virtualenv \
&& echo

# Additional pip packages
RUN pip install git+https://github.com/statsmodels/statsmodels.git
RUN pip install git+https://github.com/pymc-devs/pymc3 
RUN pip install git+https://github.com/Theano/Theano 
RUN pip install https://storage.googleapis.com/tensorflow/linux/cpu/tensorflow-0.8.0-cp27-none-linux_x86_64.whl
RUN pip install bash_kernel filterpy fysom hmmlearn JPype1 keras konlpy nlpy pudb rpy2 pydot
RUN pip install rtree shapely fiona descartes pyproj
RUN pip install FRB fred fredapi wbdata wbpy Quandl zipline pandasdmx
RUN pip install hangulize regex
RUN pip install git+https://github.com/bashtage/arch.git

# QuantLib-python

RUN mkdir -p ~/downloads && cd ~/downloads && \ 
wget http://downloads.sourceforge.net/project/quantlib/QuantLib/1.8/other%20languages/QuantLib-SWIG-1.8.tar.gz && \
tar xzf QuantLib-SWIG-1.8.tar.gz && \
cd QuantLib-SWIG-1.8 && \
./configure && make -C Python && make -C Python install && make clean
RUN rm -rf ~/downloads/QuantLib-SWIG-1.8

# TA-Lib

USER root

RUN mkdir -p /downloads && cd /downloads && \
wget http://prdownloads.sourceforge.net/ta-lib/ta-lib-0.4.0-src.tar.gz && \
tar xzf ta-lib-0.4.0-src.tar.gz && \
cd ta-lib && \
./configure --prefix=/usr && make && make install
RUN rm -rf /downloads/ta-lib

USER $USER_ID

RUN pip install TA-Lib


# Jupyter Notebook Settings
################################################################################

EXPOSE 8888

# Bash kernel 
RUN python -m bash_kernel.install

RUN ipython profile create 
COPY ipython_config.py /home/$USER_ID/.ipython/profile_default/ipython_config.py
COPY ipython_kernel_config.py /home/$USER_ID/.ipython/profile_default/ipython_kernel_config.py
COPY 00.py /home/$USER_ID/.ipython/profile_default/startup/00.py
USER root
RUN chown -R $USER_ID:$USER_ID /home/$USER_ID/.ipython/
USER $USER_ID

RUN jupyter notebook --generate-config 
COPY jupyter_notebook_config.py /home/$USER_ID/jupyter_notebook_config.py
RUN mv /home/$USER_ID/jupyter_notebook_config.py /home/$USER_ID/.jupyter/jupyter_notebook_config.py
USER root
RUN chown -R $USER_ID:$USER_ID /home/$USER_ID/.jupyter/
USER $USER_ID

RUN echo "c.NotebookApp.notebook_dir = u\"/home/$USER_ID\"" | tee -a /home/$USER_ID/.jupyter/jupyter_notebook_config.py 

# add certificate
RUN \
echo "${HTTPS_COMMENT}c.NotebookApp.password = u\"$(python -c "from notebook.auth import passwd; print passwd(\"$USER_PASS\")")\"" | tee -a /home/$USER_ID/.jupyter/jupyter_notebook_config.py && \
echo "${HTTPS_COMMENT}c.NotebookApp.keyfile = u\"/home/$USER_ID/.cert/mykey.key\"" | tee -a /home/$USER_ID/.jupyter/jupyter_notebook_config.py && \
echo "${HTTPS_COMMENT}c.NotebookApp.certfile = u\"/home/$USER_ID/.cert/mycert.pem\"" | tee -a /home/$USER_ID/.jupyter/jupyter_notebook_config.py && \
mkdir -p /home/$USER_ID/.cert && cd /home/$USER_ID/.cert && \
openssl req -x509 -nodes -days 365 -newkey rsa:1024 -keyout mykey.key -out mycert.pem -subj "/C=KR/ST=SEOUL/L=SEOUL/O=DATA SCIENCE SCHOOL/CN=datascienceschool.net" -passout pass:$USER_PASS

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
# Supervisor Settings
################################################################################

USER root
COPY supervisord.conf /etc/supervisord.conf
RUN echo "user=$USER_ID" | tee -a /etc/supervisord.conf
RUN mkdir -p /var/log/supervisor
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
rm -rf /rstudio-server-0.99.893-amd64.deb

USER $USER_ID

RUN conda clean -y -i -p -s && \
rm -rf ~/downloads

################################################################################
# User Env
################################################################################

# login profile

USER root

COPY .bash_profile /home/$USER_ID/
RUN chown $USER_ID:$USER_ID /home/$USER_ID/.*

USER $USER_ID

RUN echo "export PATH=$PATH:/home/$USER_ID/anaconda2/bin" | tee -a /home/$USER_ID/.bashrc 
RUN echo "TZ='Asia/Seoul'; export TZ" | tee -a /home/$USER_ID/.bashrc 
RUN echo "export LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lz=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.axa=00;36:*.oga=00;36:*.spx=00;36:*.xspf=00;36:'" | tee -a /home/$USER_ID/.bashrc 

################################################################################
# Additional Python Packages
################################################################################

################################################################################
# R Packages
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


################################################################################
# Dataset
################################################################################

USER $USER_ID

RUN wget http://www.stat.uiowa.edu/~kchan/TSA/Datasets.zip
RUN mkdir -p /home/$USER_ID/data/kchan
RUN unzip /home/$USER_ID/Datasets.zip -d /home/$USER_ID/data/kchan
RUN rm -rf /home/$USER_ID/Datasets.zip

RUN wget http://www.stat.tamu.edu/~sheather/book/docs/datasets/Data.zip
RUN unzip /home/$USER_ID/Data.zip -d /home/$USER_ID/data/
RUN mv /home/$USER_ID/data/Data /home/$USER_ID/data/sheather
RUN rm -rf /home/$USER_ID/Data.zip

RUN python -W ignore -c "from sklearn.datasets import *; fetch_20newsgroups()"
RUN python -W ignore -c "from sklearn.datasets import *; fetch_20newsgroups_vectorized()"
RUN python -W ignore -c "from sklearn.datasets import *; fetch_california_housing()"
RUN python -W ignore -c "from sklearn.datasets import *; fetch_lfw_people()"
RUN python -W ignore -c "from sklearn.datasets import *; fetch_lfw_pairs()"
RUN python -W ignore -c "from sklearn.datasets import *; fetch_olivetti_faces()"
RUN python -W ignore -c "from sklearn.datasets import *; fetch_mldata('MNIST original')"
#RUN python -W ignore -c "import nltk; nltk.download('all')"

RUN cd /home/$USER_ID/data/ && git clone https://github.com/luispedro/BuildingMachineLearningSystemsWithPython.git
RUN cd /home/$USER_ID/data/ && git clone https://github.com/gmonce/scikit-learn-book.git
RUN cd /home/$USER_ID/data/ && git clone https://github.com/e9t/nsmc.git
RUN cd /home/$USER_ID/data/ && git clone https://github.com/yhilpisch/py4fi.git
RUN cd /home/$USER_ID/data/ && git clone https://github.com/mnielsen/neural-networks-and-deep-learning.git

# RUN cd /home/$USER_ID/data/ && wget -r -nH -np "http://deeplearning.net/tutorial/code/" -P /home/$USER_ID/data/ -A "*.py" -R "robot.txt"

RUN wget http://examples.oreilly.com/0636920023784/pydata-book-master.zip
RUN unzip /home/$USER_ID/pydata-book-master.zip -d /home/$USER_ID/data/
RUN rm -rf /home/$USER_ID/pydata-book-master.zip

USER root

################################################################################
# Run
################################################################################

# Add Tini. Tini operates as a process subreaper for jupyter. This prevents kernel crashes.
ENV TINI_VERSION v0.6.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/bin/tini
RUN chmod a+x /usr/bin/tini

ADD ".docker-entrypoint.sh" "/home/$USER_ID/"
RUN chown $USER_ID:$USER_ID /home/$USER_ID/.*

RUN chown $USER_ID:$USER_ID /home/$USER_ID/*
RUN chown -R $USER_ID:$USER_ID /home/$USER_ID/.ipython
RUN chown -R $USER_ID:$USER_ID /home/$USER_ID/.jupyter
RUN chown -R $USER_ID:$USER_ID /home/$USER_ID/.local

# enable ipyparallel
USER $USER_ID
RUN /home/$USER_ID/anaconda2/bin/jupyter serverextension enable --user --py ipyparallel
RUN /home/$USER_ID/anaconda2/bin/jupyter nbextension install --user --py ipyparallel
RUN /home/$USER_ID/anaconda2/bin/jupyter nbextension enable --user --py ipyparallel
USER root

ENTRYPOINT ["/usr/bin/tini", "--", "/bin/bash", ".docker-entrypoint.sh"]
