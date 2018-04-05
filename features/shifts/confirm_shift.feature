Feature: View Shift
  View a shift for temps given a new request

Scenario Outline: Accept My Shift
  Given there is a request "<request>"
  Given there is a user "<user>"
  And the shift creator job runs
  Given Im logged in 
  When I click "Pending Shifts"
  Then I must see the shift 
  Given jobs are cleared
  When I click the shift for details
  When I click "Accept"
  Then the shift is "Accepted"
  Given jobs are being dispatched
  Then the user receives an email with "Shift Confirmed" in the subject

  Examples:
  	|request	                           | user                            |
  	|role=Care Giver                     | role=Care Giver;verified=true   |
  	|role=Nurse;speciality=Mental Health | role=Nurse;speciality=Mental Health;verified=true        |


Scenario Outline: Decline My Shift
  Given there is a request "<request>"
  Given there is a user "<user>"
  And the shift creator job runs
  Given Im logged in 
  When I click "Pending Shifts"
  Then I must see the shift 
  Given jobs are cleared
  When I click the shift for details
  When I click "Decline"
  Then the shift is "Rejected"
  Given jobs are being dispatched
  Then the user receives an email with "Shift Cancelled" in the subject

  Examples:
    |request                             | user                            |
    |role=Care Giver                     | role=Care Giver;verified=true   |
    |role=Nurse;speciality=Mental Health | role=Nurse;speciality=Mental Health;verified=true        |
