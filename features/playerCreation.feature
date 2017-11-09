Feature: Player Creation
  As a game humanPersonThing, I want to be able to create valid users

  Scenario Outline: Create valid first humanPersonThing
    Given I navigate to the initial game page
    When I enter <name> into field humanPersonThing 1
    Then humanPersonThing <name> should be created
    Examples:
      |name             |
      |Buzz             |
      |George P. Burdell|
      |Player 1         |

  Scenario Outline: Create valid second humanPersonThing
    Given I navigate to the initial game page
    When I enter <name> into field humanPersonThing 2
    Then humanPersonThing <name> should be created
    Examples:
      |name          |
      |Wonder Woman  |
      |Numero 2      |
      |Junior Jr.    |

  Scenario Outline: Create invalid humanPersonThings
    Given I navigate to the initial game page
    When I enter <first_user> into field humanPersonThing 1
    And I enter <second_user> into field humanPersonThing 2
    Then no humanPersonThings should be created
    And error message should be displayed
    Examples:
      |first_user |second_user|
      |Lightyear  |Lightyear  |
      |Ben&Jerry  |Bob!       |
      |           | " "       |
