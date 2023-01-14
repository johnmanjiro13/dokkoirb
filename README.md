# dokkoi

Dokkoi is a discord bot.

## Development
### Environment variables

Dokkoi needs some environment variables to run.

- DISCORD_TOKEN : A token of discord bot
- CUSTOMSEARCH_API_KEY : An api key of google custom search api
- CUSTOMSEARCH_ENGINE_ID : An engine id of google custom search api
- FIREBASE_RTDB_URI : A firebase realtime database uri
- FIREBASE_PRIVATE_KEY_PATH : A path of firebase private key json file

### Run on local machine

```shell
bundle exec ruby bot.rb
```

### Run tests

```shell
bundle exec rake test
```

### Run lint

```shell
bundle exec rubocop
```
