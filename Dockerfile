# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.
ARG BASE_CONTAINER=crosscompass/ihaskell-notebook@sha256:3c46e409a47ba403fbb15dae6506f8cd8ef6f89a285db68038a3c91a4d4af8f0
FROM $BASE_CONTAINER

LABEL maintainer="Jupyter Project <jupyter@googlegroups.com>"

USER root

# R pre-requisites
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    fonts-dejavu \
    unixodbc \
    unixodbc-dev \
    r-cran-rodbc \
    gfortran \
    gcc \
    ffmpeg \
    dvipng \
    cm-super \ 
    && \
    rm -rf /var/lib/apt/lists/*

# Fix for devtools https://github.com/conda-forge/r-devtools-feedstock/issues/4
RUN ln -s /bin/tar /bin/gtar

USER $NB_UID

# R packages
RUN conda install --quiet --yes \
    'r-base=4.0.2' \
    'r-caret=6.*' \
    'r-crayon=1.3*' \
    'r-devtools=2.3*' \
    'r-forecast=8.13*' \
    'r-hexbin=1.28*' \
    'r-htmltools=0.5*' \
    'r-htmlwidgets=1.5*' \
    'r-irkernel=1.1*' \
    'r-nycflights13=1.0*' \
    'r-randomforest=4.6*' \
    'r-rcurl=1.98*' \
    'r-rmarkdown=2.3*' \
    'r-rodbc=1.3*' \
    'r-rsqlite=2.2*' \
    'r-shiny=1.5*' \
    'r-tidyverse=1.3*' \
    'unixodbc=2.3.*' \
    'r-tidymodels=0.1*' \
    'beautifulsoup4=4.9.*' \
    'conda-forge::blas=*=openblas' \
    'bokeh=2.2.*' \
    'bottleneck=1.3.*' \
    'cloudpickle=1.6.*' \
    'cython=0.29.*' \
    'dask=2.25.*' \
    'dill=0.3.*' \
    'h5py=2.10.*' \
    'ipywidgets=7.5.*' \
    'ipympl=0.5.*'\
    'matplotlib-base=3.3.*' \
    'numba=0.51.*' \
    'numexpr=2.7.*' \
    'pandas=1.1.*' \
    'patsy=0.5.*' \
    'protobuf=3.12.*' \
    'pytables=3.6.*' \
    'scikit-image=0.17.*' \
    'scikit-learn=0.23.*' \
    'scipy=1.5.*' \
    'seaborn=0.11.*' \
    'sqlalchemy=1.3.*' \
    'statsmodels=0.12.*' \
    'sympy=1.6.*' \
    'vincent=0.4.*' \
    'widgetsnbextension=3.5.*'\
    'xlrd=1.2.*' \
    && \
    conda clean --all -f -y && \
    jupyter nbextension enable --py widgetsnbextension --sys-prefix && \
    jupyter labextension install @jupyter-widgets/jupyterlab-manager@^2.0.0 --no-build && \
    jupyter labextension install @bokeh/jupyter_bokeh@^2.0.0 --no-build && \
    jupyter labextension install jupyter-matplotlib@^0.7.2 --no-build && \
    jupyter lab build -y && \
    jupyter lab clean -y && \
    npm cache clean --force && \
    rm -rf "/home/${NB_USER}/.cache/yarn" && \
    rm -rf "/home/${NB_USER}/.node-gyp" && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

# Install e1071 R package (dependency of the caret R package)
RUN conda install --quiet --yes r-e1071

# Install facets which does not have a pip or conda package at the moment
WORKDIR /tmp
RUN git clone https://github.com/PAIR-code/facets.git && \
    jupyter nbextension install facets/facets-dist/ --sys-prefix && \
    rm -rf /tmp/facets && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

# Import matplotlib the first time to build the font cache.
ENV XDG_CACHE_HOME="/home/${NB_USER}/.cache/"

RUN MPLBACKEND=Agg python -c "import matplotlib.pyplot" && \
    fix-permissions "/home/${NB_USER}"

USER $NB_UID

WORKDIR $HOME
