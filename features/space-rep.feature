Feature: Add dynamically created quizzes that use spaced repetition

As a professor
So that I can practice matching a students name to their face
I want to use a quiz to repeatedly practice learning student names


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
| Batmo     | Biel      | 274027450 | speedwagon@tamu.edu   | U1             | ENGR  | team_cluck_admin@gmail.com | 2023-01-25 18:11:11.111111    | 60                     |
| Ima       | Hogg      | 926409274 | piglet@tamu.edu       | U1             | ENGR  | team_cluck_admin@gmail.com | 2023-01-25 19:11:11.111111    | 240                    |
| Joe       | Mama      | 720401677 | howisjoe@tamu.edu     | U1             | ENGR  | team_cluck_admin@gmail.com | 2023-01-25 19:11:11.111111    | 120                    |
| Sheev     | Palpatine | 983650274 | senate@tamu.edu       | U2             | CPSC  | team_cluck_admin@gmail.com | 2023-01-25 17:11:11.111111    | 119                    |

Scenario: Due students display on home page
    Given students are enrolled in their respective courses
    When I sign in
    Then I should not see "Quizzes"
    And I should see "Students due for you to practice: 205"
