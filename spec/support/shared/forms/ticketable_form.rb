RSpec.shared_examples 'TicketableForm' do
  let(:params) { { ticket: { name: 'test' } } }

  it 'add error if ticket is invalid' do
    allow_any_instance_of(Api::V1::TicketForm).to receive(:valid?).and_return(false)
    subject.validate(params)

    expect(subject.errors.details.keys).to include(:ticket)
  end

  describe '#validate' do
    subject { described_class.new(ticketable_object) }

    it 'call #populate_collections method for ticket property' do
      expect(subject.ticket).to receive(:populate_collections).with(params[:ticket])

      subject.validate(params)
    end
  end
end
