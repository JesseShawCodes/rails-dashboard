# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...


## Running in Demo Mode

This project supports a demo mode.
You can run demmo mode without any Apple Music Developer Keys

```
bash
cd music_analytics
docker compose up
docker compose run web rails db:setup
```