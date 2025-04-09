# Start from the base devcontainer image
FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04

USER root

# Install Python and the required packages (can use the Python feature if desired)
RUN apt-get update && apt-get install -y python3-full
COPY requirements.txt /tmp/
RUN python3 -m venv /opt/venv \
    && /opt/venv/bin/pip install --upgrade pip \
    && /opt/venv/bin/pip install -r /tmp/requirements.txt

# Install the Jupyter kernel for the Python virtual environment
RUN /opt/venv/bin/python -m ipykernel install \
    --prefix=/usr/local \
    --name python-complete \
    --display-name "🐍 Python (Complete venv)"

ENV PATH="/opt/venv/bin:$PATH"

# Install ffmpeg for animation support
RUN apt install -y ffmpeg

USER vscode
WORKDIR /home/vscode

# Set a generic x86_64 CPU target for Julia, see https://github.com/docker-library/julia/issues/79
ENV JULIA_CPU_TARGET generic;sandybridge,-xsaveopt,clone_all;haswell,-rdrnd,base(1)
ENV JULIA_NUM_THREADS=auto

# Install Julia using devcontainer feature (use non-interactive mode to bypass prompts)
RUN curl -fsSL https://install.julialang.org | sh -s -- --yes --default-channel 1.11
ENV PATH="/home/vscode/.juliaup/bin:${PATH}"

# Copy Julia Project files to the root directory of the container
COPY Project.toml .julia/environments/v1.11/
COPY Manifest.toml .julia/environments/v1.11/

# Instantiate Julia environment
RUN julia -e 'using Pkg; Pkg.instantiate()'
