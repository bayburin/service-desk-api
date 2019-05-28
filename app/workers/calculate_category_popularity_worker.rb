class CalculateCategoryPopularityWorker
  include Sidekiq::Worker
  sidekiq_options retry: false, backtrace: true

  def perform(category_id)
    category = Category.find(category_id)
    category.with_lock do
      popularity = category.calculate_popularity
      category.update(popularity: popularity)
    end
  end
end
