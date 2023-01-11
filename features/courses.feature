Feature: Filter courses according to their defining traits, such as their course number, a recurring student, or a certain semester, 
and sort courses in terms of their relevance.

As a professor,
So I can more quickly recollect previous courses I’ve taught
I want to be able to filter and sort my courses.

Background: database

Given the following courses exist:

| course_name | teacher                 | section | semester         |
| CSCE 121    | oliphcal000@tamu.edu    | 501     | Spring 2023      | 
| CSCE 121    | oliphcal000@tamu.edu    | 501     | Fall 2022        | 
| CSCE 221    | oliphcal000@tamu.edu    | 501     | Spring 2023      | 


Given the following students exist:
| firstname | lastname  | uin       | email                 | classification | major | teacher              |
| Zebulun   | Oliphant  | 734826482 | zeb@tamu.edu          | U2             | CPSC  | oliphcal000@tamu.edu |
| Batmo     | Biel      | 274027450 | speedwagon@tamu.edu   | U1             | ENGR  | oliphcal000@tamu.edu |
| Ima       | Hogg      | 926409274 | piglet@tamu.edu       | U1             | ENGR  | oliphcal000@tamu.edu |
| Joe       | Mama      | 720401677 | howisjoe@tamu.edu     | U1             | ENGR  | oliphcal000@tamu.edu |
| Sheev     | Palpatine | 983650274 | senate@tamu.edu       | U2             | CPSC  | oliphcal000@tamu.edu |

Scenario: Filter courses accordint to thier course number
    Given I am on the Courses page
    And students are enrolled in their respective courses
    
