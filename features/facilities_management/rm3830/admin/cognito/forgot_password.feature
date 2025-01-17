Feature: Forgot my password - RM3830 - Admin

  Scenario: I forgot my password
    When I go to the facilities management 'RM3830' admin start page
    And I am on the 'Sign in to the RM3830 administration dashboard' page
    When I click on 'I’ve forgotten my password'
    Then I am on the 'Reset password' page
    And I can reset my password with the roles:
      | fm_access     |
      | ccs_employee  |
    Then I am on the 'Reset your password' page
    And I enter the following details into the form:
      | New password          | ValidPassword1! |
      | Confirm new password  | ValidPassword1! |
      | Verification code     | 123456          |
    And I click on 'Reset password'
    Then I am on the 'You have successfully changed your password' page
    And I click on 'Sign in'
    And I am on the 'Sign in to the RM3830 administration dashboard' page
