require "test_helper"

class StudentCoursesControllerTest < ActionDispatch::IntegrationTest
    setup do
        sign_in users(:userOne)
        @student = students(:studentOne)
        @studentOneCourseOne = student_courses(:studentOneCourseOne)
    end

    test "should destroy student of a course" do
        before_student_count = Student.count
        before_student_course_count = StudentCourse.count
        delete student_course_path(@studentOneCourseOne.id)
        after_student_count = Student.count
        after_student_course_count = StudentCourse.count
        assert_equal before_student_count, after_student_count
        assert_equal before_student_course_count - 1, after_student_course_count
        assert_redirected_to student_url(@student)
    end

    test "should update grade of student in a course" do
        patch student_course_path(@studentOneCourseOne), params: { student_course: {final_grade: "A"} }
        assert_redirected_to student_url(@student)
    end
end