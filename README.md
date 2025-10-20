# Georgian Marketplace MVP

Rails 8 / Ruby 3.3.

## Dev setup
- Postgres 16 and Redis via Homebrew services
- `bin/rails db:setup` then `bin/rails s`
- Credentials: keep `config/master.key` **out of git**

## Features
- Listings with photos, categories, locations
- Search filters and favorites
- Conversations/messages (Turbo Streams)
- Promote listing for 7 days
- Devise authentication
