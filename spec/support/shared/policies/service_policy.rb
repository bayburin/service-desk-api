shared_examples 'for #service_scope specs with :service_responsible role' do
  let(:extra_service) { create(:service, is_hidden: true) }
  let(:new_service) { create(:service, is_hidden: true) }
  let(:ticket) { create(:ticket, service: new_service) }
  before do
    responsible.services << extra_service
    responsible.tickets << ticket
  end

  it 'load all visible records' do
    expect(policy_scope.length).to eq 4
    expect(policy_scope).to include(*visible_services)
    expect(policy_scope).not_to include(hidden_service)
  end

  it 'load services in which user is responsible' do
    expect(policy_scope).to include(extra_service)
  end

  it 'load services in which there is any ticket in which user is responsible' do
    expect(policy_scope).to include(new_service)
  end
end
