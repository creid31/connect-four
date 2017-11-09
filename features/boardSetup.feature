Feature: Board Setup
  As a game humanPersonThing, I want my board to be setup accurately.

  Scenario: Initial Setup
    Given I navigate to the initial game page
    When I enter valid humanPersonThings
    Then the board with 7 columns and 6 rows should load

  Scenario Outline: Player Valid Move
    Given the board has loaded accurately
    When I click on circle in row <row_num> and column <col_num>
    Then that circle should fill with my color
    Examples:
    |row_num|col_num|
    |0      |0      |
    |0      |6      |
    |5      |0      |
    |5      |6      |

  Scenario Outline: Player Invalid Move
    Given the board has loaded accurately
    When I click on circle in row <row_num> and column <col_num>
    Then that circle should not fill with my color
    And an error message is shown
    Examples:
    |row_num|col_num|
    |6      |7      |
    |0      |8      |
    |7      |0      |
    |-1     |6      |
    |5      |-1     |    
