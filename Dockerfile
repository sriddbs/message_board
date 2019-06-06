FROM ruby:2.6.2

LABEL maintainer="sridhar.belagod@yahoo.co.in"

WORKDIR /app

RUN apt-get update \
    && apt-get install -y nodejs

RUN gem install bundler:2.0.1

COPY Gemfile Gemfile.lock /app/

RUN bundle config build.nokogiri --use-system-libraries && \
    bundle config git.allow_insecure true && \
    bundle install --deployment --frozen --without development test && \
    rm -rf vendor/cache/*.gem

COPY . .

CMD ["bundle", "exec", "rails", "s", "-p", "3000"]
