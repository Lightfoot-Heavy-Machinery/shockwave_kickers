Feature: login to dashboard with ouath

Feature: Add google authentication and login with OTP
As a professor
So that I can login to the application with my google account
I want to connect my google account or login with the classic method via OTP

Background: user login credentials in database

  Given the following users exist:
  | email                      | password          |
  | team_cluck_admin@gmail.com | team_cluck_12345! |
  

Scenario: an authorized user logs in correctly
  Given an authorized user
  When the oauth login button is pressed
  Then the ouath login is shown
  When the user inputs the correct credentials
  Then the user is shown the dashboard

Scenario: an authorized user logs in incorrectly
  Given an authorized user
  When the login button is pressed
  Then the ouath login is shown
  Then the one time password is sent
  When the user inputs the incorrect password
  Then the user is shown they inputted an incorrect password

Scenario: an unauthorized user tries to log in
  Given an unrecognized user with an unauthorized email
  When the oauth button is pressed
  Then the ouath login is shown
  Then the user is prompted to sign up