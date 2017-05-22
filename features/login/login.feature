Feature: Login
  Login should be allowed only if there are valid credentials

Scenario Outline: Login Successfully
  Given there is a user "<user>"
  And I am at the login page
  When I fill and submit the login page
  Then I should see the "<msg>"

  Examples:
  	|user								                |msg	|
  	|first_name=Mohith;role=Care Giver	|Welcome|
    |first_name=Mohith;role=Nurse       |Welcome|
  	|first_name=Mohith;role=Admin		    |Welcome|



Scenario Outline: Login Incorrectly
  Given there is a user "<user>"
  And I am at the login page
  When I fill the password incorrectly and submit the login page
  Then I should see the "<msg>"

  Examples:
  	|user								                |msg	|
  	|first_name=Mohith;role=Care Giver	|Invalid login credentials|
    |first_name=Mohith;role=Nurse       |Invalid login credentials|
  	|first_name=Mohith;role=Admin		    |Invalid login credentials|