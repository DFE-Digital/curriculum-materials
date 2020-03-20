# Heroku

The application is currently set up with Heroku. Herkou automatically

* builds review apps for every Github pull request
* deploys `development` to staging
* deploys `master` to production

| Environment | URL                                                  | App name                        |
| ----------- | --------                                             | --------                        |
| Staging     | https://dfe-curriculum-materials.herokuapp.com/      | `dfe-curriculum-materials`      |
| Production  | https://dfe-curriculum-materials-prod.herokuapp.com/ | `dfe-curriculum-materials-prod` |

There is currently no _actual_ data provided by anyone other than our seeds.
To keep things simple, when the the application needs re-seeding we've torn
down and re-seeded the database. This _isn't_ a long-term strategy, but while
we have no users writing safe migrations is overkill.

To completely reset and re-seed the database on Heroku, use these commands:

```bash
$ heroku pg:reset -a (your-app-name)
$ heroku run SAFETY_ASSURED=1 DISABLE_DATABASE_ENVIRONMENT_CHECK=1 bin/rake db:schema:load db:seed -a (your-app-name)
```

Review apps are automatically seeded locally so these steps only need to
be taken for staging and production (until the app is live, at least 😅).

## Adding teacher accounts

The API does not currently support the addition of teachers. The teacher section
of the app is currently protected by a token that is intended to be used to
invite new teachers to use the app in a controlled manner.

To create a teacher account via Herkoku, the following approach works:

```bash
$ heroku run -a (your-app-name) rails runner "Teacher.create! token: '(your-preferred-uuid)'"
```

Then, to _activate_ the token and use the app, navigate to `https://(your-app-url)/teachers/session/(your-preferred-uuid)`
