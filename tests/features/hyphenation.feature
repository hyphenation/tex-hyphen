Feature: Tests for hyph-utf8

  A small, tentative test file for hyph-utf8

  Scenario Outline: Testing hyphenation
    Given the main language is <language>
    And I am testing XeTeX
    And I state \font\iwonastraight="[Iwona-Regular]"
    And I state \font\iwonatextext="[Iwona-Regular]:mapping=tex-text"
    When I set "<set_lccodes> <font> <input>" in a very narrow paragraph
    Then I should see "<result>"

  Scenarios: French and Italian
    | language | set_lccodes        | font           | input            | result              |
    | Italian  |                    | \iwonastraight | a dell'amicizia  | a dell'amicizia     |
    | Italian  | \lccode"27="27     | \iwonastraight | a dell'amicizia  | a del-l'a-mi-ci-zia |
    | Italian  | \lccode"2019="0027 | \iwonatextext  | a dell'amicizia  | a del-l’a-mi-ci-zia |
    | Italian  | \lccode"2019="2019 | \iwonatextext  | a dell'amicizia  | a del-l’a-mi-ci-zia |
    | French   |                    | \iwonastraight | de l'information | de l'information    |
    | French   | \lccode"27="27     | \iwonastraight | de l'information | de l'in-for-ma-tion |
    | French   | \lccode"2019="0027 | \iwonatextext  | de l'information | de l’in-for-ma-tion |
    | French   | \lccode"2019="2019 | \iwonatextext  | de l'information | de l’in-for-ma-tion |
