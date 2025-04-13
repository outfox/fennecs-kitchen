FROM mcr.microsoft.com/dotnet/sdk:9.0.203

# Install Python and required packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    python3 \
    python3-pip \
    python3-venv \
    python3-dev \
    wget \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set non-root user
ENV USER="jovyan"
RUN useradd -ms /bin/bash $USER
USER $USER 
ENV HOME="/home/$USER"
WORKDIR $HOME

# Create a workspace directory
RUN mkdir -p $HOME/workspace
WORKDIR $HOME/workspace

# Create and activate virtual environment
RUN python3 -m venv $HOME/venv
ENV PATH="$HOME/venv/bin:$PATH"

# Install Jupyter in the virtual environment
RUN pip install --no-cache-dir \
    jupyter \
    jupyterlab \
    ipykernel

# Install .NET kernel
RUN dotnet tool install -g --add-source "https://pkgs.dev.azure.com/dnceng/public/_packaging/dotnet-tools/nuget/v3/index.json" Microsoft.dotnet-interactive
ENV PATH="/${HOME}/.dotnet/tools:${PATH}"
ENV DOTNET_CLI_TELEMETRY_OPTOUT=1
RUN dotnet interactive jupyter install

# Run Jupyter Notebook from the workspace directory
EXPOSE 8888
WORKDIR $HOME/workspace
ENTRYPOINT ["jupyter", "lab", "--no-browser", "--ip=0.0.0.0", "--NotebookApp.notebook_dir=$HOME/workspace"]