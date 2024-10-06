# Start from the base devcontainer image
FROM mcr.microsoft.com/devcontainers/base:ubuntu-22.04

USER root

# Install Python and the required packages (can use the Python feature if desired)
RUN apt-get update && apt-get install -y python3 python3-pip
COPY requirements.txt /tmp/
RUN pip install -r /tmp/requirements.txt

# Install ffmpeg
RUN apt install -y ffmpeg

USER vscode
WORKDIR /home/vscode

# Install Julia using devcontainer feature (use non-interactive mode to bypass prompts)
RUN curl -fsSL https://install.julialang.org | sh -s -- --yes --default-channel release
ENV PATH="/home/vscode/.juliaup/bin:${PATH}"

# Copy Julia Project files to the root directory of the container
COPY Project.toml .
COPY Manifest.toml .

# Instantiate Julia environment
RUN julia --project -e 'using Pkg; Pkg.instantiate()'
