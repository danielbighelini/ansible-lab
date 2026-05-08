FROM mcr.microsoft.com/devcontainers/base:ubuntu

RUN apt-get update && \
    apt-get install -y \
        python3 \
        python3-pip \
        python3-venv \
        pipx \
        ansible \
        sshpass \
        git \
        curl \
        jq \
        vim && \
    apt-get clean

USER vscode

RUN pipx install ansible-lint

ENV PATH="/home/vscode/.local/bin:${PATH}"