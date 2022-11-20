class StudentCourseEntry
    attr_accessor :student_record, :course_record

    def initializeUsingStudentModel student, course
        @records = student
        @course_record = course
    end
end