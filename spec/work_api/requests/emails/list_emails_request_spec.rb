# frozen_string_literal: true

require 'work_api/model/email'
require 'work_api/requests/emails/list_emails_request'

RSpec.describe(WorkApi::Requests::Emails::ListEmailsRequest) do
  include_context 'with live client'

  let(:request) { described_class.new }

  context '#path' do
    subject { request.path }
    it { is_expected.to eq('email/emails') }
  end

  context 'client#call' do
    let(:call) { make_request(request) }
    subject { call }

    context 'with no emails found' do
      let(:cassette_name) { 'email_list_success_empty' }

      it { is_expected.to be_a(WorkApi::Client::Response) }
      it { is_expected.to have_attributes(body: []) }
    end

    context 'with emails found' do
      let(:cassette_name) { 'email_list_success_found' }

      it { is_expected.to be_a(WorkApi::Client::Response) }

      context '#body' do
        subject { call.body }
        it { is_expected.to be_a(Array) }
        it { is_expected.to have_attributes(count: 20) }
      end
    end

    context 'with limit' do
      let(:cassette_name) { 'email_list_success_limit' }

      let(:limit) { 5 }
      let(:request) { described_class.new(limit: limit) }

      it { is_expected.to be_a(WorkApi::Client::Response) }

      context '#body' do
        subject { call.body }
        it { is_expected.to be_a(Array) }
        it { is_expected.to have_attributes(count: limit) }
      end
    end

    context 'with ids' do
      let(:cassette_name) { 'email_list_success_email_ids' }

      let(:email_ids) do
        %w[
          NWU2MGY3NmI5OWNlNjYwMDA5MzY4OTdiOjE3MDYzOWUwNTg2ZmNlYjg6
          NWU2MGY3NmI5OWNlNjYwMDA5MzY4OTdiOjE2YjhmZGRhNzZmNTU5ZmU6
        ]
      end

      let(:request) { described_class.new(ids: email_ids) }

      it { is_expected.to be_a(WorkApi::Client::Response) }

      context '#body' do
        subject { call.body }
        it { is_expected.to be_a(Array) }

        context 'IDs' do
          subject { call.body.map(&:id) }
          it { is_expected.to eq(email_ids) }
        end
      end
    end

    context 'with mailbox_ids' do
      let(:cassette_name) { 'email_list_success_mailbox_ids' }

      let(:mailbox_ids) do
        %w[NWU2MGY3NmI5OWNlNjYwMDA5MzY4OTdiOlNFTlQ6]
      end

      let(:request) { described_class.new(mailbox_ids: mailbox_ids) }

      it { is_expected.to be_a(WorkApi::Client::Response) }

      context '#body' do
        subject { call.body }
        it { is_expected.to be_a(Array) }
        it { is_expected.to have_attributes(count: 20) }

        context 'first email' do
          subject { call.body.first }
          it { is_expected.to have_attributes(subject: 'Test: sending to self subj2') }
        end
      end
    end

    context 'with date range' do
      let(:cassette_name) { 'email_list_success_ranged' }

      let(:date_from) { '2019-11-18T00:00' }
      let(:date_until) { '2019-12-20T00:00' }
      let(:request) { described_class.new(date_from: date_from, date_until: date_until) }

      it { is_expected.to be_a(WorkApi::Client::Response) }

      context '#body' do
        subject { call.body }
        it { is_expected.to be_a(Array) }
        it { is_expected.to have_attributes(count: 3) }
      end
    end

    context 'with search_text string' do
      let(:cassette_name) { 'email_list_success_search_text' }

      let(:search_text) { 'terms' }
      let(:request) { described_class.new(search_text: search_text) }

      it { is_expected.to be_a(WorkApi::Client::Response) }

      context '#body' do
        subject { call.body }
        it { is_expected.to be_a(Array) }
        it { is_expected.to have_attributes(count: 2) }
      end
    end
  end
end
