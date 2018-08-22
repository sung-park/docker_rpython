FROM ubuntu:16.04
MAINTAINER "Joel Kim" admin@datascienceschool.net

# Replace sh with bash
RUN cd /bin && rm sh && ln -s bash sh

# Ubuntu repository in Korea
ENV REPO http://kr.archive.ubuntu.com/ubuntu/
# ENV REPO http://ftp.neowiz.com/ubuntu/
# in China,
# ENV REPO http://mirrors.aliyun.com/ubuntu/

RUN \
echo "deb $REPO xenial main"                                          | tee    /etc/apt/sources.list && \
echo "deb $REPO xenial-updates main"                                  | tee -a /etc/apt/sources.list && \
echo "deb $REPO xenial universe"                                      | tee -a /etc/apt/sources.list && \
echo "deb $REPO xenial-updates universe"                              | tee -a /etc/apt/sources.list && \
echo "deb $REPO xenial multiverse"                                    | tee -a /etc/apt/sources.list && \
echo "deb $REPO xenial-updates multiverse"                            | tee -a /etc/apt/sources.list && \
echo "deb $REPO xenial-backports main restricted universe multiverse" | tee -a /etc/apt/sources.list && \
echo "deb $REPO xenial-security main"                                 | tee -a /etc/apt/sources.list && \
echo "deb $REPO xenial-security universe"                             | tee -a /etc/apt/sources.list && \
echo "deb $REPO xenial-security multiverse"                           | tee -a /etc/apt/sources.list && \
echo

# Set environment
RUN \
rm -rf /var/lib/apt/lists/* && \
rm -rf /var/lib/apt/lists/partial/* && \
DEBIAN_FRONTEND=noninteractive apt-get update -y -q && \
DEBIAN_FRONTEND=noninteractive apt-get upgrade -y -q && \
DEBIAN_FRONTEND=noninteractive apt-get install -y -q --no-install-recommends apt-utils && \
DEBIAN_FRONTEND=noninteractive apt-get install -y -q locales sudo wget && \
locale-gen en_US.UTF-8

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

# Console colors
RUN echo "export LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lz=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.axa=00;36:*.oga=00;36:*.spx=00;36:*.xspf=00;36:'" | tee -a /root/.bashrc

################################################################################
# Ubuntu Packages and Libraries
################################################################################

# Ubuntu packages
RUN \
rm -rf /var/lib/apt/lists/* && \
rm -rf /var/lib/apt/lists/partial/* && \
DEBIAN_FRONTEND=noninteractive apt-get clean && \
DEBIAN_FRONTEND=noninteractive apt-get update && \
DEBIAN_FRONTEND=noninteractive apt-get upgrade -y -q && \
DEBIAN_FRONTEND=noninteractive apt-get install -y -q \
apparmor \
apt-file \
autoconf \
automake \
build-essential \
bzip2 \
cmake \
curl \
default-jdk \
default-jre \
dos2unix \
ed \
emacs24 \
fonts-humor-sans \
fonts-nanum \
fonts-nanum-coding \
fonts-nanum-extra \
gdebi-core \
gettext \
gfortran \
git \
graphviz \
haskell-platform \
hdf5-helpers \
hdf5-tools \
htop \
imagemagick \
ko.tex-base \
ko.tex-extra \
ko.tex-extra-hlfont \
libapparmor1 \
libboost-all-dev \
libclang-dev \
libclang1 \
libcupti-dev \
libcurl4-gnutls-dev \
libevent-dev \
libgdal-dev \
libgeos-dev \
libgflags-dev \
libgoogle-glog-dev \
libgtest-dev \
libhdf5-dev \
libiomp-dev \
libjpeg-dev \
libleveldb-dev \
liblmdb-dev \
libopencv-dev \
libpgm-dev \
libpng++-dev \
libpng-dev \
libpng12-dev \
libpq-dev \
libprotobuf-dev \
libspatialindex-dev \
libspatialindex-dev \
libssh2-1-dev \
libssl-dev \
libtiff5-dev \
libtool \
make \
man \
memcached \
mercurial \
ncdu \
net-tools \
nginx \
openbox \
openssh-server \
openssl \
pandoc \
pdf2svg \
pkg-config \
postgresql \
postgresql-contrib \
protobuf-compiler \
rsyslog \
screen \
software-properties-common \
sudo \
supervisor \
swig \
texlive \
texlive-fonts-recommended \
texlive-lang-cjk \
texlive-latex-base \
texlive-latex-recommended \
texlive-latex3 \
texlive-pictures \
texlive-xetex \
tmux \
tree \
ttf-unfonts-core \
ttf-unfonts-extra \
unzip \
uuid-dev \
vim \
wget \
wireshark \
wkhtmltopdf \
x11-apps \
xauth \
xdm \
xorg \
xvfb \
xzdec \
zip \
&& \
echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections && \
apt-get install -y -q ttf-mscorefonts-installer && \
mkdir -p /download && cd /download && \
mkdir -p /usr/share/fonts/opentype && \
chmod a+rwx -R /usr/share/fonts/* && \
fc-cache -fv && \
rm -rf /download && \
DEBIAN_FRONTEND=noninteractive apt-get -y -q --purge remove tex.\*-doc$ && \
DEBIAN_FRONTEND=noninteractive apt-get clean

################################################################################
# SSH service
################################################################################

ARG HTTPS_COMMENT=#
ENV HTTPS_COMMENT $HTTPS_COMMENT

RUN \
mkdir -p /var/run/sshd  && \
sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
ENV NOTVISIBLE "in users profile"
RUN \
sed 's@session\s*required\s*pam_loginuid.so@ses$HTTPS_COMMENTsion optional pam_loginuid.so@g' -i /etc/pam.d/sshd && \
echo "export VISIBLE=now" >> /etc/profile && \
echo -e  'y\n' | /usr/bin/ssh-keygen -q -t rsa -f /etc/ssh/ssh_host_rsa_key -C '' -N ''  && \
echo -e  'y\n' | /usr/bin/ssh-keygen -q -t rsa -f /etc/ssh/ssh_host_dsa_key -C '' -N ''

EXPOSE 22

################################################################################
# Docker Entrypoint
################################################################################

ENTRYPOINT ["/bin/bash"]
