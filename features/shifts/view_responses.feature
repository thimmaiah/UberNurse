Feature: View Slot
  View a slot for temps given a new request

Scenario Outline: View My Slot
  Given there is a request "<request>"
  Given there is a user "<user>"
  And the slot creator job runs
  Given Im a logged in 
  When I click "My Slots"
  Then I must see the slot 
  When I click the slot for details
  Then I must see the slot details

  Examples:
  	|request	                           | user                            |
  	|role=Care Giver                     | role=Care Giver;verified=true   |
  	|role=Nurse;speciality=Mental Health | role=Nurse;speciality=Mental Health;verified=true        |
  	
Scenario Outline: Cannot View Others Slots
  Given there are "<number>" of slots
  Given Im a logged in user "<user>"
  When I click "My Slots"
  Then I must not see the slots 

  Examples:
    |number | user                            |
    |1      | role=Care Giver;verified=true   |
    |2      | role=Nurse;verified=true        |


Scenario Outline: View All Slots for care_home
  Given there is a care_home "<care_home>" with me as admin "<admin>"
  Given there are "<number>" of verified requests
  Given Im a logged in
  Given there are "<number>" of slots for the care_home
  When I click "My Slots"
  Then I must see all the slots 
  

  Examples:
    |care_home     |admin                    |number | user                            |
    |verified=true|role=Admin;verified=true |1      | role=Care Giver;verified=true   |
    |verified=true|role=Admin;verified=true |2      | role=Nurse;verified=true        |
