FROM datascienceschool/ubuntu_nosql:latest
MAINTAINER "Joel Kim" admin@datascienceschool.net

################################################################################
# R
################################################################################
RUN \
gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys E084DAB9 && \
gpg -a --export E084DAB9 | apt-key add - && \
echo 'deb http://cran.rstudio.com/bin/linux/ubuntu xenial/' | tee /etc/apt/sources.list.d/R.list && \
echo 'deb http://healthstat.snu.ac.kr/CRAN/bin/linux/ubuntu xenial/' | tee -a /etc/apt/sources.list.d/R.list && \
apt-get update -y -q && \
echo

# R and RStudio-server
ENV RSTUDIOSERVER_VERSION 1.1.442
RUN \
apt-get install -y -q r-base r-base-dev && \
mkdir -p /download && cd /download && \
wget https://download2.rstudio.org/rstudio-server-${RSTUDIOSERVER_VERSION}-amd64.deb && \
gdebi --n rstudio-server-${RSTUDIOSERVER_VERSION}-amd64.deb && \
rm -rf /download

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
echo 'install.packages(c(\"nlme\",\"nloptr\",\"nnet\",\"openssl\",\"pbdzmq\",\"pbkrtest\",\"plyr\",\"quantmod\",\"quantreg\"),repos=\"http://cran.rstudio.com\",clean=TRUE)' | xargs R --vanilla --slave -e && \
echo 'install.packages(c(\"r6\",\"randomforest\",\"rbokeh\",\"rcolorbrewer\",\"rcpp\",\"rcppeigen\",\"recommended\",\"repr\",\"reshape2\",\"rmarkdown\",\"rpart\"),repos=\"http://cran.rstudio.com\",clean=TRUE)' | xargs R --vanilla --slave -e && \
echo 'install.packages(c(\"scales\",\"shiny\",\"sparsem\",\"spatial\",\"stringi\",\"stringr\",\"survival\",\"tibble\",\"tidyr\",\"ttr\"),repos=\"http://cran.rstudio.com\",clean=TRUE)' | xargs R --vanilla --slave -e && \
echo 'install.packages(c(\"uuid\",\"xtable\",\"xts\",\"yaml\",\"zoo\"),repos=\"http://cran.rstudio.com\",clean=TRUE)' | xargs R --vanilla --slave -e && \
echo 'install.packages(c(\"yaml\",\"crayon\",\"pbdZMQ\",\"devtools\",\"RJSONIO\"),repos=\"http://cran.rstudio.com\",clean=TRUE)' | xargs R --vanilla --slave -e && \
echo 'install.packages(c(\"chron\",\"libridate\",\"mondate\",\"timeDate\"),repos=\"http://cran.rstudio.com\",clean=TRUE)' | xargs R --vanilla --slave -e && \
echo 'install.packages(c(\"knitr\",\"extrafont\",\"DMwR\",\"nortest\",\"tseries\",\"faraway\",\"car\",\"lmtest\",\"dlm\",\"forecast\",\"timeSeries\"),repos=\"http://cran.rstudio.com\",clean=TRUE)' | xargs R --vanilla --slave -e  && \
echo 'install.packages(c(\"ggplot2\",\"colorspace\"),repos=\"http://cran.rstudio.com\",clean=TRUE)' | xargs R --vanilla --slave -e && \
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
# User Account
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
cp /etc/skel/.profile /home/$USER_ID/.profile && source /home/$USER_ID/.profile && \
chown $USER_ID:$USER_ID /home/$USER_ID/.*  && \
adduser $USER_ID sudo

# login profile
COPY .bash_profile /home/$USER_ID/
RUN chown $USER_ID:$USER_ID /home/$USER_ID/.*

USER $USER_ID
RUN \
echo "export LANG='en_US.UTF-8'" | tee -a /home/$USER_ID/.bashrc  && \
echo "export LANGUAGE='en_US.UTF-8'" | tee -a /home/$USER_ID/.bashrc  && \
echo "export LC_ALL='en_US.UTF-8'" | tee -a /home/$USER_ID/.bashrc  && \
echo "export TZ='Asia/Seoul'" | tee -a /home/$USER_ID/.bashrc  && \
echo "export TERM='xterm'" | tee -a /home/$USER_ID/.bashrc  && \
echo "set input-meta on" >> /home/$USER_ID/.inputrc && \
echo "set output-meta on" >> /home/$USER_ID/.inputrc && \
echo "set convert-meta off" >> /home/$USER_ID/.inputrc && \
echo "export LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lz=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.axa=00;36:*.oga=00;36:*.spx=00;36:*.xspf=00;36:'" | tee -a /home/$USER_ID/.bashrc

################################################################################
# Node.js
################################################################################

USER root
RUN \
curl -sL https://deb.nodesource.com/setup_8.x -o nodesource_setup.sh && \
/bin/bash nodesource_setup.sh && \
DEBIAN_FRONTEND=noninteractive apt-get install -y -q nodejs && \
rm -rf nodesource_setup.sh && \
npm install -g npm@latest && \
npm install -g --unsafe-perm ijavascript && \
echo ""

################################################################################
# Python
################################################################################

