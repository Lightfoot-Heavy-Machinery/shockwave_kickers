Feature: Perform CRUD actions on students

As a professor,
So I can keep track of student information.
I want to be able to perform CRUD actions on students.

Given the following users exist:
| email                         | confirmed_at               |
| team_cluck_admin@gmail.com    | 2023-01-19 12:12:07.544080 |

Given the following courses exist:
| course_name | teacher                       | section | semester         |
| CSCE 411    | team_cluck_admin@gmail.com    | 501     | Spring 2023      | 
| CSCE 411    | team_cluck_admin@gmail.com    | 501     | Fall 2022        | 
| CSCE 412    | team_cluck_admin@gmail.com    | 501     | Spring 2023      | 


Given the following students exist:
| firstname | lastname  | uin       | email                 | classification | major | teacher                    | last_practice_at              | curr_practice_interval |
| Zebulun   | Oliphant  | 734826482 | zeb@tamu.edu          | U2             | CPSC  | team_cluck_admin@gmail.com | 2023-01-25 17:11:11.111111    | 120                    |
| Batmo     | Biel      | 274027450 | speedwagon@tamu.edu   | U1             | ENGR  | team_cluck_admin@gmail.com | 2023-01-25 17:11:11.111111    | 60                     |
| Ima       | Hogg      | 926409274 | piglet@tamu.edu       | U1             | ENGR  | team_cluck_admin@gmail.com | 2023-01-25 19:11:11.111111    | 240                    |
| Joe       | Mama      | 720401677 | howisjoe@tamu.edu     | U1             | ENGR  | team_cluck_admin@gmail.com | 2023-01-25 19:11:11.111111    | 120                    |
| Sheev     | Palpatine | 983650274 | senate@tamu.edu       | U2             | CPSC  | team_cluck_admin@gmail.com | 2023-01-25 19:11:11.111111    | 119                    |

Scenario: All students viewable
    When I sign in
    And I go to the students page
    And I should see "New student"

Scenario: Search by semester
    When I sign in
    Given I am on the upload page
    When I upload a zip file
    And I input form information
    When I click save
    Then I should see the upload was successful
    And I go to the students page
    And I select "Spring 2020" under semester
    Then I submit the form
    Then I should see "Kunal"

Scenario: Show a student
    When I sign in
    And I go to the students page
    When I click show this student
    Then I should see "Profile"

Scenario: Edit a student
    When I sign in
    And I go to the students page
    When I click show this student
    And I click "Edit this student"
    Then I should see "Editing Student"
    When I fill in student "firstname" with "EditTest"
    And I click "Update Student"
    Then I should see "EditTest"
    And I should see "Student information was successfully updated."

Scenario: Add and Delete a student
    When I sign in
    And I go to the students page
    When I click "New student"
    When I fill in student "firstname" with "New"
    When I fill in student "lastname" with "Student"
    When I fill in student "email" with "newstudent@email.com"
    And I click "Create Student"
    Then I should see "Student was successfully created"
    And I should see "New Student's Profile"
    And I click "Delete this student"
    Then I should see "New student"