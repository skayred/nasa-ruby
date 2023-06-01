# frozen_string_literal: true

module Types
  class AsteroidType < Types::BaseObject
    field :id, ID, null: false
    field :nasa_id, String, null: false
    field :name, String, null: false
  end
end