# Anaconda config
ENV ANACONDA_PATH /home/$USER_ID/anaconda3
ENV ANACONDA_INSTALLER Anaconda3-5.1.0-Linux-x86_64.sh

# add path to root account
ENV PATH $ANACONDA_PATH/bin:$PATH

# Change user to $USER_ID
USER $USER_ID
WORKDIR /home/$USER_ID
ENV HOME /home/$USER_ID
ENV PATH $ANACONDA_PATH/bin:$PATH
RUN \
echo "export PATH=$PATH:$ANACONDA_PATH/bin" | tee -a /home/$USER_ID/.bashrc

# Anaconda install
RUN \
mkdir -p ~/download && cd ~/download && \
wget http://repo.continuum.io/archive/$ANACONDA_INSTALLER && \
/bin/bash ~/download/$ANACONDA_INSTALLER -b && \
conda update --yes conda && \
conda update --yes anaconda && \
conda update --yes --all

################################################################################
# Python Packages
################################################################################

RUN \
conda install --yes \
anaconda \
anaconda-client \
anaconda-clean \
blaze \
bleach \
bokeh \
boto \
boto3 \
chainer \
coverage \
CVXcanon \
cvxopt \
datashader \
dill \
distributed \
docopt \
ecos \
feedparser \
fiona \
future \
gcc_linux-64 \
gensim \
geopandas \
graphviz \
holoviews \
html5lib \
ipyparallel \
ipython \
ipywidgets \
jupyter \
keras \
libgcc \
matplotlib \
notebook=5.4.0 \
numpy \
pandas \
pandas-datareader \
pillow \
pip \
protobuf \
psycopg2 \
pydot \
pymc3 \
pymongo \
pyproj \
pytables \
python-dateutil \
python-graphviz \
pyzmq \
quandl \
regex \
requests \
rtree \
scipy \
scikit-image \
scikit-learn \
scrapy \
seaborn \
service_identity \
setuptools \
shapely \
statsmodels \
tensorboard \
tensorflow \
theano \
tqdm \
ujson \
unidecode \
virtualenv \
xarray \
&& \
conda install --yes -c conda-forge \
autopep8 \
descartes \
filterpy \
geojson \
geopy \
imbalanced-learn \
iris \
JPype1 \
jupyter_contrib_nbextensions \
jupyter_nbextensions_configurator \
librosa \
pudb \
pysoundfile \
scikit-plot \
scikit-surprise \
widgetsnbextension \
xgboost \
&& \
conda install --yes -c ioam geoviews && \
conda install --yes -c soumith pytorch torchvision && \
pip install --upgrade pip && \
pip install --no-cache-dir \
awscli \
cvxpy \
FRB \
fred \
fredapi \
hangulize \
konlpy \
nlpy \
picklable_itertools \
q \
wbdata \
wbpy \
zipline \
&& \
pip install --no-cache-dir git+https://github.com/bashtage/arch.git && \
pip install --no-cache-dir git+https://github.com/hmmlearn/hmmlearn.git && \
pip install --no-cache-dir git+https://github.com/openai/gym.git && \
pip install --no-cache-dir git+https://github.com/keras-team/keras-contrib.git && \
pip install --no-cache-dir git+https://github.com/pgmpy/pgmpy.git && \
conda clean --yes --all && \
rm -rf ~/download

# tensorboard port
EXPOSE 6006

# QuantLib-python
ENV QUANTLIBSWIG QuantLib-SWIG
ENV QUANTLIBSWIGVER 1.12
RUN \
mkdir -p ~/download && cd ~/download && \
wget -O $QUANTLIBSWIG-$QUANTLIBSWIGVER.tar.gz https://bintray.com/quantlib/releases/download_file?file_path=$QUANTLIBSWIG-$QUANTLIBSWIGVER.tar.gz && \
tar xzf $QUANTLIBSWIG-$QUANTLIBSWIGVER.tar.gz && \
cd $QUANTLIBSWIG-$QUANTLIBSWIGVER && \
./configure && make -C Python && make -C Python install && make clean && rm -rf ~/download/

# TA-Lib
USER root

RUN mkdir -p /download && cd /download && \
wget http://downloads.sourceforge.net/project/ta-lib/ta-lib/0.4.0/ta-lib-0.4.0-src.tar.gz && \
tar xzf ta-lib-0.4.0-src.tar.gz && \
cd ta-lib && \
./configure --prefix=/usr && make && make install && rm -rf /download/

USER $USER_ID
# temporary block for numpy error
# RUN pip install --no-cache-dir TA-Lib

################################################################################
# Jupyter Notebook Settings
################################################################################

EXPOSE 8888

RUN ipython profile create
COPY ipython_config.py /home/$USER_ID/.ipython/profile_default/ipython_config.py
COPY ipython_kernel_config.py /home/$USER_ID/.ipython/profile_default/ipython_kernel_config.py
COPY 00.py /home/$USER_ID/.ipython/profile_default/startup/00.py

RUN jupyter notebook --generate-config
USER root
RUN \
chown -R $USER_ID:$USER_ID /home/$USER_ID/.jupyter && \
chmod -R 755 /home/$USER_ID/.jupyter

