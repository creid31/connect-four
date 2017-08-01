Feature: Player Creation
  As a game player, I want to be able to create valid users

  Scenario Outline: Create valid first player
    Given I navigate to the initial game page
    When I enter <name> into field player 1
    Then player <name> should be created
    Examples:
      |name             |
      |Buzz             |
      |George P. Burdell|
      |Player 1         |

  Scenario Outline: Create valid second player
    Given I navigate to the initial game page
    When I enter <name> into field player 2
    Then player <name> should be created
    Examples:
      |name          |
      |Wonder Woman  |
      |Numero 2      |
      |Junior Jr.    |

  Scenario Outline: Create invalid players
    Given I navigate to the initial game page
    When I enter <first_user> into field player 1
    And I enter <second_user> into field player 2
    Then no players should be created
    And error message should be displayed
    Examples:
      |first_user |second_user|
      |Lightyear  |Lightyear  |
      |Ben&Jerry  |Bob!       |
      |           | " "       |
