class Asteroid < ApplicationRecord
    has_many :proximity_events, dependent: :destroy
end
