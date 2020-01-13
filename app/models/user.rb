class User < ApplicationRecord
  include Api::V1::UserDetailable

  devise

  attr_accessor :dept, :fio, :room, :tel, :email, :comment, :duty, :status, :datereg, :duty_code, :fio_initials, :category, :login, :dept_kadr, :ms, :tn_ms, :adLogin, :mail
  attr_accessor :surname, :firstname, :middlename, :initials_family, :family_with_initials, :is_chief

  has_many :visits, class_name: 'Ahoy::Visit', dependent: :nullify
  has_many :responsible_users, foreign_key: :tn, primary_key: :tn
  has_many :services, through: :responsible_users, source: :responseable, source_type: 'Service'
  has_many :tickets, through: :responsible_users, source: :responseable, source_type: 'Ticket'

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

  def self.load_details(tns)
    return [] if !tns.is_a?(Array) || tns.empty?

    data = Api::V1::Employees::Employee.new(:exact).load_users(tns: tns)
    data ? data['data'] : []
  end

  def merge_attrs(user_attrs)
    attributes = user_attrs.select { |key, _val| respond_to?(key.to_sym) }
    assign_attributes(attributes)
  end

  def role?(role_name)
    role.name.to_sym == role_name.to_sym
  end

  def one_of_roles?(*roles)
    roles.include?(role.name.to_sym)
  end
end
