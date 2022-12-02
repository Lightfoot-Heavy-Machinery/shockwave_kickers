require "test_helper"

class StudentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:userOne)
    @student = students(:studentOne)
    @studentOneCourseOne = student_courses(:studentOneCourseOne)
    @studentOneCourseTwo = student_courses(:studentOneCourseTwo)
    @course = courses(:courseOne)
  end

  test "should get index" do
    get students_url
    assert_response :success
  end

  test "should get new" do
    get new_student_url
    assert_response :success
  end

  test "should create student" do
    before_student_count = Student.count
    post students_url, params: { student: { firstname: @student.firstname, lastname: @student.lastname, uin: @student.uin, email: @student.email, classification: @student.classification, major: @student.major, notes: @student.notes, course_id: @studentOneCourseOne.course_id} }
    after_student_count = Student.count
    after_student_course_count = StudentCourse.count
    assert_equal before_student_count + 1, after_student_count

    assert_redirected_to student_url(Student.last)
  end

  test "should show student" do
    get student_url(@student)
    assert_response :success
  end

  test "should get edit" do
    get edit_student_url(@student)
    assert_response :success
  end

  test "student page: should say student not found if student doesn't belong to user" do
    sign_out users(:userOne)
    sign_in users(:userTwo)
    get edit_student_url(@student)
    assert_redirected_to students_url
  end

  test "edit page: should say student not found if student doesn't belong to user" do
    sign_out users(:userOne)
    sign_in users(:userTwo)
    get student_url(@student)
    assert_redirected_to students_url
  end

  test "should update student" do
    patch student_url(@student), params: { student: {firstname: @student.firstname, lastname: @student.lastname, uin: @student.uin, email: @student.email, classification: @student.classification, major: @student.major, notes: @student.notes} }
    assert_redirected_to student_url(@student)
  end

  test "should destroy student" do
    assert_difference("Student.count", -1) do
      delete student_url(@student)
    end

    assert_redirected_to students_url
  end

  test "should get student index sign in page" do
    sign_out users(:userOne)
    get students_url
    assert_redirected_to '/users/sign_in'
  end

  test "should get new sign in page" do
    sign_out users(:userOne)
    get new_student_url
    assert_redirected_to '/users/sign_in'
  end

  test "should successfully render partial with no filters" do
    get students_url, params: {selected_semester: '', selected_course: '', selected_tag:''}
    assert_response :success
  end

  test "should successfully render partial with nil filters" do
      get students_url, params: {selected_semester: nil, selected_course: nil, selected_tag:nil}
      assert_response :success
  end

  test "should successfully render partial with only semester filter" do
      get students_url, params: {selected_semester: @course.semester, selected_course: '', selected_tag:''}
      assert_response :success
  end

  test "should successfully render partial with only course filter" do
      get students_url, params: {selected_semester: '', selected_course: @course.course_name, selected_tag:''}
      assert_response :success
  end

  test "should successfully render partial with only tags filter" do
      get students_url, params: {selected_semester: '', selected_course: '', selected_tag: @student.tags}
      assert_response :success
  end

  test "should successfully render partial with all filters set" do
      get students_url, params: {selected_semester: @course.semester, selected_course: @course.course_name, selected_tag: "tag"}
      assert_response :success
  end

  test "should destroy student from all courses" do
    before_student_count = Student.count
    before_student_course_count = StudentCourse.count
    delete student_url(@student)
    after_student_count = Student.count
    after_student_course_count = StudentCourse.count
    assert_equal before_student_count - 1, after_student_count
    assert_equal before_student_course_count - 2, after_student_course_count
    assert_redirected_to students_url
  end
end
