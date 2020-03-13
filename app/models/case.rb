# Legacy database
class Case
  include ActiveModel::Model
  include ActiveModel::Serializers::JSON
  include Virtus::Model

  attribute :case_id, Integer
  attribute :service_id, Integer
  attribute :service, Service
  attribute :ticket_id, Integer
  attribute :ticket, Ticket
  attribute :user_tn, Integer
  attribute :id_tn, Integer
  attribute :user_info, String
  attribute :host_id, String
  attribute :item_id, Integer
  attribute :desc, String
  attribute :phone, String
  attribute :email, String
  attribute :mobile, String
  attribute :status_id, Integer
  attribute :status, String
  attribute :starttime, DateTime
  attribute :endtime, DateTime
  attribute :time, DateTime
  attribute :sla, Integer
  attribute :accs, Array[Integer]
  attribute :runtime, Api::V1::Runtime
  attribute :rating, Integer
  attribute :files, Array[]
  attribute :additional, Hash

  alias_attribute :invent_num, :host_id

  def runtime
    Api::V1::Runtime.new(starttime: starttime, endtime: endtime, time: time)
  end

  def runtime=(runtime)
    self.starttime = runtime.starttime
    self.endtime = runtime.endtime
    self.time = runtime.time

    super(runtime)
  end

  def service
    Service.find_by(id: service_id)
  end

  def ticket
    Ticket.find_by(id: ticket_id)
  end
end
