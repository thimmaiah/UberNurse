Feature: Registration
  Registration should work properly

Scenario Outline: User Registration Successfully
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
  	|user								                |msg1											                      |msg2		|
  	|first_name=Mohith;role=Care Giver	|Please check your email for verification link	|Welcome	|
    |first_name=Mohith;role=Nurse       |Please check your email for verification link  |Welcome  |
    |first_name=Mohith;role=Admin		    |Please check your email for verification link	|Welcome	|


Scenario Outline: Register a care home with cqc
  Given Im a logged in user "<user>"  
  And I am at the care homes registration page
  When I search for the care home "<care home>"
  And I click on the search result care home
  And When and submit the care homes registration page with "<care_home>"
  Then I should see the "<msg1>"
  And the care home should be unverified
  And I should be associated with the care home
  Examples:
    |user                          |care home                  |msg1                                |
    |first_name=Mohith;role=Admin  |name=Kingswood House Nursing Home|Please call us to get your care home verified|
    |first_name=Mohith;role=Admin  |name=Little Haven                |Please call us to get your care home verified|


Scenario Outline: Register a care home without cqc
  Given Im a logged in user "<user>"  
  And I am at the care homes registration page
  When I search for the care home "<care home>"
  And I click "Register New Care Home"
  And I fill and submit the care homes registration page with  "<care_home>"
  Then I should see the "<msg1>"
  And the care home should be unverified
  And I should be associated with the care home
  Examples:
    |user                          |care home                   |msg1                                |
    |first_name=Mohith;role=Admin  |name=Kingswood House Nursing Home|Please call us to get your care home verified|
    |first_name=Mohith;role=Admin  |name=Little Haven                |Please call us to get your care home verified|


Scenario Outline: User Phone Verification
  Given Im a logged in user "<user>"  
  And I am at the phone verification page
  When I request a sms verification code
  Then an sms code must be generated
  Then when I submit the code
  Then the user should be phone verified
  Examples:
    |user                                                                    |
    |first_name=Mohith;role=Care Giver;verified=false;phone_verified=false   |
    |first_name=Mohith;role=Nurse;verified=false;phone_verified=false        |
    |first_name=Mohith;role=Admin;verified=false;phone_verified=false        |
