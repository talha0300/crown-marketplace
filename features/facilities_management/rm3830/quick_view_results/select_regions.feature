@javascript
Feature: Select regions
  
  Background: Navigate to the Services page
    Given I sign in and navigate to my account for 'RM3830'
    And I click on 'Quick view suppliers'
    Then I am on the 'Services' page
    And I open all sections
    And I select 'Building management system (BMS) maintenance'
    And I click on 'Continue'
    Then I am on the 'Regions' page
    And I open all sections

  Scenario: Service selection appears in basked
    Then the basket should say 'No regions selected'
    And the remove all link should not be visible
    When I select 'Tees Valley and Durham'
    Then the basket should say '1 region selected'
    And the remove all link should not be visible
    And the following items should appear in the basket:
      | Tees Valley and Durham  |
    When I select the following items:
      | Lancashire                                                                    |
      | Essex                                                                         |
      | Inner London - West                                                           |
      | Inner London - East                                                           |
      | Gwynedd                                                                       |
      | East Lothian and Midlothian                                                   |
      | Outer Belfast (Carrickfergus, Castlereagh, Lisburn, Newtownabbey, North Down) |
    Then the basket should say '8 regions selected'
    And the remove all link should be visible
    And the following items should appear in the basket:
      | Tees Valley and Durham                                                        |
      | Lancashire                                                                    |
      | Essex                                                                         |
      | Inner London - West                                                           |
      | Inner London - East                                                           |
      | Gwynedd                                                                       |
      | East Lothian and Midlothian                                                   |
      | Outer Belfast (Carrickfergus, Castlereagh, Lisburn, Newtownabbey, North Down) |

  @pipeline
  Scenario: Changing the selection will change the basket
    When I select the following items:
      | Essex                       |
      | Inner London - West         |
      | Inner London - East         |
      | Gwynedd                     |
      | East Lothian and Midlothian |
    Then the basket should say '5 regions selected'
    And the remove all link should be visible
    And the following items should appear in the basket:
      | Essex                       |
      | Inner London - West         |
      | Inner London - East         |
      | Gwynedd                     |
      | East Lothian and Midlothian |
    When I deselect the following items:
      | Inner London - West |
    Then the basket should say '4 regions selected'
    And the remove all link should be visible
    And the following items should appear in the basket:
      | Essex                       |
      | Inner London - East         |
      | Gwynedd                     |
      | East Lothian and Midlothian |
    When I remove the following items from the basket:
      | Essex   |
      | Gwynedd |
    Then the basket should say '2 regions selected'
    And the remove all link should be visible
    And the following items should appear in the basket:
      | Inner London - East         |
      | East Lothian and Midlothian |
    When I click on 'Remove all'
    Then the basket should say 'No regions selected'

  Scenario: Select all checkbox
    When I select all for 'East of England'
    Then the basket should say '3 regions selected'
    And the remove all link should be visible
    And the following items should appear in the basket:
      | East Anglia                     |
      | Bedfordshire and Hertfordshire  |
      | Essex                           |
    When I remove the following items from the basket:
      | Bedfordshire and Hertfordshire |
    Then select all 'should not' be checked for 'East of England'
    When I select 'Bedfordshire and Hertfordshire'
    Then select all 'should' be checked for 'East of England'

  Scenario: Go back from regions and change selection
    When I select the following items:
      | Essex                       |
      | Gwynedd                     |
      | Inner London - East         |
      | East Lothian and Midlothian |
    And I click on 'Continue'
    Then I am on the 'Quick view results' page
    And I click on the 'Return to regions' back link
    Then I am on the 'Regions' page
    And the following items should appear in the basket:
      | Essex                       |
      | Inner London - East         |
      | Gwynedd                     |
      | East Lothian and Midlothian |