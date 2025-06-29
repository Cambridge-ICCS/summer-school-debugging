ARG UV_VERSION=latest
ARG DEBIAN_VERSION=bookworm


FROM ghcr.io/astral-sh/uv:$UV_VERSION AS uv

# --- Valgrind build stage ---
FROM mcr.microsoft.com/vscode/devcontainers/base:$DEBIAN_VERSION AS valgrind-build

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    wget gcc g++ make \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /tmp
RUN wget https://sourceware.org/pub/valgrind/valgrind-3.25.0.tar.bz2 \
    && tar xf valgrind-3.25.0.tar.bz2 \
    && cd valgrind-3.25.0 \
    && ./configure --prefix=/valgrind \
    && make -j 4 \
    && make install

# --- Main image ---
FROM mcr.microsoft.com/vscode/devcontainers/base:$DEBIAN_VERSION

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    libopenmpi-dev gfortran gdb \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copy Valgrind from build stage
COPY --from=valgrind-build /valgrind /usr

RUN echo "localhost slots=4" >> /etc/openmpi/openmpi-default-hostfile

COPY --from=uv --chown=vscode: /uv /uvx /bin/

USER vscode

RUN uv tool install git+https://github.com/TomMelt/mdb.git \
    && uv tool install git+https://github.com/TomMelt/bplot.git \
    && uv tool install termgraph

COPY .bashrc_customization /home/vscode/
RUN echo "source /home/vscode/.bashrc_customization" >> /home/vscode/.bashrc

WORKDIR /home/vscode/
