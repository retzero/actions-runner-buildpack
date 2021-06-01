
FROM retzero/actions-buildpack-dind

LABEL maintainer="Hyokeun Jeon <hyokeun@gmail.com>"

USER root

RUN \
  apt-get update \
  && sudo apt install -y acl \
  && sudo setfacl -m user:actions:rw /var/run/docker.sock

USER actions

ENV AGENT_TOOLSDIRECTORY=/opt/hostedtoolcache
RUN mkdir -p /opt/hostedtoolcache

ENV GH_RUNNER_VERSION="2.273.5"
ENV TARGETPLATFORM="linux/amd64"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

WORKDIR /actions-runner
COPY install_actions.sh /actions-runner

RUN chmod +x /actions-runner/install_actions.sh \
  && /actions-runner/install_actions.sh ${GH_RUNNER_VERSION} ${TARGETPLATFORM} \
  && rm /actions-runner/install_actions.sh

COPY token.sh entrypoint.sh /
RUN chmod +x /token.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/actions-runner/bin/runsvc.sh"]
