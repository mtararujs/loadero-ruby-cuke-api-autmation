require 'rest-client'
require 'test-unit'

# Class which defines all testStep attributs which can be used in scope of one test step
class TestStep
  attr_accessor :host
  attr_accessor :path
  attr_accessor :method
  attr_accessor :headers
  attr_accessor :request_payload
  attr_accessor :response
  attr_accessor :auth_host
  attr_accessor :auth_token
  attr_accessor :user_token

  def initialize(host, path, method, request_payload, headers, auth_host, auth_token, user_token)
    @host = host
    @path = path
    @method = method
    @request_payload = request_payload
    @headers = headers
    @auth_host = auth_host
    @auth_token = auth_token
    @user_token = user_token
  end

  def executeRequest()
    if @method.eql? "POST"
      @response = post(@host + @path,
                       headers: @headers,
                       cookies: {},
                       payload: @request_payload.to_json)
    elsif @method.eql? "POST:RAW"
      @response = post(@host + @path,
                        headers: @headers,
                        cookies: {},
                        payload: @request_payload)
    elsif @method.eql? "DELETE"
      @response = delete(@host + @path,
                        headers: @headers,
                        cookies: {})
    elsif @method.eql? "GET"
      @response = get(@host + @path,
                        headers: @headers,
                        cookies: {})
    end
  end

  def setHost(host)
    @host = host
  end

  def setPath(path)
    @path = path
  end

  def setMethod(method)
    @method = method
  end

  def setPayload(payload)
    @request_payload = payload
  end

  def removePayload()
    @request_payload = nil
  end

  def setResponse(response)
    @response = response
  end

  def addHeader(header)
  @headers = headers.merge(header)
  end

  def removeHeader(headerName)
    @headers.delete(headerName)
  end

end
