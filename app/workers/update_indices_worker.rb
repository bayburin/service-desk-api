class UpdateIndicesWorker
  include Sidekiq::Worker

  def perform
    system('rails ts:index')
  end
end
