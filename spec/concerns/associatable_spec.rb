require 'rails_helper'

RSpec.describe Associatable, type: :model do
  subject do
    Struct.new('Model') { include Associatable }
    Struct::Model.new
  end

  describe '#without_associations!' do
    it 'sets true value to :without_associations attribute' do
      subject.without_associations!

      expect(subject.without_associations).to be true
    end
  end
end
