FROM alpine:3.19.0 as facts-build

RUN wget -O - https://github.com/radical-collaboration/facts/archive/refs/tags/v1.1.2.tar.gz \
    | tar -xzC /opt \
    && mv /opt/facts-1.1.2 /opt/facts

FROM mambaorg/micromamba:1.5.6

COPY --chown=$MAMBA_USER:$MAMBA_USER environment.yml /tmp/env.yaml
RUN micromamba install -y -n base -f /tmp/env.yaml && \
    micromamba clean --all --yes 
ARG MAMBA_DOCKERFILE_ACTIVATE=1

COPY --from=facts-build --chown=$MAMBA_USER:$MAMBA_USER /opt/facts /opt/facts
# make directory for radical pilot sandbox
RUN mkdir -p ~/radical.pilot.sandbox

COPY --chown=$MAMBA_USER:$MAMBA_USER . /opt/dscim-facts-epa
WORKDIR /opt/dscim-facts-epa
