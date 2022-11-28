class Student < ApplicationRecord
    has_one_attached :image do |attachable|
        attachable.variant :thumb, resize_to_fill: [500, 500]
    end

    def self.search(search, teacher)
        if search
          search_type = Student.find_by(email: search)
          if search_type
            self.where(id: search_type)
          else
            @students = Student.all
          end
        else
          @students = Student.all
        end
      end    
end
