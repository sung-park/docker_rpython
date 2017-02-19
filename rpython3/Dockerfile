FROM ubuntu:16.04
MAINTAINER "Joel Kim" admin@datascienceschool.net

# Replace sh with bash
RUN cd /bin && rm sh && ln -s bash sh

# Set environment
RUN locale-gen en_US.UTF-8

ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV LC_COLLATE C
ENV TERM xterm
ENV HOME /root
ENV TZ Asia/Seoul

# Config for unicode input/output
RUN \
echo "set input-meta on" >> ~/.inputrc && \
echo "set output-meta on" >> ~/.inputrc && \
echo "set convert-meta off" >> ~/.inputrc && \
echo

################################################################################
# Basic Softwares
################################################################################

# Ubuntu repository
ENV REPO kr.archive.ubuntu.com/ubuntu/
# ENV REPO ftp.daumkakao.com/ubuntu/

RUN \
echo "deb http://$REPO xenial main"                                          | tee    /etc/apt/sources.list && \
echo "deb http://$REPO xenial-updates main"                                  | tee -a /etc/apt/sources.list && \
echo "deb http://$REPO xenial universe"                                      | tee -a /etc/apt/sources.list && \
echo "deb http://$REPO xenial-updates universe"                              | tee -a /etc/apt/sources.list && \
echo "deb http://$REPO xenial multiverse"                                    | tee -a /etc/apt/sources.list && \
echo "deb http://$REPO xenial-updates multiverse"                            | tee -a /etc/apt/sources.list && \
echo "deb http://$REPO xenial-backports main restricted universe multiverse" | tee -a /etc/apt/sources.list && \
echo "deb http://$REPO xenial-security main"                                 | tee -a /etc/apt/sources.list && \
echo "deb http://$REPO xenial-security universe"                             | tee -a /etc/apt/sources.list && \
echo "deb http://$REPO xenial-security multiverse"                           | tee -a /etc/apt/sources.list && \
echo

