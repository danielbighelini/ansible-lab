FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get update && \
    apt-get install -y \
        python3 \
        python3-pip \
        python3-venv \
        pipx \
        sshpass \
        git \
        curl \
        jq \
        vim && \
    rm -rf /var/lib/apt/lists/*

USER vscode

RUN pipx install ansible-core && \
    pipx install ansible-lint && \
    pipx install yamllint

ENV PATH="/home/vscode/.local/bin:${PATH}"