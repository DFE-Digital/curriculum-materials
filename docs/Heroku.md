# Heroku

The application is currently set up with Heroku. Herkou automatically

* builds review apps for every Github pull request
* deploys `development` to staging
* deploys `master` to production

| Environment | URL                                                  | App name                      |
| ----------- | --------                                             | --------                      |
| Staging     | https://dfe-curriculum-materials.herokuapp.com/      | dfe-curriculum-materials      |
| Production  | https://dfe-curriculum-materials-prod.herokuapp.com/ | dfe-curriculum-materials-prod |

There is currently no _actual_ data provided by anyone other than our seeds.
To keep things simple, when the the application needs re-seeding we've torn
down and re-seeded the database. This _isn't_ a long-term strategy, but while
we have no users writing safe migrations is overkill.

To completely reset and re-seed the database on Heroku, use these commands:

```
$ heroku pg:reset -a (your-app-name)
$ heroku run SAFETY_ASSURED=1 DISABLE_DATABASE_ENVIRONMENT_CHECK=1 bin/rake db:schema:load db:seed -a (your-app-name)
```
