Feature: View Shift
  View a shift for temps given a new request

Scenario Outline: Confirm My Shift
  Given there is a request "<request>"
  Given there is a user "<user>"
  And the shift creator job runs
  Given Im logged in 
  When I click "New Shifts Available"
  Then I must see the shift 
  When I click the shift for details
  When I click "Accept"
  Then the shift is "Accepted"

  Examples:
  	|request	                           | user                            |
  	|role=Care Giver                     | role=Care Giver;verified=true   |
  	|role=Nurse;speciality=Mental Health | role=Nurse;speciality=Mental Health;verified=true        |
