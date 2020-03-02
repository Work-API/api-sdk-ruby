# frozen_string_literal: true

def environment_guid
  @environment_guid ||= ENV['ENVIRONMENT_GUID'] || '31d6543f-5e26-4203-a258-011b5032a1c6'
end

def generate_apt(arbitrary_id: nil)
  priv_key_path = File.expand_path("keys/livil-#{environment_guid}.pem", APP_ROOT)
  pub_key_path = File.expand_path("keys/livil-#{environment_guid}.pub", APP_ROOT)

  apt = LivilApi::AptGenerator.generate_apt(
    environment_guid: environment_guid,
    path_to_private_key: priv_key_path,
    arbitrary_id: arbitrary_id,
    expiry: 86_400
  )

  # validate the token
  LivilApi::AptGenerator.decode_apt(apt, path_to_public_key: pub_key_path)

  apt
end

def load_user
  @load_user ||= begin
                   user_json = File.read(File.expand_path('tmp/user.json', APP_ROOT))
                   LivilApi::JsonapiDeserializer.new(user_json).deserialize
                 end
end

def write_to_file(path, content)
  File.open(File.expand_path("tmp/#{path}.json", APP_ROOT), 'wx') do |f|
    f.write(content)
  end
end

def read_from_file(path)
  File.read(File.expand_path("tmp/#{path}.json", APP_ROOT))
end

def perform_request(method, path, payload_attrs: nil, query: nil, token: nil)
  path = "#{LivilApi::Client.url}/#{path}"
  params = if payload_attrs.present?
             { data: { attributes: payload_attrs } }.to_json
           else
             query
           end

  response = Faraday.send(method, path, params, build_request_headers(token))

  return response.body if response.status < 299

  raise "Error processing request: #{response.body}"
end

def build_request_headers(token = nil)
  {
    'Accept' => 'application/vnd.api+json',
    'Content-Type' => 'application/vnd.api+json',
    'Authorization' => "Bearer #{token || load_user.token}"
  }
end
