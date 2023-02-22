class Student < ApplicationRecord
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
      
    #get the number of students due for quizzing
    def self.getDue(teacher)
      students = Student.where(teacher: teacher)
      dueStudents = []
      for student in students do
        if (student.last_practice_at + student.curr_practice_interval.to_i.minutes) < Time.now
          dueStudents = dueStudents + [student]
        end
      end
      return dueStudents
    end

end
