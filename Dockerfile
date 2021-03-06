# use ruby version 2.5.3
FROM ruby:2.5.3

# using japanese on rails console
ENV LANG C.UTF-8

# remove warn
ENV DEBCONF_NOWARNINGS yes
ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE yes
ENV XDG_CACHE_HOME /tmp

# install package to docker container
RUN apt-get update -qq && apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    vim \
    less

# install yarn
RUN apt-get install -y --no-install-recommends apt-transport-https
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install -y --no-install-recommends yarn

# install nodejs
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get install -y --no-install-recommends nodejs

# install bundler
RUN gem install bundler

# setting environment value
ENV HOME /app

# setting work directory
RUN mkdir $HOME
WORKDIR $HOME

# executing bundle install
COPY Gemfile $HOME/Gemfile
COPY Gemfile.lock $HOME/Gemfile.lock

# install gems
RUN bundle install

EXPOSE 3000
