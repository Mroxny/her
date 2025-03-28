FROM ghcr.io/selkies-project/nvidia-egl-desktop:22.04

ENV HOME=/home/ubuntu
WORKDIR $HOME


# Install conda
ARG CONDA_VERSION="py39_25.1.1-2"
ARG CONDA_CHANNEL_ADDR="https://example.here/"
ARG PACKAGE_LIST="git"

RUN apt update && apt install sudo &&\ 
    chown -R ubuntu $HOME && \ 
    mkdir ${HOME}/miniconda3/ && \ 
    wget https://repo.anaconda.com/miniconda/Miniconda3-${CONDA_VERSION}-Linux-x86_64.sh -O ${HOME}/miniconda3/miniconda.sh && \ 
    checksum_string=$(sha256sum ${HOME}/miniconda3/miniconda.sh) && \ 
    wget -O miniconda_hashes.html "https://repo.anaconda.com/miniconda/" && \ 
    if grep -q $checksum_string miniconda_hashes.html; then \ 
        echo "Miniconda checksum verified." ; \ 
    else \ 
        echo "Miniconda checksum was not verified. Exiting." ; exit 1; \ 
    fi && \ 
    bash ${HOME}/miniconda3/miniconda.sh -b -u -p ${HOME}/miniconda3 && \ 
    rm ${HOME}/miniconda3/miniconda.sh && \
    ${HOME}/miniconda3/bin/activate && \ 
    ${HOME}/miniconda3/bin/conda init --all && \ 
    ${HOME}/miniconda3/bin/conda config --set ssl_verify False && \ 
    ${HOME}/miniconda3/bin/conda install -y conda-build && \ 
    ${HOME}/miniconda3/bin/conda config --add channels ${CONDA_CHANNEL_ADDR} && \ 
    ${HOME}/miniconda3/bin/conda config --set channel_priority strict


# Install programs

RUN sudo ${HOME}/miniconda3/bin/conda install -y ${PACKAGE_LIST}

