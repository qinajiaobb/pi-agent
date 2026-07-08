FROM node:latest

ENV OLLAMA_CONTEXT_LENGTH=256000

ENV TAU_MIRROR_PORT=3001
ENV TAU_HOST=0.0.0.0
#ENV TAU_STATIC_DIR
ENV TAU_DISABLED=0
#ENV TAU_USER=""
#ENV TAU_PASS=""

EXPOSE 3001

# ansible
RUN git clone https://github.com/TheShellLand/antsable && \
    cd antsable && \
    bash install-ansible.sh && \
    # chrome, docker
    bash ansible-local.sh playbooks/readyup.yml

# install pi
RUN apt update && \
    apt install -y vim curl wget unzip build-essential python3-dev && \
    apt clean -y && \
    apt autoremove -y && \
    rm -rf /var/lib/apt/lists/*
RUN curl -fsSL https://bootstrap.pypa.io/get-pip.py | python3 - --break-system-packages && \
    python3 -m pip install -U pip --break-system-packages

COPY pi-extensions.sh /pi-extensions.sh

RUN curl -fsSL https://pi.dev/install.sh | sh && \
    pi update && \
    pi update --extensions && \
    bash pi-extensions.sh ; echo

COPY models.json /root/.pi/agent/models.json

COPY entry.sh /pi.sh
RUN chmod +x /pi.sh

WORKDIR /root/brain

VOLUME /root/.pi/agent/sessions

ENTRYPOINT ["/pi.sh"]
