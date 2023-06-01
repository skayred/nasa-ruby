# frozen_string_literal: true

module Types
    class ProximityPayload < Types::BaseObject
      field :job_id, String, null: true
      field :events, [ProximityEventType, null: false], null: true
    end
  end
  