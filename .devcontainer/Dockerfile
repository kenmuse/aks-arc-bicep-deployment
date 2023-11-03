FROM mcr.microsoft.com/vscode/devcontainers/dotnet:6.0

ARG BICEP_VERSION=latest
ARG POWERSHELL_VERSION=7.2.0

# Install PowerShell and  Azure CLI [requires elevated permissions]
RUN dotnet tool install -g powershell --version $POWERSHELL_VERSION \
 && curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# Install Bicep [requires elevated permissions]
 RUN curl -Lo /tmp/bicep https://github.com/Azure/bicep/releases/${BICEP_VERSION}/download/bicep-linux-x64 \
    && chmod +x /tmp/bicep \
    && mv /tmp/bicep /usr/local/bin/bicep