class CalculateServicePopularityWorker
  include Sidekiq::Worker

  sidekiq_options retry: true, backtrace: true

  def perform(service_id)
    service = Service.find(service_id)
    service.with_lock do
      popularity = service.calculate_popularity
      service.update(popularity: popularity)
    end
  end
end
