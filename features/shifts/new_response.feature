Feature: New Shift
  Generate a shift for temps given a new request

Scenario Outline: New Shift
  Given there is a request "<request>"
  Given there is a user "<user>"
  And the shift creator job runs
  Then A shift must be created for the user for the request
  And the request broadcast status must change to "Sent"
  And the users auto selected date should be set to today 

  Examples:
  	|request	                           | user                            |
  	|role=Care Giver                     |role=Care Giver;verified=true    |
  	|role=Nurse;speciality=Generalist    |role=Nurse;verified=true         |
    |role=Nurse;speciality=Generalist    |role=Nurse;speciality=Pediatric Care;verified=true|
    |role=Nurse;speciality=Pediatric Care|role=Nurse;speciality=Pediatric Care;verified=true|
    |role=Nurse;speciality=Mental Health |role=Nurse;speciality=Mental Health;verified=true        |
  	

Scenario Outline: New Shift for spcialist users with no match
  Given there is a request "<request>"
  Given there is a user "<user>"
  And the shift creator job runs
  Then A shift must not be created for the user for the request
  Then the admin user receives an email with "No shift found for request" in the subject

  Examples:
    |request                              | user                            |
    |role=Nurse;speciality=Generalist     |role=Care Giver;verified=true         |    
    |role=Care Giver;speciality=Generalist|role=Nurse;verified=true         |    
    

Scenario Outline: New Shift for unverified users
  Given there is a request "<request>"
  Given there is a user "<user>"
  And the shift creator job runs
  Then A shift must not be created for the user for the request

  Examples:
    |request                                        | user                            |
    |start_code=1111;end_code=0000 | role=Care Giver;verified=false  |
    |start_code=1111;end_code=0000 | role=Nurse;verified=false       |


Scenario Outline: New Shift without care givers
  Given there is a request "<request>"
  And the shift creator job runs
  Then the admin user receives an email with "No shift found for request" in the subject

  Examples:
    |request                       | user                            |
    |start_code=1111;end_code=0000 | role=Care Giver;verified=false  |
    |start_code=1111;end_code=0000 | role=Nurse;verified=false       |


Scenario Outline: New Shift when already rejected
  Given there is a request "<request>"
  Given there is a user "<user>"
  And the user has already rejected this request
  And the shift creator job runs
  Then A shift must not be created for the user for the request
  Then the admin user receives an email with "No shift found for request" in the subject

  Examples:
    |request                                        | user                            |
    |start_code=1111;end_code=0000 | role=Care Giver;verified=true   |
    |start_code=1111;end_code=0000 | role=Nurse;verified=true        |


Scenario Outline: New Shift when already booked in the same time shift
  Given there is a user "<user>"
  And the user has already accepted a request "<other_request>"
  Given there is a request "<request>"
  And the shift creator job runs
  Then A shift must not be created for the user for the request
  Then the admin user receives an email with "No shift found for request" in the subject
  
  Examples:
    |request                                                | user                            | other_request |
    |start_date=2017-05-21 08:00;end_date=2017-05-21 17:00  | role=Care Giver;verified=true   | start_date=2017-05-21 09:00;end_date=2017-05-21 18:00   |
    |start_date=2017-05-21 08:00;end_date=2017-05-21 17:00  | role=Nurse;verified=true        |start_date=2017-05-20 17:00;end_date=2017-05-21 09:00  |
    |start_date=2017-05-21 08:00;end_date=2017-05-21 17:00  | role=Care Giver;verified=true   | start_date=2017-05-20 09:00;end_date=2017-05-22 09:00   |
    