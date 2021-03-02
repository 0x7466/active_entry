FROM gitpod/workspace-full

# Install custom tools, runtimes, etc.
# For example "bastet", a command-line tetris clone:
# RUN brew install bastet
#
# More information: https://www.gitpod.io/docs/config-docker/

RUN sudo apt update \
    && sudo apt upgrade -y

# Install Ruby
ENV RUBY_VERSION=3.0.0
RUN sudo mkdir /workspace
RUN sudo chown gitpod:gitpod /workspace
RUN bash -lc "rvm install ruby-$RUBY_VERSION && rvm use ruby-$RUBY_VERSION --default"
