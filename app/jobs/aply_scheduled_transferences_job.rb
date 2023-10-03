class AplyScheduledTransferencesJob < ApplicationJob
  queue_as :default

  def perform_timed(*args)
    puts 'Rodou o job de 30 min'
  end
end
