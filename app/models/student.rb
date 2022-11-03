class Student < ApplicationRecord
    has_one_attached :image do |attachable|
        attachable.variant :thumb, resize_to_fill: [500, 500]
    end
end
