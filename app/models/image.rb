class Image < ApplicationRecord
  belongs_to :imageable, polymorphic: true
  
  validates :image_url, :square_id, presence: true
end
