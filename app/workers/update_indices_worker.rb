class UpdateIndicesWorker
  include Sidekiq::Worker

  def perform
    system('rails ts:merge')
  end
end
