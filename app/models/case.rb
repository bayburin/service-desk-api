# Legacy database
class Case < ActiveResource::Base
  self.site = 'https://astraea-ui.iss-reshetnev.ru/api/'
  self.primary_key = :case_id

  has_many :accs
  belongs_to :service

  schema do
    attribute 'case_id', :integer
    attribute 'service_id', :integer
    attribute 'ticket_id', :integer
    # attribute 'severity'
    # attribute 'type'
    # attribute 'source'
    # attribute 'destination'
    attribute 'user_tn', :integer
    attribute 'id_tn', :integer
    # attribute 'rating'
    attribute 'user_info', :string
    attribute 'host_id', :string
    attribute 'item_id', :integer
    # attribute 'host_info'
    attribute 'desc', :text
    # attribute 'extlink'
    # attribute 'starttime'
    # attribute 'endtime'
    # attribute 'tags'
    attribute 'phone', :string
    attribute 'email', :string
    attribute 'mobile', :string
    # attribute 'create_user_id'
    # attribute 'last_user_id'
    # attribute 'last_date'
  end

  alias_attribute :invent_num, :host_id
end
