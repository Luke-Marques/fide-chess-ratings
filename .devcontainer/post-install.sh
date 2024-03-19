#!/bin/bash
set -ex

# Add commonly used aliases to shell
echo 'alias ll="ls -alF"' >> $HOME/.bashrc
echo 'alias la="ls -A"' >> $HOME/.bashrc
echo 'alias l="ls -CF"' >> $HOME/.bashrc

# Install Python packages from pyproject.toml file using Poetry
poetry install --no-root