FROM mcr.microsoft.com/vscode/devcontainers/dotnet:6.0
# FROM mcr.microsoft.com/devcontainers/universal:linux

ARG BICEP_VERSION=latest
ARG POWERSHELL_VERSION=7.2.16

# Install tools
RUN dotnet tool install -g powershell --version $POWERSHELL_VERSION \
    # Install Azure CLI
    && curl -sL https://aka.ms/InstallAzureCLIDeb | bash \
    # Install Bicep
    && curl -Lo /tmp/bicep https://github.com/Azure/bicep/releases/${BICEP_VERSION}/download/bicep-linux-x64 \
    && install -m 755 /tmp/bicep /usr/local/bin \
    # Install helmfile
    && curl -Lo /tmp/helmfile.tar.gz https://github.com/helmfile/helmfile/releases/download/v0.158.1/helmfile_0.158.1_linux_amd64.tar.gz \
    && tar --directory /tmp -xzvf /tmp/helmfile.tar.gz helmfile \
    && rm /tmp/helmfile.tar.gz \
    && install -m 755 /tmp/helmfile /usr/local/bin \
    # Install helm
    && curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash \
    # Install kubelogin/kubectl
    && az aks install-cli