USER $USER_ID
RUN \
echo "c.NotebookApp.notebook_dir = u\"/home/$USER_ID\"" | tee -a /home/$USER_ID/.jupyter/jupyter_notebook_config.py && \
echo "c.NotebookApp.token = u\"\"" | tee -a /home/$USER_ID/.jupyter/jupyter_notebook_config.py && \
echo "c.NotebookApp.password = u\"\"" | tee -a /home/$USER_ID/.jupyter/jupyter_notebook_config.py && \
echo "c.NotebookApp.iopub_data_rate_limit = 10000000" | tee -a /home/$USER_ID/.jupyter/jupyter_notebook_config.py

# enable ipyparallel
USER $USER_ID

# install ipython magics
RUN pip install git+git://github.com/joelkim/ipython-tikzmagic.git && echo

# Node.js kernel
RUN ijsinstall

# R kernel
USER root
RUN \
echo 'install.packages(c(\"rzmq\",\"repr\",\"IRdisplay\"),repos=c(\"http://irkernel.github.io\",\"http://cran.rstudio.com\"))' | xargs R --vanilla --slave -e && \
echo 'install.packages(\"IRkernel\",repos=c(\"http://irkernel.github.io\",\"http://cran.rstudio.com\"))' | xargs R --vanilla --slave -e && \
echo 'library("devtools");install_github(\"IRkernel/IRkernel\")' | xargs R --vanilla --slave -e && \
echo 'IRkernel::installspec(name=\"ir33\",displayname=\"R\",user=FALSE)' | xargs R --vanilla --slave -e && \
echo

################################################################################
# Julia
################################################################################
ENV JULIA_VER 0.6
ENV JULIA_TAR julia-0.6.2-linux-x86_64.tar.gz
RUN \
cd /home/$USER_ID/ && \
wget https://julialang-s3.julialang.org/bin/linux/x64/$JULIA_VER/$JULIA_TAR && \
tar xzf $JULIA_TAR && \
mv julia-d386e40c17 juila && \
rm -rf $JULIA_TAR

# add path
ENV PATH $PATH:/home/$USER_ID/juila/bin
RUN echo "export PATH=$PATH:/home/$USER_ID/juila/bin" | tee -a /home/$USER_ID/.bashrc

# IJulia
RUN julia -e "ENV[\"PYTHON\"] = \"$ANACONDA_PATH/bin/python\"; Pkg.update(); Pkg.add(\"IJulia\")"

################################################################################
# Set TLS certifates
################################################################################

USER root
RUN mkdir -p /etc/pki/tls/certs/ && \
cp /etc/ssl/certs/ca-certificates.crt /etc/pki/tls/certs/ca-bundle.crt

################################################################################
# Postgresql Settings
################################################################################

USER root
ADD "./.postgres_db_setup.sql" "/home/$USER_ID/"

EXPOSE 5432

################################################################################
# Supervisor Settings
################################################################################

USER root
COPY supervisord.conf /etc/supervisor/supervisord.conf
RUN \
sed -i "s/USER_ID/$USER_ID/g" /etc/supervisor/supervisord.conf  && \
mkdir -p /var/log/supervisor  && \
chown $USER_ID:$USER_ID /var/log/supervisor

################################################################################
# Fixture
################################################################################

# temporary bug fix: https://github.com/ipython/ipython/issues/8374#issuecomment-371232658
RUN conda install --yes tornado=4.5.3

# temponary fix for ipyparallel-notebook bug
RUN conda install --yes notebook=5.4.0

################################################################################
# Run
################################################################################

ADD "./.docker-entrypoint.sh" "/home/$USER_ID/"

# fix ownership
USER root

RUN \
chown syslog:syslog /etc/rsyslog.conf && \
chown $USER_ID:$USER_ID /home/$USER_ID/.*  && \
chown $USER_ID:$USER_ID /home/$USER_ID/*  && \
chown -R $USER_ID:$USER_ID /home/$USER_ID/.ipython  && \
chown -R $USER_ID:$USER_ID /home/$USER_ID/.jupyter  && \
chown -R $USER_ID:$USER_ID /home/$USER_ID/.local && \
chown -R $USER_ID:$USER_ID $ANACONDA_PATH && \
echo ""

# Jupyter notebook extension setting
USER $USER_ID
RUN \
jupyter contrib nbextension install --user && \
jupyter nbextensions_configurator enable --user && \
jupyter nbextension enable --py widgetsnbextension && \
jupyter nbextension install --user --py ipyparallel  && \
jupyter nbextension enable --user --py ipyparallel && \
jupyter serverextension enable --user --py ipyparallel && \
ipcluster nbextension enable --user && \
jupyter serverextension enable ipyparallel.nbextension

# Add Tini. Tini operates as a process subreaper for jupyter. This prevents kernel crashes.
USER root
ADD https://github.com/krallin/tini/releases/download/v0.17.0/tini /usr/bin/tini
RUN chmod a+x /usr/bin/tini

ENTRYPOINT ["/usr/bin/tini", "--", "/bin/bash", ".docker-entrypoint.sh"]
