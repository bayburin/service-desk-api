class CalculatePopularityWorker
  include Sidekiq::Worker

  sidekiq_options retry: false, backtrace: true

  def perform
    calculate_service_popularity
    calculate_category_popularity
  end

  protected

  def calculate_service_popularity
    Service.pluck(:id).each do |service_id|
      CalculateServicePopularityWorker.perform_async(service_id)
    end
  end

  def calculate_category_popularity
    Category.pluck(:id).each do |category_id|
      CalculateCategoryPopularityWorker.perform_async(category_id)
    end
  end
end
