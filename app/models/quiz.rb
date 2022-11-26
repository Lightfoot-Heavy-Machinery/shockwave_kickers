class Quiz < ApplicationRecord
    validate :has_students
    private
    def has_students
        cnt = Student.where(teacher: self.teacher, id: StudentCourse.where(course_id:self.course_id).pluck(:student_id)).count.to_i
        self.errors.clear
        if cnt < 1
            self.errors.add(:base, "Cannot create a quiz from a selection with 0 students!")
        end
    end
end