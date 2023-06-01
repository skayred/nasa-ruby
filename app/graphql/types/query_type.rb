module Types
  class QueryType < Types::BaseObject
    FORMAT = "%Y-%m-%d"

    # Add `node(id: ID!) and `nodes(ids: [ID!]!)`
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    field :is_job_complete, Boolean, null: false do
      argument :job_id, String, required: true
    end
    def is_job_complete(job_id:)
      status = Sidekiq::Status::status job_id

      status == :complete
    end

    field :closest_asteroids, ProximityPayload, null: false do
      argument :from, String, required: true
      argument :to, String, required: true
      argument :amount, Int, required: true
    end
    def closest_asteroids(from:, to:, amount:)
      from_date = DateTime.strptime(from, FORMAT)
      to_date = DateTime.strptime(to, FORMAT)

      events = ProximityEvent.where(happened_at: from_date..to_date).limit(amount)

      job_id = nil
      unless events.count > 0
        job_id = NasaJob.perform_async(123, from, to, ENV["NASA_API_KEY"])
      end

      {
        job_id: job_id,
        events: events
      }
    end
  end
end
