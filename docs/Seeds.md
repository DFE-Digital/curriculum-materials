# Seeding the app

Due to the quantity and format of our initial dataset, what could eventually be
an entire unit of Year 7 History lessons, seeding this application is somewhat
unconventional.

Each lesson can have multiple activities and each activity multiple resources,
so the seed data is structured and loaded in a hierarchical fashion. There is a
more in-depth vie of the hierarchy in `db/seeds/seeder.rb`.

The seeding of all **CCP**, **Unit**, **Lesson** and **LessonPart**, **Activity** and **Resource** data is
handled by `seeder.rb`. Any new `.yml` files that added to the data, found in
`db/seeds/data` will automatically seeded.

## Seeding modes

The long-term intent is that seeds can be run non-destructively and
applications can be seeded remotely via the API. To support this the seeding
process can be run in two modes

### Local seeding

Normally, the seeds use the app's models directly and no additional setup is
required.

### API seeding

To seed via the API, two additional environment variables are required:

* `API_KEY` - the API uses token-based authentication. When the `API_KEY`
  variable is present on the server, that value is used as the `master_key`. If
  suppliers are set up, their automatically-generated tokens will also work but
  the model hasn't been fully implemented yet.

* `SEED_API_URL` - the URL of the app.

#### Example

To seed locally via the API, add the following to your `.env` file:

```
API_TOKEN='abc123'
SEED_API_URL='http://localhost:3000'
```

Ensure the application is up and running but hasn't been seeded:

```zsh
$ bundle exec rails db:{drop,create,schema:load} && bundle exec rails server
```

Now, seed in the normal fashion:

```zsh
$ bundle exec rails db:seed
```
