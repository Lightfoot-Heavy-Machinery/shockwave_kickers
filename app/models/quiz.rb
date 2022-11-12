class Quiz < ApplicationRecord
    validate :has_students
    private
    def has_students
        if Student.where(teacher: :teacher, course_id: :course_id).count <= 0
            self.errors.add(:base, "Cannot create a quiz from a selection with 0 students!")
        end
    end
end