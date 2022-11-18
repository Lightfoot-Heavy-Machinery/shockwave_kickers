class StudentEntries
    attr_accessor :records, :semesterSection

    def initializeUsingStudentModel student, course
        @records = [student]
        @semesterSection = Set[course.semester + " - " + course.section.to_s]
        @courseSemester = Set[course.course_name + " - " + course.section.to_s]
    end
end