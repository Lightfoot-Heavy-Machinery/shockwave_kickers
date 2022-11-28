class Course < ApplicationRecord
    def self.search(search, teacher)
        if search
          search_type = Course.find_by(course_name: search)
          if search_type
            self.where(id: search_type)
          else
            @courses = Course.all
          end
        else
          @courses = Course.all
        end
      end    
end
