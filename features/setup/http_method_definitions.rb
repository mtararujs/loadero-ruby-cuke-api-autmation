require 'rest-client'

# Methods for HTTP request methods
def post(url, headers: {}, cookies: {}, payload: {})
  RestClient::Request.execute(
    method: :post,
    url: url,
    headers: headers,
    cookies: cookies,
    payload: payload,
    timeout: 11
  ) do |response|
    response
  end
end

def get(url, headers: {}, cookies: {})
  RestClient::Request.execute(
    method: :get,
    url: url,
    headers: headers,
    cookies: cookies,
    timeout: 11
  ) do |response|
    response
  end
end

def delete(url, headers: {}, cookies: {})
  RestClient::Request.execute(
    method: :delete,
    url: url,
    headers: headers,
    cookies: cookies,
    timeout: 11
  ) do |response|
    response
  end
end
