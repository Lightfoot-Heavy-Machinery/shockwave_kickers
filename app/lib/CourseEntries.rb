class CourseEntries
    attr_accessor :records, :semesters, :sections, :course_name, :teacher

    def initializeUsingCourseModel course
        @records = Set[course]
        @semesters = Set[course.semester]
        @sections = Set[course.section]
        @course_name = course.course_name
        @teacher = course.teacher
    end
end