# Ubuntu packages
RUN \
rm -rf /var/lib/apt/lists/* && \
rm -rf /var/lib/apt/lists/partial/* && \
DEBIAN_FRONTEND=noninteractive apt-get clean && \
DEBIAN_FRONTEND=noninteractive apt-get update && \
DEBIAN_FRONTEND=noninteractive apt-get install -y -q --no-install-recommends apt-utils && \
DEBIAN_FRONTEND=noninteractive apt-get upgrade -y -q && \
DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -y -q && \
DEBIAN_FRONTEND=noninteractive apt-get install -y -q \
apt-file sudo man ed vim emacs24 curl wget zip unzip bzip2 git htop tmux screen ncdu dos2unix \
gdebi-core make build-essential gfortran libtool autoconf automake pkg-config \
software-properties-common \
libboost-all-dev libclang1 libclang-dev swig libcurl4-gnutls-dev libspatialindex-dev libgeos-dev libgdal-dev libspatialindex-dev \
uuid-dev libpgm-dev libpng12-dev libpng++-dev libevent-dev \
openssh-server apparmor libapparmor1 libssh2-1-dev openssl libssl-dev net-tools \
default-jre default-jdk openjdk-7-jdk \
hdf5-tools hdf5-helpers libhdf5-dev \
haskell-platform pandoc \
graphviz imagemagick pdf2svg \
fonts-nanum fonts-nanum-coding fonts-nanum-extra ttf-unfonts-core ttf-unfonts-extra \
xzdec texlive texlive-latex-base texlive-latex3 texlive-xetex texlive-pictures \
texlive-latex-recommended texlive-fonts-recommended \
texlive-lang-cjk ko.tex-base ko.tex-extra-hlfont ko.tex-extra \
xorg openbox xdm xauth x11-apps && \
echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections && \
apt-get install -y -q ttf-mscorefonts-installer && \
mkdir -p /download && cd /download && \
mkdir -p /usr/share/fonts/opentype && \
chmod a+rwx -R /usr/share/fonts/* && \
fc-cache -fv && \
rm -rf /download && \
DEBIAN_FRONTEND=noninteractive apt-get -y -q --purge remove tex.\*-doc$ && \
DEBIAN_FRONTEND=noninteractive apt-get clean

# ZMQ (master branch)
RUN \
mkdir -p /download && cd /download && \
git clone https://github.com/zeromq/libzmq.git && cd libzmq && \
./autogen.sh && ./configure && make && make install && ldconfig && \
rm -rf /download

# QuantLib
RUN \
mkdir -p /download && cd /download && \
wget -O QuantLib-1.8.tar.gz http://download.sourceforge.net/project/quantlib/QuantLib/1.8/QuantLib-1.8.tar.gz && \
tar xzf QuantLib-1.8.tar.gz && \
cd QuantLib-1.8 && \
./configure && make && make install && ldconfig && make clean && \
cd /usr/local/lib && strip --strip-unneeded libQuantLib.a && \
rm -rf /download


################################################################################
# R
################################################################################
RUN \
rm -rf /var/lib/apt/lists/* && apt-get clean && apt-get update && \
gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys E084DAB9 && \
gpg -a --export E084DAB9 | apt-key add - && \
echo 'deb http://cran.rstudio.com/bin/linux/ubuntu xenial/' | tee /etc/apt/sources.list.d/R.list && \
echo 'deb http://cran.nexr.com/bin/linux/ubuntu xenial/' | tee -a /etc/apt/sources.list.d/R.list && \
echo 'deb http://healthstat.snu.ac.kr/CRAN/bin/linux/ubuntu xenial/' | tee -a /etc/apt/sources.list.d/R.list && \
apt-get update -y -q && \
echo

# R and RStudio-server
RUN \
apt-get install -y -q r-base r-base-dev r-cran-rcpp && \
wget https://download2.rstudio.org/rstudio-server-1.0.136-amd64.deb && \
gdebi --n rstudio-server-1.0.136-amd64.deb && \
rm -rf /rstudio-server-1.0.136-amd64.deb

# Disable app-armor
# see https://support.rstudio.com/hc/en-us/community/posts/202190728-install-rstudio-server-error
RUN echo "server-app-armor-enabled=0" | tee -a /etc/rstudio/rserver.conf

# Settings for RStudio-Server
EXPOSE 8787

# enable R package install
RUN chmod a+w /usr/local/lib/R/site-library

# packages
RUN \
echo 'install.packages(c(\"assertthat\",\"base\",\"base64enc\",\"BH\",\"bitops\",\"boot\"),repos=\"http://cran.rstudio.com\",clean=TRUE)' | xargs R --vanilla --slave -e && \
echo 'install.packages(c(\"car\",\"caret\",\"catools\",\"chron\",\"class\",\"cluster\",\"codetools\",\"colorspace\",\"curl\",\"data.table\"),repos=\"http://cran.rstudio.com\",clean=TRUE)' | xargs R --vanilla --slave -e && \
echo 'install.packages(c(\"DBI\",\"dichromat\",\"digest\",\"dplyr\",\"evaluate\",\"foreach\",\"foreign\",\"formatr\"),repos=\"http://cran.rstudio.com\",clean=TRUE)' | xargs R --vanilla --slave -e && \
echo 'install.packages(c(\"ggplot2\",\"gistr\",\"glmnet\",\"gtable\",\"hexbin\",\"highr\",\"htmltools\",\"htmlwidgets\",\"httpuv\",\"httr\",\"iterators\"),repos=\"http://cran.rstudio.com\",clean=TRUE)' | xargs R --vanilla --slave -e && \
echo 'install.packages(c(\"jsonlite\",\"kernsmooth\",\"knitr\",\"labeling\",\"lattice\",\"lazyeval\",\"lme4\"),repos=\"http://cran.rstudio.com\",clean=TRUE)' | xargs R --vanilla --slave -e && \
echo 'install.packages(c(\"magrittr\",\"maps\",\"markdown\",\"mass\",\"matrix\",\"matrixmodels\",\"mgcv\",\"mime\",\"minqa\",\"munsell\"),repos=\"http://cran.rstudio.com\",clean=TRUE)' | xargs R --vanilla --slave -e && \
echo 'install.packages(c(\"nlme\",\"nloptr\",\"nnet\",\"openssl\",\"pbdzmq\",\"pbkrtest\",\"plyr\",\"pryr\",\"quantmod\",\"quantreg\"),repos=\"http://cran.rstudio.com\",clean=TRUE)' | xargs R --vanilla --slave -e && \
echo 'install.packages(c(\"r6\",\"randomforest\",\"rbokeh\",\"rcolorbrewer\",\"rcpp\",\"rcppeigen\",\"recommended\",\"repr\",\"reshape2\",\"rmarkdown\",\"rpart\"),repos=\"http://cran.rstudio.com\",clean=TRUE)' | xargs R --vanilla --slave -e && \
echo 'install.packages(c(\"scales\",\"shiny\",\"sparsem\",\"spatial\",\"stringi\",\"stringr\",\"survival\",\"tibble\",\"tidyr\",\"ttr\"),repos=\"http://cran.rstudio.com\",clean=TRUE)' | xargs R --vanilla --slave -e && \
echo 'install.packages(c(\"uuid\",\"xtable\",\"xts\",\"yaml\",\"zoo\"),repos=\"http://cran.rstudio.com\",clean=TRUE)' | xargs R --vanilla --slave -e && \
echo 'install.packages(c(\"yaml\",\"crayon\",\"pbdZMQ\",\"devtools\",\"RJSONIO\"),repos=\"http://cran.rstudio.com\",clean=TRUE)' | xargs R --vanilla --slave -e && \
echo 'install.packages(c(\"chron\",\"libridate\",\"mondate\",\"timeDate\"),repos=\"http://cran.rstudio.com\",clean=TRUE)' | xargs R --vanilla --slave -e && \
echo 'install.packages(c(\"knitr\",\"extrafont\",\"DMwR\",\"nortest\",\"tseries\",\"faraway\",\"car\",\"lmtest\",\"dlm\",\"forecast\",\"timeSeries\"),repos=\"http://cran.rstudio.com\",clean=TRUE)' | xargs R --vanilla --slave -e  && \
echo 'install.packages(c(\"ggplot2\",\"colorspace\",\"plyr\"),repos=\"http://cran.rstudio.com\",clean=TRUE)' | xargs R --vanilla --slave -e && \
echo 'install.packages(c(\"fImport\",\"fBasics\",\"fArma\",\"fGarch\",\"fNonlinear\",\"fUnitRoots\",\"fTrading\",\"fMultivar\",\"fRegression\",\"fExtremes\",\"fCopulae\",\"fBonds\",\"fOptions\",\"fExoticOptions\",\"fAsianOptions\",\"fAssets\",\"fPortfolio\"),repos=\"http://cran.rstudio.com\",clean=TRUE)' | xargs R --vanilla --slave -e && \
echo 'install.packages(c(\"BLCOP\",\"FKF\",\"ghyp\",\"HyperbolicDist\",\"randtoolbox\",\"rngWELL\",\"schwartz97\",\"SkewHyperbolic\",\"VarianceGamma\",\"stabledist\"),repos=\"http://cran.rstudio.com\",clean=TRUE)' | xargs R --vanilla --slave -e && \
echo 'install.packages(c(\"e1071\",\"rpart\",\"igraph\",\"nnet\",\"randomForest\",\"caret\",\"kernlab\",\"glmnet\",\"ROCR\",\"gbm\",\"party\",\"tree\",\"klaR\",\"mice\",\"wordcloud\",\"C50\",\"tm\"),repos=\"http://cran.rstudio.com\",clean=TRUE)' | xargs R --vanilla --slave -e && \
echo 'install.packages(c(\"Deriv\",\"plot3D\"),repos=\"http://cran.rstudio.com\",clean=TRUE)' | xargs R --vanilla --slave -e && \
echo 'install.packages(c(\"caret\"),dependencies=c(\"Depends\",\"Suggests\"),repos=\"http://cran.rstudio.com\",clean=TRUE)' | xargs R --vanilla --slave -e && \
echo 'install.packages(c(\"Boruta\",\"C50\",\"CHAID\",\"Cubist\",\"HDclassif\",\"HiDimDA\",\"KRLS\",\"LogicReg\",\"RRF\",\"RSNNS\",\"RWeka\",\"SDDA\",\"ada\",\"adabag\",\"adaptDA\",\"arm\",\"bartMachine\",\"binda\",\"bnclassify\",\"brnn\",\"bst\",\"caTools\",\"class\",\"deepboost\",\"deepnet\",\"earth\",\"elasticnet\",\"elmNN\",\"enpls\",\"evtree\",\"extraTrees\",\"fastAdaboost\",\"fastICA\",\"foba\",\"frbs\",\"gam\",\"glmnet\",\"gpls\",\"hda\",\"ipred\",\"kerndwd\",\"kernlab\",\"kknn\",\"klaR\",\"kohonen\",\"lars\",\"leaps\",\"logicFS\",\"mboost\",\"mda\",\"mgcv\",\"monomvn\",\"mxnet\",\"neuralnet\",\"nnet\",\"nnls\",\"nodeHarvest\",\"oblique.tree\",\"obliqueRF\",\"pamr\",\"partDSA\",\"party\",\"penalized\",\"penalizedLDA\",\"pls\",\"plsRglm\",\"roxy\",\"protoclass\",\"qrnn\",\"quantregForest\",\"rFerns\",\"rPython\",\"randomForest\",\"randomGLM\",\"relaxo\",\"robustDA\",\"rocc\",\"rotationForest\",\"rpart\",\"rqPen\",\"rrcov\",\"rrcovHD\",\"sda\",\"sdwd\",\"snn\",\"sparseLDA\",\"spikeslab\",\"spls\",\"stepPlr\",\"superpc\",\"vbmp\",\"wsrf\",\"xgboost\"),dependencies=c(\"Depends\",\"Suggests\"),repos=\"http://cran.rstudio.com\",clean=TRUE)' | xargs R --vanilla --slave -e && \
echo 'install.packages(c(\"h2o\",\"autoencoder\",\"darch\"),repos=\"http://cran.rstudio.com\",clean=TRUE)' | xargs R --vanilla --slave -e && \
echo 'source(\"http://bioconductor.org/biocLite.R\");biocLite(\"zlibbioc\")' | xargs R --vanilla --slave -e && \
echo 'source(\"http://bioconductor.org/biocLite.R\");biocLite(\"rhdf5\")' | xargs R --vanilla --slave -e && \
echo 'library("devtools");install_github(\"ramnathv/rCharts\")' | xargs R --vanilla --slave -e && \
echo

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

# Anaconda3 4.2.0
ENV PATH /home/$USER_ID/anaconda3/bin:$PATH
RUN \
mkdir -p ~/download && cd ~/download && \
wget https://repo.continuum.io/archive/Anaconda3-4.2.0-Linux-x86_64.sh && \
/bin/bash ~/download/Anaconda3-4.2.0-Linux-x86_64.sh -b && \
conda update conda && conda update anaconda && conda update anaconda-navigator && \
pip install --upgrade pip

# Python Packages
################################################################################

RUN \
conda install -y \
feedparser gensim ipyparallel ipython jupyter \
libgcc matplotlib notebook numpy pandas pip pydot-ng pymc pymongo pytables python-dateutil pyzmq requests \
scipy scikit-image scikit-learn scrapy seaborn service_identity setuptools supervisor unidecode \
virtualenv && \
conda clean -y -i -p -s && \
rm -rf ~/download

# Additional pip packages
RUN \
pip install --no-cache-dir --ignore-installed --upgrade https://storage.googleapis.com/tensorflow/linux/cpu/tensorflow-1.0.0-cp34-cp34m-linux_x86_64.whl && \
pip install --no-cache-dir git+https://github.com/statsmodels/statsmodels.git && \
pip install --no-cache-dir git+https://github.com/pymc-devs/pymc3  && \
pip install --no-cache-dir git+https://github.com/Theano/Theano  && \
pip install --no-cache-dir git+https://github.com/bashtage/arch.git && \
pip install --no-cache-dir \
awscli bash_kernel boto3 filterpy fysom hmmlearn JPype1 keras konlpy nlpy pudb rpy2 pydot \
rtree shapely fiona descartes pyproj \
FRB fred fredapi wbdata wbpy Quandl zipline \
hangulize regex \
&& echo

# tensorboard port
EXPOSE 6006

# QuantLib-python
RUN mkdir -p ~/download && cd ~/download && \
wget http://download.sourceforge.net/project/quantlib/QuantLib/1.8/other%20languages/QuantLib-SWIG-1.8.tar.gz && \
tar xzf QuantLib-SWIG-1.8.tar.gz && \
cd QuantLib-SWIG-1.8 && \
./configure && make -C Python && make -C Python install && make clean && rm -rf ~/download/

# TA-Lib
USER root

RUN mkdir -p /download && cd /download && \
wget http://downloads.sourceforge.net/project/ta-lib/ta-lib/0.4.0/ta-lib-0.4.0-src.tar.gz && \
tar xzf ta-lib-0.4.0-src.tar.gz && \
cd ta-lib && \
./configure --prefix=/usr && make && make install && rm -rf /download/

USER $USER_ID
RUN pip install --no-cache-dir TA-Lib

# Jupyter Notebook Settings
################################################################################

EXPOSE 8888

# Bash kernel
RUN python -m bash_kernel.install

# R kernel
USER root
RUN \
echo 'install.packages(c(\"rzmq\",\"repr\",\"IRdisplay\"),repos=c(\"http://irkernel.github.io\",\"http://cran.rstudio.com\"))' | xargs R --vanilla --slave -e && \
echo 'install.packages(\"IRkernel\",repos=c(\"http://irkernel.github.io\",\"http://cran.rstudio.com\"))' | xargs R --vanilla --slave -e && \
echo 'library("devtools");install_github(\"IRkernel/IRkernel\")' | xargs R --vanilla --slave -e && \
echo 'IRkernel::installspec(name=\"ir33\",displayname=\"R\",user=FALSE)' | xargs R --vanilla --slave -e && \
echo
USER $USER_ID

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

USER $USER_ID

# install ipython magics
RUN pip install git+git://github.com/mkrphys/ipython-tikzmagic.git

# enable ipyparallel
RUN /home/$USER_ID/anaconda3/bin/jupyter serverextension enable --user --py ipyparallel
RUN /home/$USER_ID/anaconda3/bin/jupyter nbextension install --user --py ipyparallel
RUN /home/$USER_ID/anaconda3/bin/jupyter nbextension enable --user --py ipyparallel

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
# User Env
################################################################################

# login profile

USER root
COPY .bash_profile /home/$USER_ID/
RUN chown $USER_ID:$USER_ID /home/$USER_ID/.*
USER $USER_ID
RUN \
echo "export PATH=$PATH:/home/$USER_ID/anaconda3/bin" | tee -a /home/$USER_ID/.bashrc  && \
echo "export LANGUAGE='en_US.UTF-8'" | tee -a /home/$USER_ID/.bashrc  && \
echo "export LC_ALL='en_US.UTF-8'" | tee -a /home/$USER_ID/.bashrc  && \
echo "export TZ='Asia/Seoul'" | tee -a /home/$USER_ID/.bashrc  && \
echo "export TERM='xterm'" | tee -a /home/$USER_ID/.bashrc  && \
echo "export LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lz=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.axa=00;36:*.oga=00;36:*.spx=00;36:*.xspf=00;36:'" | tee -a /home/$USER_ID/.bashrc && \
echo "set input-meta on" >> ~/.inputrc && \
echo "set output-meta on" >> ~/.inputrc && \
echo "set convert-meta off" >> ~/.inputrc && \
bind -f ~/.inputrc && \
echo

################################################################################
# Dataset
################################################################################

COPY download_data.sh /home/$USER_ID/data/download_data.sh

################################################################################
# add ssh service
################################################################################

USER root

RUN mkdir /var/run/sshd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22


################################################################################
# Additional packages
################################################################################

################################################################################
# Run
################################################################################

# Add Tini. Tini operates as a process subreaper for jupyter. This prevents kernel crashes.
ADD https://github.com/krallin/tini/releases/download/v0.10.0/tini /usr/bin/tini
RUN chmod a+x /usr/bin/tini

ADD ".docker-entrypoint.sh" "/home/$USER_ID/"
RUN chown $USER_ID:$USER_ID /home/$USER_ID/.*
RUN chown $USER_ID:$USER_ID /home/$USER_ID/*

RUN chown -R $USER_ID:$USER_ID /home/$USER_ID/.ipython
RUN chown -R $USER_ID:$USER_ID /home/$USER_ID/.jupyter
RUN chown -R $USER_ID:$USER_ID /home/$USER_ID/.local

USER root

# change R package ownership
# RUN chown -R $USER_ID:$USER_ID /usr/local/lib/R/site-library
# fix R cpp version conflict
# RUN rm -rf /usr/lib/R/site-library/Rcpp

ENTRYPOINT ["/usr/bin/tini", "--", "/bin/bash", ".docker-entrypoint.sh"]
