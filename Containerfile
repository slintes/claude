FROM registry.fedoraproject.org/fedora:rawhide

RUN dnf group install -y development-tools && \
    dnf install -y gh && \
    dnf clean all

ARG USER_NAME

# Create user
RUN groupadd -g 1000 ${USER_NAME} && useradd -u 1000 -g 1000 -m ${USER_NAME} && \
    usermod -aG wheel ${USER_NAME}

# Align to atomic host system
RUN mkdir -p /var/home/ && ln -s /home/${USER_NAME} /var/home/${USER_NAME} && \
    chown -R ${USER_NAME}:${USER_NAME} /var/home/${USER_NAME}

# Prepare Homebrew prefix
RUN mkdir -p /home/linuxbrew/.linuxbrew && \
    chown -R ${USER_NAME}:${USER_NAME} /home/linuxbrew

USER ${USER_NAME}
ENV PATH="/home/linuxbrew/.linuxbrew/bin:${PATH}"

RUN NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
RUN brew install claude-code

WORKDIR /workspace
