Feature: Upload a batch of students and a course with Howdy zip file

As a professor,
So I can input data quickly
I want to be able to upload a file from howdy to input students and a course


Scenario: Upload correctly
    When I sign in
    Given I am on the upload page
    When I upload a zip file
    And I input form information
    When I click save
    Then I should see the students uploaded