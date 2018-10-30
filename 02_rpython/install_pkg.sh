cat pkgs_conda.txt       | paste -sd " " - | xargs conda install --yes -c anaconda
cat pkgs_conda-forge.txt | paste -sd " " - | xargs conda install --yes -c conda-forge
conda install --yes -c ioam    geoviews
conda install --yes -c pytorch pytorch torchvision
cat pkgs_pip.txt | paste -sd " " - | xargs pip install
conda clean --yes --all
