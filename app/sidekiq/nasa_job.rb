require 'net/http'

class NasaJob
  include Sidekiq::Job
  include Sidekiq::Status::Worker 

  FORMAT = "%Y-%m-%d"

  def retrieve_nasa_data(from, api_key)
    to = from + 1.day

    url = "https://api.nasa.gov/neo/rest/v1/feed?start_date=#{from.strftime FORMAT}&end_date=#{to.strftime FORMAT}&api_key=#{api_key}"

    puts url

    response = Net::HTTP.get_response(URI.parse(url))
    parsed = JSON.parse(response.body)

    parsed["near_earth_objects"].each do |key, asteroids|
      asteroids.each do |asteroid|
        Asteroid.upsert({ nasa_id: asteroid["id"], name: asteroid["name"] })
        asteroid_model = Asteroid.where(nasa_id: asteroid["id"]).first

        asteroid["close_approach_data"].each do |event|
          ProximityEvent.insert({
            asteroid_id: asteroid_model.id,
            miss_distance: event["miss_distance"]["kilometers"],
            happened_at: Time.at(event["epoch_date_close_approach"] / 1000).to_datetime
          })
        end
      end
    end
  end

  def perform(job_id, from_str, to_str, api_key)
    start_of_today = DateTime.now.beginning_of_day
    from = DateTime.strptime(from_str, FORMAT)
    to = DateTime.strptime(to_str, FORMAT)  
  
    if from > DateTime.now
      from = start_of_today
    end
  
    if to > DateTime.now
      to = start_of_today
    end
  
    from.upto(to) do |date|
      events = ProximityEvent.where(["happened_at::date = ?::date", DateTime.new(date.year, date.month, date.day, 0, 0, 0, 0)]) # casting to ignore hours, minutes and seconds

      if events.count == 0 # day was not synced
        retrieve_nasa_data date, api_key
      end
    end
  end
end
