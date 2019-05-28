# File cwhich contains all cucumber step definitions

Given("I have authorization token") do
  default_host = @test_step.host
  @test_step.setMethod("POST:RAW")
  @test_step.setHost(@test_step.auth_host)
  @test_step.setPath("/auth/token/")

  file = File.read(Dir.pwd + '/request_payloads/auth/get_token')
  @test_step.request_payload = file
  @test_step.addHeader({'Content-Type' => 'application/x-www-form-urlencoded'})
  @test_step.addHeader({'Authorization' => '*'})
  execute_request();

  assert_status(200)
  response = JSON.parse(@test_step.response.body)
  token = response['access_token']
  @buffer.add_map({:authorization.to_s => token})
  @test_step.addHeader({:Authorization.to_s => "Bearer #{@buffer.get_value("authorization")}"})

  @test_step.setHost(default_host)
  @test_step.addHeader({'Content-Type' => 'application/json'})
end

Given("I login as newly created user") do
  default_host = @test_step.host
  @test_step.setMethod("POST:RAW")
  @test_step.setHost(@test_step.auth_host)
  @test_step.setPath("/auth/token/")

  file = File.read(Dir.pwd + '/request_payloads/auth/get_token_password_grant')
  puts @buffer.get_value("$EMAIL").gsub(/\n/," ")
  puts file
  @test_step.request_payload = "#{file}#{@buffer.get_value("$EMAIL")}"
  file.gsub! "$EMAIL", @buffer.get_value("$EMAIL").to_s
  @test_step.request_payload = file.chomp
  @test_step.addHeader({'Content-Type' => 'application/x-www-form-urlencoded'})
  @test_step.addHeader({'Authorization' => '*'})
  execute_request();

  assert_status(200)
  response = JSON.parse(@test_step.response.body)
  token = response['access_token']
  @buffer.add_map({:authorization.to_s => token})
  @test_step.addHeader({:Authorization.to_s => "Bearer #{@buffer.get_value("authorization")}"})

  @test_step.setHost(default_host)
  @test_step.removeHeader('Content-Type')
end

Given("I have API endpoint with method: {string} and path: {string}") do |method, path|
  @test_step.setMethod(method)
  @test_step.setPath(path)
end

When("I call the API") do
  execute_request()
end

Then("I should see http code {int}") do |code|
  assert_status(code)
end

And("I send a request payload: {string}") do |payload|
  file = File.read(Dir.pwd + '/request_payloads' + payload)
  payload_hash = JSON.parse(file)
  @test_step.request_payload = payload_hash
end

Then("value for json path {string} should be {string}") do |path, value|
  response_hash = JSON.parse(@test_step.response.body)
  found_value_at_path = response_hash.get_at_path(path)

  if(value == "$TIMESTAMP")
    assert_equal(true,
      /^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}Z$/.match?(found_value_at_path.to_s),
      path + ' key is not matching expected value: ' + value.to_s)
  else
    buffer_value = @buffer.get_value(value)
    buffer_value = buffer_value.nil? ? value : buffer_value

    assert_equal(buffer_value.to_s, found_value_at_path.to_s, path + ' key is not matching expected value: ' + buffer_value.to_s)
    puts "Searching for pattern or value: #{buffer_value}"
  end
end

And(/^I save attribute "([^"]*)" as "([^"]*)"$/) do |path, variable|
  response = JSON.parse(@test_step.response.body)
  value = response.get_at_path(path)
  @buffer.add_map({variable => value})
end

And(/^I replace uri variable "([^"]*)"$/) do |variable|
  @test_step.path.gsub! variable, @buffer.get_value(variable).to_s
end

And(/^"([^"]*)" in the request payload should be "([^"]*)"$/) do |path, value|
  if (value == "$EMAIL")
    $email = "#{SecureRandom.uuid}@qatest.com"
    @buffer.add_map({"$EMAIL" => $email})
    value = @buffer.get_value(value)
  else
    value = @buffer.get_value(value)
  end
  @test_step.request_payload.replace_at_path(path, value)
end


And(/^I add custom header "([^"]*)"$/) do |header|
  @header_input = header.split(':')
  @test_step.addHeader({@header_input[0] => @header_input[1]})
end
