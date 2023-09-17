FROM ruby:2.7.5-slim
RUN mkdir /app
WORKDIR /app
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs \
    postgresql \
    postgresql-contrib
ENV POSTGRES_USER social_network
ENV POSTGRES_PASSWORD password1
ENV POSTGRES_DB docker-app
# Create a directory for PostgreSQL data
RUN mkdir -p /var/lib/postgresql/data
RUN service postgresql start && \
  su -c "psql -c \"CREATE USER $POSTGRES_USER WITH PASSWORD '$POSTGRES_PASSWORD';\"" - postgres && \
  su -c "psql -c \"ALTER USER $POSTGRES_USER CREATEDB;\"" - postgres

COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN bundle install
COPY . .

EXPOSE 3000
CMD service postgresql start && rails db:create && rails server -b 0.0.0.0
# # Start the PostgreSQL service
# RUN service postgresql start && \
#   su -c "psql -c \"CREATE USER $POSTGRES_USER WITH PASSWORD '$POSTGRES_PASSWORD';\"" - postgres && \
#   su -c "psql -c \"ALTER USER $POSTGRES_USER CREATEDB;\"" - postgres
# CMD ["service", "postgresql", "start"]
# #RUN rails db:create
# CMD ["rails", "server", "-b", "0.0.0.0"]