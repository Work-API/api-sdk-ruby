# frozen_string_literal: true

RSpec.shared_context 'with token' do
  let(:token) do
    'eyJhbGciOiJIUzI1NiJ9.eyJleHAiOjE1NzczNTM1MzYsImlhd'\
      'CI6MTU3NDkzNDMzNiwiaXNzIjoiU1BJQ08gQWNjb3VudCIsIn'\
      'VzZXIiOnsiaWQiOiI1ZGRmOTc0MDlmMGEzMTAwMWUwNGJiOTM'\
      'iLCJhcmJpdHJhcnlfaWQiOiJzb21lb25lQGxpdmlsLmNvIn19'\
      '.DXqSfVhlqlM5Pm_86OzobSoq1C1V0GNC18iATow39FU'
  end
end
