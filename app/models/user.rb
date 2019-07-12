class User < ApplicationRecord
  devise

  attr_accessor :dept, :fio, :room, :tel, :email, :comment, :duty, :status, :datereg, :duty_code, :fio_initials, :category, :login, :dept_kadr, :ms, :tn_ms, :adLogin, :mail
  attr_accessor :surname, :firstname, :middlename, :initials_family, :family_with_initials, :is_chief

  has_many :visits, class_name: 'Ahoy::Visit', dependent: :nullify

  belongs_to :role

  validates :tn, :id_tn, uniqueness: true, allow_nil: true

  def self.authenticate(user_attrs)
    strategy = UserStrategy.new(
      ServiceResponsibleUserStrategy.new(
        GuestUserStrategy.new
      )
    )

    finded_user = strategy.search_user(user_attrs)
    finded_user.merge_attrs(user_attrs)
    finded_user
  end

  def merge_attrs(user_attrs)
    attributes = user_attrs.select { |key, _val| respond_to?(key.to_sym) }
    assign_attributes(attributes)
  end

  def new_notifications
    EventLog.where(tn: tn).left_outer_joins(:readers).where(event_log_readers: { tn: nil })
  end
end
