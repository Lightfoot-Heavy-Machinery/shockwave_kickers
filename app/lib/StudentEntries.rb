class StudentEntries
    attr_accessor :records, :semester_section, :course_semester

    def initializeUsingStudentModel student, course
        @records = [student]
        @semester_section = Set[course.semester + " - " + course.section.to_s]
        @course_semester = Set[course.course_name + " - " + course.semester]
    end
end