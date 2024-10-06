# Start from the base devcontainer image
FROM mcr.microsoft.com/devcontainers/base:ubuntu

# Install Python and the required packages (can use the Python feature if desired)
RUN apt-get update && apt-get install -y python3 python3-pip
COPY requirements.txt /tmp/
RUN pip install -r /tmp/requirements.txt

# Install ffmpeg
RUN sudo apt install -y ffmpeg

# Install Julia using devcontainer feature (use non-interactive mode to bypass prompts)
RUN curl -fsSL https://install.julialang.org | sh -s -- --yes --default-channel release
# ENV PATH="/root/.juliaup/bin:${PATH}"
RUN . /root/.bashrc && . /root/.profile && . /root/.zshrc

# Copy Julia Project files to the root directory of the container
COPY Project.toml /root/Project.toml
COPY Manifest.toml /root/Manifest.toml

# Instantiate Julia environment
RUN julia --project=/root -e 'using Pkg; Pkg.instantiate()'

# Set default command (bash)
# CMD ["/bin/bash"]
