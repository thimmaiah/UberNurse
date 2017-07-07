Feature: Auto Reject Shift
  Auto reject a pending shift

Scenario Outline: Auto Reject Shift
  Given there is a shift for a user "<user>" with status "Pending"
  And the shift was created "<mins>" before
  And the shift pending job runs
  Then A shift status must be "<status>"

  Examples:
  	|user	                               |mins | status           |
  	|role=Care Giver                     | 45  | Auto Rejected    |
  	|role=Nurse;speciality=Generalist    | 32  | Auto Rejected    |
    |role=Care Giver                     | 20  | Pending          |
    |role=Nurse;speciality=Generalist    | 28  | Pending          |
    