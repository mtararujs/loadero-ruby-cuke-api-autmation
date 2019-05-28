require 'logger'

# Cucumber setup hood definition and initializaton
Before do |scenario|
  initialise_logger
  initialise_buffer

  environment = Environment.new
  parameters = environment.get_parameters
  @logger.info("Used environment parameters: #{parameters}")
  initialise_test_step(parameters)
end


After do |scenario|

end

def initialise_test_step(parameters)
  @test_step = TestStep.new(
      parameters[:controller_host],
      '',
      '',
      {},
      {'Content-Type' => 'application/json'},
      parameters[:auth_host],
      parameters[:auth_token],
      parameters[:user_token])
end

def initialise_logger
  @logger = Logger.new(STDOUT)
end

def initialise_buffer
  @buffer = Buffer.new
  # @buffer.add_map({:uid.to_s => '123'})
end
