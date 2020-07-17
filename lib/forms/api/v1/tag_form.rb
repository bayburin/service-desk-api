module Api
  module V1
    # Объект формы модели Tag
    class TagForm < Reform::Form
      property :id
      property :name
      property :_destroy, virtual: true

      validates :name, presence: true
    end
  end
end
