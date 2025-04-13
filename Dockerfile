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
ARG NB_USER=jovyan
ARG NB_UID=1000
ENV USER=${NB_USER}
ENV NB_UID=${NB_UID}
ENV HOME=/home/${NB_USER}

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}
    

# Create and activate virtual environment
#RUN python3 -m venv $HOME/venv
#ENV PATH="$HOME/venv/bin:$PATH"

# Install Jupyter in the virtual environment
RUN pip install --break-system-packages --no-cache-dir \
    jupyter \
    notebook \
    jupyterlab \
    ipykernel

# Install .NET kernel
RUN dotnet tool install -g --add-source "https://pkgs.dev.azure.com/dnceng/public/_packaging/dotnet-tools/nuget/v3/index.json" Microsoft.dotnet-interactive
ENV PATH="/${HOME}/.dotnet/tools:${PATH}"
ENV DOTNET_CLI_TELEMETRY_OPTOUT=1
ENV DOTNET_USE_POLLING_FILE_WATCHER=true
ENV NUGET_XMLDOC_MODE=skip
RUN dotnet interactive jupyter install

# Create a workspace directory
#RUN mkdir -p $HOME/workspace
#WORKDIR $HOME/workspace

# Make sure the contents of our repo are in ${HOME}
USER root
RUN chown -R jovyan ${HOME}

# Copy Cookbooks
USER jovyan
WORKDIR $HOME
COPY . .


