class Post < ApplicationRecord
    has_one :file
    validates :file, presence: true
end
