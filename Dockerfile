FROM ruby:2.6
RUN apt-get update -yqq
RUN apt-get install -yqq --no-install-recommends nodejs
# Allow apt to work with https-based sources
RUN apt-get update -yqq && apt-get install -yqq --no-install-recommends apt-transport-https
# Ensure we install an up-to-date version of Node
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
#See https://github.com/yarnpkg/yarn/issues/2888
# Ensure latest packages for Yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | \
tee /etc/apt/sources.list.d/yarn.list -
# Install packages
RUN apt-get update -yqq && apt-get install -yqq --no-install-recommends \
nodejs \
yarn
COPY . /usr/src/app/
WORKDIR /usr/src/app
RUN bundle install
RUN bundle exec rails webpacker:install

CMD ["bin/rails", "s", "-b", "0.0.0.0"]

# docker build railsapp .
# docker run -p 3000:3000 railsapp