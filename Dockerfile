FROM ghcr.io/selkies-project/nvidia-egl-desktop:24.04-20241222100454

ENV HOME=/home/ubuntu
WORKDIR $HOME
RUN chown -R ubuntu $HOME
USER ubuntu 


# Install conda
ARG CONDA_VERSION="py39_25.1.1-2"

RUN mkdir ${HOME}/miniconda3/ && wget https://repo.anaconda.com/miniconda/Miniconda3-${CONDA_VERSION}-Linux-x86_64.sh -O ${HOME}/miniconda3/miniconda.sh
RUN checksum_string=$(sha256sum ${HOME}/miniconda3/miniconda.sh) && wget -O miniconda_hashes.html "https://repo.anaconda.com/miniconda/"
RUN if grep -q "$checksum_string" miniconda_hashes.html; then \
        echo "Miniconda checksum verified." ; \
    else \
        echo "Miniconda checksum was not verified. Exiting." ; exit 1; \
    fi
    
RUN bash ${HOME}/miniconda3/miniconda.sh -b -u -p ${HOME}/miniconda3 && \
    rm ${HOME}/miniconda3/miniconda.sh
RUN ${HOME}/miniconda3/bin/activate
RUN ${HOME}/miniconda3/bin/conda init --all

# Config channels
ARG CONDA_CHANNEL_ADDR="https://example.here/"

RUN ${HOME}/miniconda3/bin/conda config --set ssl_verify False && \
    ${HOME}/miniconda3/bin/conda install -y conda-build && \
    ${HOME}/miniconda3/bin/conda config --add channels ${CONDA_CHANNEL_ADDR} && \
    ${HOME}/miniconda3/bin/conda config --set channel_priority strict

# RUN chown -R ubuntu $HOME

# Install programs
ARG PACKAGE_LIST="git"

RUN ${HOME}/miniconda3/bin/conda install -y ${PACKAGE_LIST} && \
    ${HOME}/miniconda3/bin/conda clean -y --force-pkgs-dirs --all
