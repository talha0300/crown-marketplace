Feature: Supplier details

  Background: Navigate to the additional supplier information section
    Given I sign in as an admin and navigate to the 'RM3830' dashboard
    And I click on 'Supplier details'
    Then I am on the 'Supplier details' page
    And I click on 'Ullrich, Ratke and Botsford'
    Then I am on the 'Supplier details' page

  Scenario Outline: Supplier details breadcrumbs
    Given I click on '<text>'
    Then I am on the '<page>' page

    Examples:
      | text              | page                            |
      | Home              | RM3830 administration dashboard |
      | Supplier details  | Supplier details                |

  Scenario: Return links on pages
    And I change the '<supplier_detail>' for the supplier details
    Then I am on the '<current_page>' page
    Given I click on '<text>'
    Then I am on the 'Supplier details' page

    Examples:
      | supplier_detail | current_page                    | text                                      |
      | Current user    | Supplier user account           | Ullrich, Ratke and Botsford               |
      | Current user    | Supplier user account           | Cancel and return to the supplier details |
      | Supplier name   | Supplier name                   | Ullrich, Ratke and Botsford               |
      | Supplier name   | Supplier name                   | Cancel and return to the supplier details |
      | Contact name    | Supplier contact information    | Ullrich, Ratke and Botsford               |
      | Contact name    | Supplier contact information    | Cancel and return to the supplier details |
      | DUNS number     | Additional supplier information | Ullrich, Ratke and Botsford               |
      | DUNS number     | Additional supplier information | Cancel and return to the supplier details |
      | Full address    | Supplier address                | Ullrich, Ratke and Botsford               |
      | Full address    | Supplier address                | Cancel and return to the supplier details |
