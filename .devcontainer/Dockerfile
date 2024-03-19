FROM ubuntu:latest

# Set non-interactive front end for installers
ENV DEBIAN_FRONTEND=noninteractive 

# Install python build dependencies
RUN apt update && apt install -y \
    build-essential \
    libssl-dev \
    zlib1g-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev curl \
    libncursesw5-dev \
    xz-utils \
    tk-dev \
    libxml2-dev \
    libxmlsec1-dev \
    libffi-dev \
    liblzma-dev \
    git

# Install pyenv
RUN curl https://pyenv.run | bash

# Set environment variables for pyenv
ENV PYENV_ROOT /root/.pyenv
ENV PATH $PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH

# Install Python 3.12 with pyenv and set it as the default python3 version
RUN pyenv install 3.12.0
RUN pyenv global 3.12.0

# Install setuptools for distutils
RUN pip install setuptools

# Install pipx
RUN python3 -m pip install pipx && python3 -m pipx ensurepath
ENV PATH="/root/.local/bin:$PATH"

# Install poetry for dependency management
RUN python3 -m pipx install poetry && python3 -m pipx upgrade poetry
RUN poetry config cache-dir ${WORKSPACE_DIR}/.cache && \
    poetry config virtualenvs.in-project true

# Install Terraform dependencies
RUN apt update && apt install -y \
    wget \
    gnupg \
    software-properties-common \
    curl
# Download Terraform GPC key
RUN wget -O- https://apt.releases.hashicorp.com/gpg | \
    gpg --dearmor | \
    tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
# Add official HashiCorp repository to system
RUN echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
    https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
    tee /etc/apt/sources.list.d/hashicorp.list
# Install Terraform
RUN apt update && apt-get install terraform

# Downloading gcloud package
RUN curl https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz > /tmp/google-cloud-sdk.tar.gz
# Installing the package
RUN mkdir -p /usr/local/gcloud \
  && tar -C /usr/local/gcloud -xvf /tmp/google-cloud-sdk.tar.gz \
  && /usr/local/gcloud/google-cloud-sdk/install.sh
# Adding the package path to local
ENV PATH $PATH:/usr/local/gcloud/google-cloud-sdk/bin

# Install zsh and Starship https://starship.rs/ for pretty prompt
RUN apt install -y zsh && chsh -s $(which zsh)
RUN curl -fsSL https://starship.rs/install.sh | sh /dev/stdin --yes && \
    echo 'eval "$(starship init zsh)"' >> /root/.zshrc

# Set entrypoint to post install bash script, to install Python packages using Poetry
ENTRYPOINT [ "./.devcontainer/post-install.sh" ]