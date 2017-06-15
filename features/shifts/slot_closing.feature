Feature: Shift Closing
  Ensure  a shift is closed properly

Scenario Outline: Close Shift
  Given there is a care_home "verified=true" with me as admin "role=Admin"
  Given there is a request "<request>"
  Given there is a user "<user>"
  And the user has already accepted this request
  Given jobs are being dispatched
  Then the user receives an email with "Shift Confirmed" as the subject
  And when the user enters the start and end code
  Given jobs are being dispatched
  Then the shift price is computed and stored
  Then the payment for the shift is generated
  Then the shift is marked as closed
  And the request is marked as closed 

  Examples:
  	|request	                         | user                            |
  	|role=Care Giver                     |role=Care Giver;verified=true    |
  	|role=Nurse;speciality=Generalist    |role=Nurse;verified=true         |
    |role=Nurse;speciality=Generalist    |role=Nurse;speciality=Pediatric Care;verified=true|
