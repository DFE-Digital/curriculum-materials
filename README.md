[![Build Status](https://travis-ci.com/DFE-Digital/curriculum-materials.svg?branch=master)](https://travis-ci.com/DFE-Digital/curriculum-materials)
[![Maintainability](https://api.codeclimate.com/v1/badges/347204b90ba1609c51df/maintainability)](https://codeclimate.com/github/DFE-Digital/curriculum-materials/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/347204b90ba1609c51df/test_coverage)](https://codeclimate.com/github/DFE-Digital/curriculum-materials/test_coverage)

# Curriculum Materials

The curriculum materials project is intended to ease the life of teachers by
allowing them to view, customise and download teaching materials that cover the
entire national curriculum.

## Environments

| Environment | URL                                                  |
| ----------- | --------                                             |
| Staging     | https://dfe-curriculum-materials.herokuapp.com/      |
| Production  | https://dfe-curriculum-materials-prod.herokuapp.com/ |

## Getting started

## Running the application

The application is a standard [Ruby on Rails](https://www.rubyonrails.org/) application requiring
no special stesp to set up.

### Locally

#### Prerequisites

Ensure you have the following installed on your machine:

 * Ruby `2.6.5`
 * PostgreSQL (with an account that has superuser privileges)
 * NodeJS `^12.14.1`

Clone the repository:

```bash
$ git clone git@github.com:DFE-Digital/curriculum-materials.git
```

Install bundler and bundle the Ruby gems:

```bash
$ bundle install
```

_If your database user needs a password, set that first by editing `config/database.yml`_

Now run the app:

```bash
$ bundle exec rails db:setup
```

### On Docker

See the docker guide section of the docs https://github.com/DFE-Digital/curriculum-materials/blob/development/docs/Docker.md

## Running the tests

All of the unit and integration tests are written in [RSpec](https://rspec.info/). Run them
in the conventional manner:

```bash
$ budle exec rspec
```

Hopefully everything should be green!

## Schema

![Schema diagram](docs/schema.png)

## Glossary

| Word                | Description                                                                                                                                                                                    |
| ----                | -----------                                                                                                                                                                                    |
| CCP                 | Complete Curriculum Programme. A set of lesson materials and guidance that covers one subject for one Key Stage                                                                                |
| Curriculum Designer | The person or persons responsible for creating a CCP                                                                                                                                           |
| EAL                 | English as an additional language                                                                                                                                                              |
| FSM                 | Free School Meals                                                                                                                                                                              |
| LA                  | Local Authority e.g. Local Authority maintained schools                                                                                                                                        |
| MAT                 | Multi-Academy Trusts                                                                                                                                                                           |
| National curriculum | The national curriculum for England to be taught in all local-authority-maintained schools.                                                                                                    |
| PPA                 | Planning, preparation and assessment                                                                                                                                                           |
| Pedagogy            | Pedagogy, taken as an academic discipline, is the study of how knowledge and skills are imparted in an educational context, and it considers the interactions that take place during learning. |
| SEN                 | Special Educational Needs or SEND, Special Educational Needs and Disabilities                                                                                                                  |
| Unit                | A Unit of a CCP refers to the lessons that are delivered over the course of one half term. Normally 6 or 7 weeks                                                                               |


## Licence

[The MIT Licence](LICENCE)
