Feature: Navigation links when signed out

  Background: Supplier on sign in page
    Given I go to the facilities management supplier start page

  Scenario: Sign in page 
    Then there are no header navigation links

  Scenario: Not permitted page
    And I go to the 'supplier' not permitted page for 'RM3830'
    And I should see the following navigation links:
      | Back to start |

  Scenario: Cookies policy
    When I click on 'Cookie policy'
    Then I am on the 'Details about cookies on Crown Marketplace' page
    And I should see the following navigation links:
      | Back to start |
    And I click on 'Back to start'
    And I am on the 'Sign in to your account' page

  Scenario: Cookies settings
    When I click on 'Cookie settings'
    Then I am on the 'Cookies on Crown Marketplace' page
    And I should see the following navigation links:
      | Back to start |
    And I click on 'Back to start'
    And I am on the 'Sign in to your account' page

  Scenario: Accessibility statement
    When I click on 'Accessibility statement'
    Then I am on the 'Facilities Management (FM) Accessibility statement' page
    And I should see the following navigation links:
      | Back to start |
    And I click on 'Back to start'
    And I am on the 'Sign in to your account' page
