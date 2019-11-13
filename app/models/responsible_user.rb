class ResponsibleUser < ApplicationRecord
  belongs_to :responseable, polymorphic: true

  validates :tn, presence: true

  attr_reader :details

  def details=(params)
    @details = Api::V1::ResponsibleUserDetails.new(params)
  end
end
