# Docker

## Development

### Initial set up
Before starting up the container stack you'll first need to build the image and
create the database.

#### Step 1 - Build the docker image
`docker build --build-arg GITHUB_TOKEN=<token> . -t curriculum_materials:latest`

#### Step 2 - Setup the database
`docker-compose run --rm db_tasks bundle exec rake db:setup`
This will create the database for you and load the seed data

#### Step 3 - Create a teacher
`docker-compose run --rm web bundle exec rails runner "Teacher.create! token: '11111111-1111-1111-1111-111111111111'"``
This will add a teacher to the database for you to sign in as.
You can sign in at `http://localhost:3000/teachers/sesssion/11111111-1111-1111-1111-111111111111`

### Developing

#### Starting the app
`docker-compose up`
The app should now be available at localhost:3000

#### Stopping the app
`docker-compose down`
This will stop all containers.

#### Migrations
Stopping and starting the stack `docker-compose down` `docker-compose up` will
run database migrations.

#### Getting a rails console
`docker-compose exec web bundle exec rails c`

#### Getting a bash shell
`docker-compose exec web bash`
