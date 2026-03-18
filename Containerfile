FROM registry.fedoraproject.org/fedora:rawhide

RUN dnf upgrade -y && \
    dnf group install -y development-tools && \
    dnf clean all

RUN dnf install -y which && \
    dnf clean all

ARG USER_NAME

# Create user
RUN groupadd -g 1000 ${USER_NAME} && useradd -u 1000 -g 1000 -m ${USER_NAME} && \
    usermod -aG wheel ${USER_NAME}

# Align to atomic host system
RUN mkdir -p /var/home/ && ln -s /home/${USER_NAME} /var/home/${USER_NAME} && \
    chown -R ${USER_NAME}:${USER_NAME} /var/home/${USER_NAME}

USER ${USER_NAME}
ENV PATH="/home/linuxbrew/.linuxbrew/bin:/home/${USER_NAME}/bin:${PATH}"

WORKDIR /workspace
