class User < ApplicationRecord
  devise

  attr_accessor :dept, :fio, :room, :tel, :email, :comment, :duty, :status, :datereg, :duty_code, :fio_initials, :category, :login, :dept_kadr, :ms, :tn_ms, :adLogin, :mail
  attr_accessor :surname, :firstname, :middlename, :initials_family, :family_with_initials, :is_chief
end
