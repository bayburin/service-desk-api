class UserSerializer < ActiveModel::Serializer
  attributes :tn, :dept, :fio, :room, :tel, :email, :comment, :duty, :status, :datereg, :duty_code, :fio_initials, :category, :id_tn, :login, :dept_kadr, :ms, :tn_ms, :adLogin, :mail
  attributes :surname, :firstname, :middlename, :initials_family, :family_with_initials, :is_chief, :role_id

  belongs_to :role
end
