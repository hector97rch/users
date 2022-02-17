FROM bitwalker/alpine-elixir-phoenix:1.13.1

WORKDIR /app

# Set exposed ports
EXPOSE 4000
ENV PORT=4000

# Cache elixir deps
ADD mix.exs mix.lock ./
RUN mix do deps.get, deps.compile

ADD . .

RUN chmod +x ./run.sh

CMD ["./run.sh"]