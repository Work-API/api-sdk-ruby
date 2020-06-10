# frozen_string_literal: true

RSpec.describe(WorkApi::Requests::BaseRequest) do
  context '::[]' do
    let(:http_method) { :post }
    let(:base_path) { 'some/path' }
    let(:accepted_params) { %i[] }
    let(:opts) { {} }

    let(:klass) do
      described_class[http_method, base_path, accepted_params, **opts].tap do |klass|
        Object.const_set('DummyRequest', klass)
      end
    end

    # avoid redefinition warnings in console
    after { Object.send(:remove_const, 'DummyRequest') }

    subject { klass }

    it do
      is_expected
        .to have_attributes(
          http_method: http_method,
          base_path: base_path,
          accepted_params: accepted_params
        )
    end

    context 'when passing a `body` into a :post request' do
      subject { klass.new(body: {}) }
      it 'sohuld not raise an error' do
        expect { subject }.not_to raise_error
      end
    end

    context 'when passing in params when none accepted' do
      subject { klass.new(something: 'wrong') }
      it 'should raise an error' do
        expect { subject }.to raise_error(ArgumentError, /invalid parameters for/)
      end
    end
  end
end
