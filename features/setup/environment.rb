require 'logger'

# Class which contains all environment related things
class Environment
  def get_parameters
    parameters = {}

    case ENV['PLATFORM']
      when 'STAGE'
        parameters[:controller_host] = "*"
        parameters[:auth_host] = "*"
        parameters[:auth_token] = "*"
        parameters[:user_token] = "*"
      else
        error_message = "Wrong environment name specified. Please check environment name passed!"
        @logger.error(error_message)
        raise error_message
      end
    parameters
  end
end
