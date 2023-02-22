# README

**Team Cluck**

Team members: Ethan Novicio, Neha Manual, Harshitha Dhulipala, Caleb Oliphant

If user sign up is down, website can be accessed with:

email: yourdummycluck@gmail.com

password: abc_123!


**Testing**
```
git clone <repo> project
cd project
bundle
rake db:migrate
- This may not work if database.yml has the wrong password
- It can be fixed by inputting the right password in the database.yml file
rake db:seed
rake db:test:prepare
rake spec
rake cucumber

to run locally:
bundle exec rake assets:precompile
rails s
```



**Deployed App**
https://student-knowledge-system.herokuapp.com/users/sign_in


**User Documentation**
https://docs.google.com/document/d/1ATG78_72BFUqlMq_9StImvI8vVKKumL87lb0Caz3JoQ/edit?usp=sharing

This document should include startup guide for both heroku and local setup (windows and mac user). This also contains other instructions to store s3 and send confirmation emails when running locally

Doc version also exists under documentation folder.
