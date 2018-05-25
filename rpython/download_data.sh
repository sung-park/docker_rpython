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

git clone https://github.com/luispedro/BuildingMachineLearningSystemsWithPython.git
git clone https://github.com/gmonce/scikit-learn-book.git
git clone https://github.com/e9t/nsmc.git
git clone https://github.com/yhilpisch/py4fi.git
git clone https://github.com/mnielsen/neural-networks-and-deep-learning.git

wget http://examples.oreilly.com/0636920023784/pydata-book-master.zip
unzip ~/data/pydata-book-master.zip -d ~/data/
rm -rf ~/data/pydata-book-master.zip
