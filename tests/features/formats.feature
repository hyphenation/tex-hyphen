Feature: Making formats

  Scenario Outline: Making formats
    Given I set up the environment for texhyphen
    When I make the format for <format>
    Then it should make a format file

  Scenarios: List of formats
    | format  |
    | platex  |
    | xelatex |
    | xetex   |
