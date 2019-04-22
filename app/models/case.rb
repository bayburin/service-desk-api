# Legacy database
class Case
  include ActiveModel::Model
  include ActiveModel::Serializers::JSON

  def self.attributes
    %i[case_id service_id ticket_id user_tn id_tn user_info host_id item_id desc phone email mobile status_id status starttime endtime time sla accs]
  end

  attr_accessor *attributes

  def initialize(attributes = [])
    attributes.each do |attr, _value|
      define_singleton_method("#{attr}=") { |val| attributes[attr] = val }
      define_singleton_method(attr) { attributes[attr] }
    end
  end

  alias_attribute :invent_num, :host_id

  def runtime
    Api::V1::Runtime.new(starttime, endtime, time)
  end

  def runtime=(runtime)
    self.starttime = runtim.starttime
    self.endtime = runtime.endtime
    self.time = runtime.time
  end

  def service
    Service.find_by(id: service_id)
  end

  def ticket
    Ticket.find_by(id: ticket_id)
  end

  def attributes
    self.class.attributes.inject({}) { |hash, attr| hash.merge(Hash[attr, send(attr)]) }
  end
end
