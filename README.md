# Bank transference microservice API for CLP subject

## language, frameworks and tools versions:
- Ruby: version 3.2.2
- Ruby on Rails: Version 7.0.7.2
- Postgresql: version 15.3
- Required gems(Ruby libraries):
  - bundler(to install the gemfile): version 2.4.10
  - All other required gems are on the **Gemfile**  

## How to run:
install the desired ruby version installer or version manager from [ruby install documentation](https://www.ruby-lang.org/pt/documentation/installation/)  
Install PostgresSQL from [PostgreSQL Downloads](https://www.postgresql.org/download/)  
Create a file .env file on the bank_transference folder with your database credentials:
```
BANK_TRANSFERENCE_DATABASE_PASSWORD=yourPassword
BANK_TRANSFERENCE_DATABASE_USERNAME=yourUser
```
Run the following commands
```bash
$ gem install rails
$ gem install bundler
$ cd bank_transference #Assert that you are on the root project folder
$ bundler init #Create the gem environment
$ bundler install #Install the dependencies
$ rails db:create db:migrate db:seed #Creating the database and seeding it
$ rails s #Run the application
```
## Documentation
[Documentation file in pdf]()