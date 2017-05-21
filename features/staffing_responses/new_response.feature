Feature: New Slot
  Generate a slot for temps given a new request

Scenario Outline: New Slot
  Given there is a request "<request>"
  Given there is a user "<user>"
  And the slot creator job runs
  Then A slot must be created for the user for the request
  And the request broadcast status must change to "Sent"
  And the users auto selected date should be set to today 

  Examples:
  	|request	                                      | user                            |
  	|rate_per_hour=10;start_code=1111;end_code=0000 | role=Care Giver;verified=true   |
  	|rate_per_hour=10;start_code=1111;end_code=0000 | role=Nurse;verified=true        |
  	

Scenario Outline: New Slot for unverified users
  Given there is a request "<request>"
  Given there is a user "<user>"
  And the slot creator job runs
  Then A slot must not be created for the user for the request

  Examples:
    |request                                        | user                            |
    |rate_per_hour=10;start_code=1111;end_code=0000 | role=Care Giver;verified=false  |
    |rate_per_hour=10;start_code=1111;end_code=0000 | role=Nurse;verified=false       |


Scenario Outline: New Slot when already rejected
  Given there is a request "<request>"
  Given there is a user "<user>"
  And the user has already rejected this request
  And the slot creator job runs
  Then A slot must not be created for the user for the request

  Examples:
    |request                                        | user                            |
    |rate_per_hour=10;start_code=1111;end_code=0000 | role=Care Giver;verified=true   |
    |rate_per_hour=10;start_code=1111;end_code=0000 | role=Nurse;verified=true        |


Scenario Outline: New Slot when already booked in the same time slot
  Given there is a user "<user>"
  And the user has already accepted a request "<other_request>"
  Given there is a request "<request>"
  And the slot creator job runs
  Then A slot must not be created for the user for the request

  Examples:
    |request                                                | user                            | other_request |
    |start_date=2017-05-21 08:00;end_date=2017-05-21 17:00  | role=Care Giver;verified=true   | start_date=2017-05-21 09:00;end_date=2017-05-21 18:00   |
    |start_date=2017-05-21 08:00;end_date=2017-05-21 17:00  | role=Nurse;verified=true        |start_date=2017-05-20 17:00;end_date=2017-05-21 09:00  |
    |start_date=2017-05-21 08:00;end_date=2017-05-21 17:00  | role=Care Giver;verified=true   | start_date=2017-05-20 09:00;end_date=2017-05-22 09:00   |
    