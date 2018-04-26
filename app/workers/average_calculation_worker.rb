class AverageCalculationWorker
  include Sidekiq::Worker
  include WorkerModule
  sidekiq_options :unique => :until_and_while_executing

  def perform(snapshot)
    WorkerModule.calculate_averages(snapshot)
  end
end
