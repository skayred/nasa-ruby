class ConnectionPoolMiddleware
  def call(worker, job, queue)
    begin
      ActiveRecord::Base.clear_active_connections!()
    rescue => e
      puts(e.message)
    end

    begin
      yield
    rescue => e
      puts(e.message)
    end
  end
end

Sidekiq.configure_client do |config|
  if ENV['RAILS_ENV'] == "production"
    config.redis = { url: 'redis://redis:6379/1' }
  end

  Sidekiq::Status.configure_client_middleware config, expiration: 30.minutes.to_i
end

Sidekiq.configure_server do |config|
  if ENV['RAILS_ENV'] == "production"
    config.redis = { url: 'redis://redis:6379/1' }
  end

  Sidekiq::Status.configure_server_middleware config, expiration: 30.minutes.to_i
  Sidekiq::Status.configure_client_middleware config, expiration: 30.minutes.to_i
  config.server_middleware do |chain|
    chain.add(ConnectionPoolMiddleware)
  end
end
