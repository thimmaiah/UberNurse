Feature: Login
  Login should be allowed only if there are valid credentials

Scenario Outline: Login Successfully
  Given there is a user "<user>"
  And I am at the login page
  When I fill and submit the login page
  Then I should see the "<msg>"

  Examples:
  	|user							|msg	|
  	|role=Care Giver	|Welcome|
    |role=Nurse       |Welcome|
  	|role=Admin		    |Register Care Home|



Scenario Outline: Login Incorrectly
  Given there is a user "<user>"
  And I am at the login page
  When I fill the password incorrectly and submit the login page
  Then I should see the "<msg>"

  Examples:
  	|user							|msg	|
  	|role=Care Giver	|Invalid login credentials|
    |role=Nurse       |Invalid login credentials|
  	|role=Admin		    |Invalid login credentials|



Scenario Outline: Home page menus Care Giver
  Given there is a user "<user>"
  And the user has no bank account
  And I am at the login page
  When I fill and submit the login page
  Then I should see the all the home page menus "<menus>"

  Examples:
    |user                                                   |menus                |
    |role=Care Giver;verified=false;phone_verified=false    |Verify Mobile Number;Qualification Certificate;ID Card;Address Proof;DBS|
    |role=Nurse;verified=false;phone_verified=false         |Verify Mobile Number;Qualification Certificate;ID Card;Address Proof;DBS|




Scenario Outline: Home page menus Admin
  Given there is a care_home "<care_home>" with me as admin "<user>"
  And the care home has no bank account
  And I am at the login page
  When I fill and submit the login page
  Then I should see the all the home page menus "<menus>"

  Examples:
    |care_home     |user                               |menus                |
    |verified=false|role=Admin;phone_verified=false    |Verify Mobile Number;|
    |verified=false|role=Admin;phone_verified=false    |Verify Mobile Number;|


