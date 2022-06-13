Feature: Removing services for suppliers on the admin tool and seeing the effect on the results

  Background: Sign in and navigate to the admin dashboard
    Given I sign in as an admin and navigate to the 'RM6232' dashboard

  Scenario Outline: Total services - service selection
    Given I go to a quick view with the following services, regions and annual contract value:
      | F.1  | UKH1  | <contract_value>  |
      | K.2  | UKH2  |                   |
    Then I should be in sub-lot '1<lot_number>'
    And I 'should' see the supplier "<supplier_name>" in the results
    Given I go to the admin dashboard for 'RM6232'
    And I click on 'Supplier data'
    Then I am on the 'Supplier data' page
    And I click on 'View lot data' for '<supplier_name>'
    Then I am on the 'View lot data' page
    Then I change the 'services' for lot '<lot_number>'
    Then I am on the 'Lot <lot_number> services' page
    And I deselect the following items:
      | Taxi booking Service  |
    And I click on 'Save and return'
    Then I am on the 'View lot data' page
    Given I go to a quick view with the following services, regions and annual contract value:
      | F.1  | UKH1  | <contract_value>  |
      | K.2  | UKH2  |                   |
    Then I should be in sub-lot '1<lot_number>'
    And I 'should not' see the supplier "<supplier_name>" in the results

    Examples:
      | contract_value  | lot_number  | supplier_name     |
      | 500000          | a           | Skiles LLC        |
      | 2000000         | b           | Turcotte and Sons |
      | 11000000        | c           | Berge-Koepp       |

  @pipeline
  Scenario Outline: Hard services - service selection
    Given I go to a quick view with the following services, regions and annual contract value:
      | F.2   | UKL18 | <contract_value>  |
      | N.10  | UKL24 |                   |
    Then I should be in sub-lot '2<lot_number>'
    And I 'should' see the supplier "<supplier_name>" in the results
    Given I go to the admin dashboard for 'RM6232'
    And I click on 'Supplier data'
    Then I am on the 'Supplier data' page
    And I click on 'View lot data' for '<supplier_name>'
    Then I am on the 'View lot data' page
    Then I change the 'services' for lot '<lot_number>'
    Then I am on the 'Lot <lot_number> services' page
    And I deselect the following items:
      | Housing and residential accommodation management  |
    And I click on 'Save and return'
    Then I am on the 'View lot data' page
    Given I go to a quick view with the following services, regions and annual contract value:
      | F.2  | UKL18  | <contract_value>  |
      | N.10  | UKL24  |                   |
    Then I should be in sub-lot '2<lot_number>'
    And I 'should not' see the supplier "<supplier_name>" in the results

    Examples:
      | contract_value  | lot_number  | supplier_name               |
      | 500000          | a           | Turner-Pouros               |
      | 2000000         | b           | Miller, Walker and Leffler  |
      | 11000000        | c           | Berge-Koepp                 |

  Scenario Outline: Soft services - service selection
    Given I go to a quick view with the following services, regions and annual contract value:
      | H.2  | UKH3  | <contract_value>  |
      | I.9  | UKK4  |                   |
    Then I should be in sub-lot '3<lot_number>'
    And I 'should' see the supplier "<supplier_name>" in the results
    Given I go to the admin dashboard for 'RM6232'
    And I click on 'Supplier data'
    Then I am on the 'Supplier data' page
    And I click on 'View lot data' for '<supplier_name>'
    Then I am on the 'View lot data' page
    Then I change the 'services' for lot '<lot_number>'
    Then I am on the 'Lot <lot_number> services' page
    And I deselect the following items:
      | Cleaning of communications and equipment rooms  |
    And I click on 'Save and return'
    Then I am on the 'View lot data' page
    Given I go to a quick view with the following services, regions and annual contract value:
      | H.2  | UKH3  | <contract_value>  |
      | I.9  | UKK4  |                   |
    Then I should be in sub-lot '3<lot_number>'
    And I 'should not' see the supplier "<supplier_name>" in the results

    Examples:
      | contract_value  | lot_number  | supplier_name                 |
      | 500000          | a           | Conn, Hayes and Lakin         |
      | 2000000         | b           | Donnelly, Wiegand and Krajcik |
      | 11000000        | c           | Schmeler Inc                  |