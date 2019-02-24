Feature: Agency
  Agency adds users and care homes to its network

Scenario Outline: Carer Added
  Given there is a user "<user>"
  Given there is an agency "<agency>"  
  When the agency adds the user to its network
  Given jobs are being dispatched
  Then the user receives an email with "Accept Agency" in the subject


  Examples:
  	|user							|agency	|
  	|role=Care Giver	|name=Agency1|
    |role=Nurse       |name=Agency2|



Scenario Outline: Care Home Added
  Given there is a care_home "name=Test Care Home" with an admin "role=Admin"
  Given there is an agency "<agency>"  
  When the agency adds the care home to its network
  Given jobs are being dispatched
  Then the care home receives an email with "Accept Agency" in the subject


  Examples:
    |agency |
    |name=Agency1|
    |name=Agency2|

