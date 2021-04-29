FROM fedora:latest

MAINTAINER asukiasyan

ENV AWS_CLI_VERSION=2.0.62 \
    HELM_VERSION=3.5.0 \
    KUBECTL_VERSION=1.18.10 \
    KUBECTX_VERSION=0.9.3 \
    SOPS_VERSION=3.6.1 \
    TERRAFORM_DOCS_VERSION=0.12.1 \
    TERRAFORM_VERSION=0.15.1 \
    SHELL=/bin/bash

RUN set -x && \
    adduser --shell /bin/bash --home /home/asukiasyan asukiasyan && \
    dnf update -y && dnf upgrade -y && \
    dnf install -y vim unzip curl git python3 python3-setuptools jq telnet tree the_silver_searcher passenger iputils bash-completion ansible

# AWS CLI
RUN curl -sL https://awscli.amazonaws.com/awscli-exe-linux-x86_64-${AWS_CLI_VERSION}.zip -o awscliv2.zip && \
    unzip -qq awscliv2.zip && \
    aws/install && \
    rm -rf awscliv2.zip aws /usr/local/aws-cli/v2/*/dist/aws_completer /usr/local/aws-cli/v2/*/dist/awscli/data/ac.index /usr/local/aws-cli/v2/*/dist/awscli/examples

# Terraform
RUN curl -LO https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip ./terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    mv ./terraform /usr/bin/ && \
    rm ./terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# Terraform-docs
RUN curl -LO https://github.com/terraform-docs/terraform-docs/releases/download/v${TERRAFORM_DOCS_VERSION}/terraform-docs-v${TERRAFORM_DOCS_VERSION}-linux-amd64 && \
    chmod +x ./terraform-docs-v${TERRAFORM_DOCS_VERSION}-linux-amd64 &&  \
    mv ./terraform-docs-v${TERRAFORM_DOCS_VERSION}-linux-amd64  /usr/bin/terraform-docs

# Helm
RUN curl -LO https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz && \
    tar xvzf helm-v${HELM_VERSION}-linux-amd64.tar.gz && \
    chmod +x ./linux-amd64/helm && \
    mv ./linux-amd64/helm /usr/bin/helm && \
    rm -rf linux-amd64 helm-v${HELM_VERSION}-linux-amd64.tar.gz

# kubectl
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/bin/kubectl

# kubectx
RUN curl -LO https://github.com/ahmetb/kubectx/releases/download/v${KUBECTX_VERSION}/kubectx_v${KUBECTX_VERSION}_linux_arm64.tar.gz && \
    tar -xzvf ./kubectx_v${KUBECTX_VERSION}_linux_arm64.tar.gz && \
    ls -la && \
    chmod +x ./kubectx && \
    mv ./kubectx /usr/bin/kubectx

# Grant user sudo privilegues
RUN touch /etc/sudoers.d/asukiasyan && \
    echo "asukiasyan ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/asukiasyan

USER asukiasyan
WORKDIR /home/asukiasyan

# vim-plug
RUN mkdir -p ~/.vim/autoload/ && \
    curl -LO https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim && \
    mv ./plug.vim ~/.vim/autoload/

# dotfiles
RUN git clone https://github.com/asukiasyan/dotfiles.git && cd dotfiles/ && mv .vimrc ~/ && mv .bash_profile ~/.bashrc
