Feature: Auto Reject Slot
  Auto reject a pending slot

Scenario Outline: Auto Reject Slot
  Given there is a slot for a user "<user>" with status "Pending"
  And the slot was created "<mins>" before
  And the slot pending job runs
  Then A slot status must be "<status>"

  Examples:
  	|user	                               |mins | status           |
  	|role=Care Giver                     | 45  | Auto Rejected    |
  	|role=Nurse;speciality=Generalist    | 32  | Auto Rejected    |
    |role=Care Giver                     | 20  | Pending          |
    |role=Nurse;speciality=Generalist    | 28  | Pending          |
    