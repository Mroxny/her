FROM ghcr.io/selkies-project/nvidia-egl-desktop:24.04-20241222100454

ENV HOME=/home/ubuntu
WORKDIR $HOME
RUN chown -R ubuntu $HOME
COPY --chown=ubuntu ./scripts/miniconda.sh ${HOME}/miniconda3/

# Install conda
RUN bash ${HOME}/miniconda3/miniconda.sh -b -u -p ${HOME}/miniconda3 && \
    rm ${HOME}/miniconda3/miniconda.sh
RUN ${HOME}/miniconda3/bin/activate
RUN ${HOME}/miniconda3/bin/conda init --all

# Config channels
ARG CHANNEL_ADDR="http://10.20.1.139:8000/"
RUN ${HOME}/miniconda3/bin/conda config --set ssl_verify False && \
 ${HOME}/miniconda3/bin/conda install -y conda-build && \
 ${HOME}/miniconda3/bin/conda config --add channels ${CHANNEL_ADDR} && \
 ${HOME}/miniconda3/bin/conda config --set channel_priority strict

# Install programs
ARG PACKAGE_LIST="git"
RUN ${HOME}/miniconda3/bin/conda install -y ${PACKAGE_LIST} && \
 ${HOME}/miniconda3/bin/conda clean -y --force-pkgs-dirs --all
