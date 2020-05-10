# Portfolio

## Local development
> Make sure Erlang, Elixir and ImageMagick are installed

- Create a file dev.secret.exs in the "config" directory with this content
```elixir
use Mix.Config

config :ueberauth, Ueberauth.Strategy.Github.OAuth,
  client_id: "github client id",
  client_secret: "github client secret"

config :portfolio,
       accepted_user_email: "email address separated by a space"
```
- Start postgres using docker
```bash
$ docker-compose up -d
```
- Setup the project
```bash
$ mix setup
```
- Start Phoenix endpoint
```bash
$ iex -S mix phx.server
```

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Release
> Release are done using github actions

### Environment variables
- `SECRET_KEY_BASE`: secret used by phoenix, generate it using mix phx.gen.secret
- `DATABASE_URL`: database url used by ecto. ex => ecto://[user]:[password]@localhost/[database name]
- `GITHUB_CLIENT_ID`: Your github client id to allow social login
- `GITHUB_CLIENT_SECRET`: Your github client secret to allow social login
- `ACCEPTED_USER_EMAIL`: authorized email address that can register
- `STORAGE_DIR`: Path to the directory where you want to save your uploads
