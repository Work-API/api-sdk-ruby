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
