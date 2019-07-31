## Task Management

* Ruby version : 2.6.0

* Rails version : 2.5.3

* Database : PostgreSQL 1.1.4

* Server : Heroku

* ER Model

* Schema

## Heroku Deploy:

1. Create New App on Heroku (taskgrace2019)

2. `$ heroku login`

3. `$ heroku git:remote -a taskgrace2019`

4. `$ git push heroku master`

5. `$ heroku run bundle install`

6. `$ heroku run rails db:migrate`
7.