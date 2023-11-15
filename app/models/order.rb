class Order < ApplicationRecord
  validates :session_id, presence: true
end
