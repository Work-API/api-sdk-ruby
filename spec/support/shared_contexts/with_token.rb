# frozen_string_literal: true

RSpec.shared_context 'with token' do
  def load_file(filename)
    raw_json = File.read(File.expand_path("tmp/#{filename}", APP_ROOT))
    JSON.parse(raw_json)
  end

  def load_tokens
    load_file('tokens.json')
  end

  def load_user
    user_payload = load_file('user.json')
    LivilApi::JsonapiDeserializer.new(user_payload).deserialize
  end

  let(:account_provder_token) { load_tokens[:apt] }
  let(:token) { load_user.token }
end
