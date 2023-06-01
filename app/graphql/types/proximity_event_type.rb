# frozen_string_literal: true

module Types
  class ProximityEventType < Types::BaseObject
    field :id, ID, null: false
    field :asteroid, Types::AsteroidType
    field :miss_distance, String, null: false
    field :happened_at, GraphQL::Types::ISO8601Date, null: false
  end
end
