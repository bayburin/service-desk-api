class Ticket < ApplicationRecord
  include Associatable
  include Belongable

  has_many :answers, dependent: :destroy
  has_many :ticket_tags, dependent: :destroy
  has_many :tags, through: :ticket_tags
  has_many :responsible_users, as: :responseable, dependent: :destroy
  has_one :correction, class_name: 'Ticket', foreign_key: :original_id, dependent: :nullify

  belongs_to :service
  belongs_to :original, class_name: 'Ticket', optional: true

  validates :name, :ticket_type, presence: true
  validates :answers, presence: true, if: -> { published_state? }
  validates :is_hidden, :to_approve, inclusion: { in: [true, false] }

  enum ticket_type: { question: 1, case: 2, common_case: 3 }, _suffix: :ticket
  enum state: { draft: 1, published: 2 }, _suffix: true

  accepts_nested_attributes_for :answers, reject_if: proc { |attr| attr['answer'].blank? }, allow_destroy: true
  accepts_nested_attributes_for :tags, reject_if: proc { |attr| attr['name'].blank? }

  # Смотри: https://github.com/rails/rails/issues/7256
  def tags_attributes=(attributes)
    # id присланных тегов
    self.tag_ids = attributes.map { |tag| tag[:id] }.compact

    if attributes.any? { |tag| !tag[:id] }
      # Поиск тегов, у которых отсутствует id
      attributes.each do |tag|
        next if tag[:id]

        tag_o = Tag.find_by(name: tag[:name])
        next unless tag_o

        tag[:id] = tag_o.id
        self.tag_ids = (tag_ids || []) + [tag_o.id]
      end
    end

    super(attributes)
  end

  def calculate_popularity
    self.popularity += 1
  end
end
