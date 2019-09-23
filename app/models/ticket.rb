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
    tag_ids = attributes.map { |tag| tag[:id] }.compact
    # Массив имен тегов, у которых отсутствует id
    tag_names = attributes.reject { |tag| tag[:id] }.map { |el| el[:name] }
    # id тегов, найденных по имени, но пришедших без id
    existing_tag_ids = Tag.where(name: tag_names).pluck(:id)
    tags << Tag.find(tag_ids + existing_tag_ids)
    attributes.each do |tag|
      next if tag[:id]

      tag[:id] = Tag.find_by(name: tag[:name]).try(:id)
    end

    super(attributes)
  end

  def calculate_popularity
    self.popularity += 1
  end
end
