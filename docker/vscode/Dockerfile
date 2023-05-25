#
# Docker image with Visual Studio Code and Node.js to run in x11docker
#
FROM x11docker/lxqt
RUN apt update
RUN apt install -y wget gpg curl git
RUN wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg && install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
RUN sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list' && rm -f packages.microsoft.gpg
RUN curl -sL https://deb.nodesource.com/setup_18.x | bash -
RUN DEBIAN_FRONTEND=noninteractive apt -y install code nodejs
RUN rm -rf /var/cache/apt/archives /var/lib/apt/lists/*
RUN useradd -m user
USER 1000
# CMD ["/usr/bin/code", "-w" ,"--no-sandbox"]
# CMD [ "sh", "-c", "/usr/bin/code -w" ]
