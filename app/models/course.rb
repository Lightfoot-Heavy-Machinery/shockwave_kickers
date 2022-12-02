class Course < ApplicationRecord
    def self.search(search, teacher)
        if search
          search_type = Course.find_by(course_name: search, teacher: teacher)
          if search_type
            self.where(id: search_type)
          elsif (search.length == 0)
            @courses_db_result = Course.where(teacher: teacher)
          else
            @courses_db_result = Course.where(id: 0)
          end
        else
          @courses_db_result = Course.where(teacher: teacher)
        end
    end
end