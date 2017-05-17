Feature: Registration
  Registration should be work properly

Scenario Outline: Login Successfully
  Given there is an unsaved user "<user>"
  And I am at the registration page
  When I fill and submit the registration page
  Then I should see the "<msg1>"
  Then when I click the confirmation link
  Then the user should be confirmed
  And I am at the login page
  When I fill and submit the login page
  Then I should see the "<msg2>"
  

  Examples:
  	|user								|msg1											|msg2		|
  	|first_name=Mohith;role=Care Giver	|Please check your email for verification link	|Welcome	|
  	|first_name=Mohith;role=Admin		|Please check your email for verification link	|Welcome	|
