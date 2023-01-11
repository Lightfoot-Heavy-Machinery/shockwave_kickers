class Course < ApplicationRecord
    def self.search_course(search, teacher)
        if search
          search_type = Course.where(course_name: search, teacher: teacher).all
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

    def self.search_semester(search, teacher)
      if search
        search_type = Course.where(semester: search, teacher: teacher).all
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

  def self.search_student(search, teacher)
    if search
      search_type = Course.where(semester: search, teacher: teacher).all
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