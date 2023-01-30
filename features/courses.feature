Feature: Filter courses according to their defining traits, such as their course number, a recurring student, or a certain semester.

As a professor,
So I can more quickly recollect previous courses I’ve taught
I want to be able to filter and sort my courses.

Background: database

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

Scenario: All courses viewable
    Given students are enrolled in their respective courses
    When I sign in
    And I go to the courses page
    Then I should see "CSCE 411" offered in "Spring 2023"
    And I should see "CSCE 411" offered in "Fall 2022"
    And I should see "CSCE 412" offered in "Spring 2023"

Scenario: Filter courses by name
    Given students are enrolled in their respective courses
    When I sign in
    And I go to the courses page
    And I fill in "Search by Name" with "CSCE 411"
    And I click "Search Name"
    Then I should see "CSCE 411" offered in "Spring 2023"
    And I should see "CSCE 411" offered in "Fall 2022"
    And I should not see "CSCE 412" offered in "Spring 2023"

Scenario: Filter courses by student (first and last)
    Given students are enrolled in their respective courses
    When I sign in
    And I go to the courses page
    And I fill in "Search by Student" with "Zebulun Oliphant"
    And I click "Search Student"
    Then I should not see "CSCE 411" offered in "Spring 2023"
    And I should see "CSCE 411" offered in "Fall 2022"
    And I should see "CSCE 412" offered in "Spring 2023"

Scenario: Filter courses by student (just first name)
    Given students are enrolled in their respective courses
    When I sign in
    And I go to the courses page
    And I fill in "Search by Student" with "Zebulun"
    And I click "Search Student"
    Then I should not see "CSCE 411" offered in "Spring 2023"
    And I should see "CSCE 411" offered in "Fall 2022"
    And I should see "CSCE 412" offered in "Spring 2023"

Scenario: Filter courses by semester
    Given students are enrolled in their respective courses
    When I sign in
    And I go to the courses page
    And I fill in "Search by Semester" with "Spring 2023"
    And I click "Search Semester"
    Then I should see "CSCE 411" offered in "Spring 2023"
    And I should not see "CSCE 411" offered in "Fall 2022"
    And I should see "CSCE 412" offered in "Spring 2023"
    
