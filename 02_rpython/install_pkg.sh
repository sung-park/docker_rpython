#!/usr/bin/env bash
echo "reinstall conda to 4.6.14..."
conda install conda=4.6.14 --yes --force-reinstall
echo "install conda packages..."
cat pkgs_conda.txt | paste -sd " " - | xargs conda install --yes
echo "reinstall conda to latest..."
conda update conda -c conda-canary --yes --force-reinstall
echo "install conda-forge packages..."
cat pkgs_conda-forge.txt | paste -sd " " - | xargs conda install --yes -c conda-forge
echo "install pip packages..."
cat pkgs_pip.txt | paste -sd " " - | xargs pip install --progress-bar off
echo "install cleaning..."
conda clean --yes --all
