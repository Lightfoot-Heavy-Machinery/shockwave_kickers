class Student < ApplicationRecord
  belongs_to :user
    has_one_attached :image do |attachable|
        attachable.variant :thumb, resize_to_fill: [500, 500]
    end

    def self.search(search, teacher)
        if search
          search_type = Student.find_by(email: search, teacher: teacher)
          if search_type
            self.where(id: search_type)
          elsif (search.length == 0)
            #return no results
            @students = Student.where(teacher: teacher)
          else
            @students = Student.where(id: 0)
          end
        else
          @students = Student.where(teacher: teacher)
        end
      end
end
