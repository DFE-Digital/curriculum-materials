FROM ruby:2.6.5

# Allow apt to work with https based sources
RUN apt-get update -yqq && apt-get install -yqq --no-install-recommends \
  apt-transport-https

# Ensure latest packages for Yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -

# Install packages
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | \
  tee /etc/apt/sources.list.d/yarn.list && \
  curl -sL https://deb.nodesource.com/setup_12.x | bash - && \
  apt-get update -yqq && apt-get install -yqq --no-install-recommends \
      nodejs \
      yarn

RUN mkdir /usr/src/app
WORKDIR /usr/src/app

# Install NPM packages removing artifacts
COPY package.json yarn.lock /usr/src/app/
RUN yarn install && yarn cache clean

COPY .ruby-version Gemfile Gemfile.lock /usr/src/app/

ENV BUNDLE_PATH /gems
RUN bundle install --without test development

COPY . /usr/src/app/
RUN RAILS_ENV=staging bundle exec rake assets:precompile SECRET_KEY_BASE=stubbed

CMD ["bin/rails", "s", "-b", "0.0.0.0"]
