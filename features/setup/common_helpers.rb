require 'minitest/autorun'
require 'test-unit'

# Method to execute request and add additional output which will be also displayed in test report
def execute_request
  start_time = Time.now
  puts "Start time: #{start_time}"
  puts "Endpoint: #{@test_step.method} #{@test_step.host}#{@test_step.path}"

  puts "Request headers:\n#{JSON.pretty_generate(@test_step.headers)}"
  request_payload_output = @test_step.request_payload
  puts "Request payload:\n#{JSON.pretty_generate(request_payload_output)}"

  response = @test_step.executeRequest()
  response_time = Time.now - start_time
  @test_step.setResponse(response)

  puts "Response HTTP Code: #{@test_step.response.code}"
  puts "Response time: #{(response_time * 1000).to_i} ms"

  headers = @test_step.response.headers
  puts "Response headers:\n#{JSON.pretty_generate(headers)}"

  response_body = @test_step.response.body
  if (!response_body.empty?)
    response_body = JSON.parse(response_body)
  end
  puts "Response payload:\n#{JSON.pretty_generate(response_body)}"
  @test_step.request_payload = ""
end

def assert_status(code)
  assert_equal(code, @test_step.response.code, "Status Code mismatch! Got: " + @test_step.response.code.to_s + " Expected: " + code.to_s)
end

# https://stackoverflow.com/questions/51012203/replace-and-access-values-in-nested-hash-json-by-path-in-ruby/51012697?noredirect=1#comment89018794_51012697
# This stackoverflow topic was opened by myself and solution based on comments added.
SEPERATOR = '/'.freeze
class Hash
  def get_at_path(path)
    dig(*steps_from(path))
  end

  def replace_at_path(path, new_value)
    *steps, leaf = steps_from path
    hash = steps.empty? ? self : dig(*steps)
    hash[leaf] = new_value
  end

  def remove_at_path(path)
    *steps, leaf = steps_from path
    hash = steps.empty? ? self : dig(*steps)
    hash[leaf] = nil
  end

  private

  def steps_from path
    path.split(SEPERATOR).map do |step|
      if step.match?(/\D/)
        step.to_s
      else
        step.to_i
      end
    end
  end
end
