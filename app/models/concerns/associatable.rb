module Associatable
  extend ActiveSupport::Concern

  included do
    attr_accessor :without_associations
  end

  def without_associations!
    self.without_associations = true
  end
end
