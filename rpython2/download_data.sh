#!/usr/bin/env bash

cd ~/data/

wget http://www.stat.uiowa.edu/~kchan/TSA/Datasets.zip
mkdir -p ~/data/kchan
unzip Datasets.zip -d ~/data/kchan
rm -rf Datasets.zip

wget http://www.stat.tamu.edu/~sheather/book/docs/datasets/Data.zip
unzip Data.zip -d ~/data/
mv ~/data/Data ~/data/sheather
rm -rf ~/data/Data.zip

python -W ignore -c "from sklearn.datasets import *; fetch_20newsgroups()"
python -W ignore -c "from sklearn.datasets import *; fetch_20newsgroups_vectorized()"
python -W ignore -c "from sklearn.datasets import *; fetch_california_housing()"
python -W ignore -c "from sklearn.datasets import *; fetch_lfw_people()"
python -W ignore -c "from sklearn.datasets import *; fetch_lfw_pairs()"
python -W ignore -c "from sklearn.datasets import *; fetch_olivetti_faces()"
python -W ignore -c "from sklearn.datasets import *; fetch_mldata('MNIST original')"

git clone https://github.com/luispedro/BuildingMachineLearningSystemsWithPython.git
git clone https://github.com/gmonce/scikit-learn-book.git
git clone https://github.com/e9t/nsmc.git
git clone https://github.com/yhilpisch/py4fi.git
git clone https://github.com/mnielsen/neural-networks-and-deep-learning.git

# RUN cd ~/data/ && wget -r -nH -np "http://deeplearning.net/tutorial/code/" -P ~/data/ -A "*.py" -R "robot.txt"

wget http://examples.oreilly.com/0636920023784/pydata-book-master.zip
unzip ~/data/pydata-book-master.zip -d ~/data/
rm -rf ~/data/pydata-book-master.zip

# MNIST raw data
mkdir -p ~/data/mnist
cd ~/data/mnist
wget http://yann.lecun.com/exdb/mnist/train-images-idx3-ubyte.gz && gunzip train-images-idx3-ubyte.gz
wget http://yann.lecun.com/exdb/mnist/train-labels-idx1-ubyte.gz && gunzip train-labels-idx1-ubyte.gz
wget http://yann.lecun.com/exdb/mnist/t10k-images-idx3-ubyte.gz  && gunzip t10k-images-idx3-ubyte.gz
wget http://yann.lecun.com/exdb/mnist/t10k-labels-idx1-ubyte.gz  && gunzip t10k-labels-idx1-ubyte.gz
cd ~/data

# 20 Newsgroup raw data
wget http://people.csail.mit.edu/jrennie/20Newsgroups/20news-18828.tar.gz && tar xvf 20news-18828.tar.gz && rm -f 20news-18828.tar.gz

