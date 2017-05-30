Feature: Pricing Requests
  Pricing request put in by a care home

Scenario Outline: Pricing Request
  Given there is a care_home "<care_home>" with me as admin "<admin>"
  Given there is a request "<request>" with start date atleast "<days1>" from now and end date atleast "<days2>" from now
  Given the rate is "<rate>"
  Given there are no bank holidays
  Then the price for the Staffing Request must be "<price>"
  Examples:
  	|care_home		|admin 			|request	                            |days1 |days2|rate|price |
  	|verified=true|role=Admin |role=Care Giver;speciality=Generalist|2     |2.5  |10  |120   |
  	|verified=true|role=Admin |role=Care Giver;speciality=Generalist|2     |2.5  |10  |120   |
    |verified=true|role=Admin |role=Nurse;speciality=Generalist     |2     |2.5  |12  |144   |
    |verified=true|role=Admin |role=Nurse;speciality=Mental Health  |2     |2.5  |15  |180   |
    

Scenario Outline: Pricing Request on Weekend
  Given there is a care_home "<care_home>" with me as admin "<admin>"
  Given there is a request "<request>" on a weekend for "<hours>"
  Given the rate is "<rate>"
  Given there are no bank holidays
  Then the price for the Staffing Request must be "<price>"
  Examples:
    |care_home    |admin      |request                              |hours  |rate|price   |
    |verified=true|role=Admin |role=Care Giver;speciality=Generalist|10     |10  |133     |
    |verified=true|role=Admin |role=Care Giver;speciality=Generalist|10     |10  |133     |
    |verified=true|role=Admin |role=Nurse;speciality=Generalist     |10     |12  |159.6   |
    |verified=true|role=Admin |role=Nurse;speciality=Mental Health  |10     |15  |199.5   |


Scenario Outline: Pricing Request last minute
  Given there is a care_home "<care_home>" with me as admin "<admin>"
  Given there is a request "<request>" "<hours>" from now
  Given the rate is "<rate>"
  Given there are no bank holidays
  Then the price for the Staffing Request must be "<price>"
  Examples:
    |care_home    |admin      |request                              |hours |rate|price   |
    |verified=true|role=Admin |role=Care Giver;speciality=Generalist|2     |10  |133     |
    |verified=true|role=Admin |role=Care Giver;speciality=Generalist|2.5   |10  |133     |
    |verified=true|role=Admin |role=Nurse;speciality=Generalist     |2.8   |12  |159.6   |
    |verified=true|role=Admin |role=Nurse;speciality=Mental Health  |3     |15  |199.5   |


Scenario Outline: Pricing Request on bank holiday
  Given there is a care_home "<care_home>" with me as admin "<admin>"
  Given there is a request "<request>" on a bank holiday
  Given the rate is "<rate>"
  Given there are bank holidays
  Then the price for the Staffing Request must be "<price>"
  Examples:
    |care_home    |admin      |request                              |rate|price   |
    |verified=true|role=Admin |role=Care Giver;speciality=Generalist|10  |150     |
    |verified=true|role=Admin |role=Care Giver;speciality=Generalist|10  |150     |
    |verified=true|role=Admin |role=Nurse;speciality=Generalist     |12  |180   |
    |verified=true|role=Admin |role=Nurse;speciality=Mental Health  |15  |225   |
