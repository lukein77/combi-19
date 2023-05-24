# COMBI-19

Small project made for a Software Engineering course at UNLP.

### Versions

- Ruby: 3.2.2
- Rails: 7.0.4

### How to run

The following steps should be enough to get the app running:

1. Make sure you have the specified Ruby on Rails versions installed.

2. Clone the repository

3. Run the following commands:
```
cd combi-19
bundle install
bin/rails db:migrate
bin/rails webpacker:install
yarn install
```

4. Run rails server with `bin/rails s`