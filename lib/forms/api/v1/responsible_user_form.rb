module Api
  module V1
    # Объект формы модели ResponsibleUser
    class ResponsibleUserForm < Reform::Form
      property :id
      property :tn
      property :responseable_id
      property :responseable_type

      validates :tn, presence: true
    end
  end
end
