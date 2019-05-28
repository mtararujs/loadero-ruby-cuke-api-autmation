Feature: Get account information

  Scenario: [POSITIVE] Retrieve account information
    Given I have authorization token
    And I have API endpoint with method: "POST" and path: "/v2/accounts/"
    And I send a request payload: "/account/create_account.json"
    And "email" in the request payload should be "$EMAIL"
    And I call the API
    And I should see http code 201
    And I save attribute "id" as "$ACCOUNT_ID"

    And I login as newly created user

    When I have API endpoint with method: "GET" and path: "/v2/accounts/$ACCOUNT_ID/"
    And I replace uri variable "$ACCOUNT_ID"
    And I call the API
    Then I should see http code 200
    And value for json path "id" should be "$ACCOUNT_ID"
    And value for json path "email" should be "$EMAIL"
    And value for json path "first_name" should be "QA"
    And value for json path "last_name" should be "TEST"
    And value for json path "last_login" should be "$TIMESTAMP"
    And value for json path "created" should be "$TIMESTAMP"
    And value for json path "updated" should be "$TIMESTAMP"
    And value for json path "superuser" should be "false"

    And I have API endpoint with method: "DELETE" and path: "/v2/accounts/$ACCOUNT_ID/"
    And I replace uri variable "$ACCOUNT_ID"
    And I add custom header "*"
    And I call the API
    And I should see http code 204
