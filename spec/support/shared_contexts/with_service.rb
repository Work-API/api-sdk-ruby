# frozen_string_literal: true

RSpec.shared_context 'with service' do
  include_context 'with token'

  let(:service_class) { LivilApi::Service }
  let(:service) { service_class.new(token) }
  let(:expected_outcome) { 'success' }
  let(:cassette_name) { "client_#{api_method.to_s.split('_').reverse.join('_')}_#{expected_outcome}" }
  let(:args) { {} }
  let(:call) do
    VCR.use_cassette(cassette_name) do
      if args.present?
        service.send(api_method, **args)
      else
        service.send(api_method)
      end
    end
  end

  subject { call }
end
