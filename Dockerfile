FROM cirrusci/android-sdk:tools

RUN yes | sdkmanager "platform-tools" > /dev/null
RUN yes | sdkmanager "platforms;android-30" "build-tools;30.0.2" > /dev/null
RUN yes | sdkmanager "platforms;android-29" "build-tools;29.0.3" > /dev/null

RUN sudo apt-get update \
    && sudo apt-get install -y --allow-unauthenticated --no-install-recommends lib32stdc++6 libstdc++6 libglu1-mesa locales unzip \
    && sudo rm -rf /var/lib/apt/lists/*

RUN sudo locale-gen --purge en_US "en_US.UTF-8" \
	&& sudo sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
	&& sudo dpkg-reconfigure --frontend=noninteractive locales \
	&& sudo update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 LANGUAGE=en_US:en

#### --- Set flutter version ---- ####
ARG flutter_version=2.8.1
ARG flutter_branch=stable

ENV FLUTTER_HOME=${HOME}/sdks/flutter \
	FLUTTER_VERSION=$flutter_version \
	FLUTTER_BRANCH=$flutter_branch

RUN git clone --branch ${FLUTTER_BRANCH} https://github.com/flutter/flutter.git ${FLUTTER_HOME}
RUN cd ${FLUTTER_HOME} && git checkout ${FLUTTER_VERSION}

ENV PATH /home/cirrus/.rbenv/bin:/home/cirrus/.rbenv/shims:${PATH}:${FLUTTER_HOME}/bin:${FLUTTER_HOME}/bin/cache/dart-sdk/bin

# run flutter doctor
RUN flutter doctor
RUN mkdir -p /home/cirrus/.ssh
RUN echo -e "Host *\n\tStrictHostKeyChecking no\n\n" > /home/cirrus/.ssh/config

# Install Ruby and Fastlane
RUN sudo apt update && sudo apt install -y libssl-dev libreadline-dev zlib1g-dev
RUN curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer | bash
ENV PATH="/root/.rbenv/bin:$PATH"
RUN exec $SHELL
RUN eval "$(rbenv init -)"
RUN rbenv install 3.1.0 && rbenv global 3.1.0
RUN gem install bundler:2.3.4
