Feature: Pricing Requests
  Pricing request put in by a care home

Scenario Outline: Pricing Request
  Given there is a care_home "<care_home>" with me as admin "<admin>"
  Given there is a request "<request>"
  Given the request is on a weekday
  Given the request start time is "<start_time>"
  Given the request end time is "<end_time>"
  Given the rate is "<rate>"
  Given there are no bank holidays
  Then the price for the Staffing Request must be "<price>"
  Examples:
  	|care_home		|admin 			|request	                            |start_time |end_time    |rate|price |
  	|verified=true|role=Admin |role=Care Giver;speciality=Generalist|{hour:8}   |{hour:14}   |10  |60    |
  	|verified=true|role=Admin |role=Care Giver;speciality=Generalist|{hour:8}   |{hour:18}   |10  |100   |
    |verified=true|role=Admin |role=Nurse;speciality=Generalist     |{hour:7}   |{hour:17}   |12  |124   |
    |verified=true|role=Admin |role=Nurse;speciality=Mental Health  |{hour:20}  |{hour:23}   |15  |60    |
    |verified=true|role=Admin |role=Nurse;speciality=Mental Health  |{hour:0 }  |{hour:8}    |10  |106   |
    

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
    |verified=true|role=Admin |role=Nurse;speciality=Generalist     |10     |12  |160     |
    |verified=true|role=Admin |role=Nurse;speciality=Mental Health  |10     |15  |200     |


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
    |verified=true|role=Admin |role=Nurse;speciality=Generalist     |2.8   |12  |160     |
    |verified=true|role=Admin |role=Nurse;speciality=Mental Health  |3     |15  |200     |


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



Scenario Outline: Overtime Mins
  Given there is a request "<request>"
  Then the request overtime mins must be "<overtime>"
  
  Examples:
    |request                                                      | overtime  |
    |start_date=2017-06-07 00:00:00;end_date=2017-06-07 08:00:00  |480        |
    |start_date=2017-06-07 05:00:00;end_date=2017-06-07 13:00:00  |180        |
    |start_date=2017-06-07 08:00:00;end_date=2017-06-07 13:00:00  |0          |
    |start_date=2017-06-07 20:00:00;end_date=2017-06-08 09:00:00  |720        |
    |start_date=2017-06-07 19:00:00;end_date=2017-06-08 07:00:00  |660        |
    |start_date=2017-06-07 19:00:00;end_date=2017-06-08 09:00:00  |720        |
    |start_date=2017-06-07 10:00:00;end_date=2017-06-07 22:00:00  |120        |
    |start_date=2017-06-07 21:00:00;end_date=2017-06-07 23:30:00  |150        |
  