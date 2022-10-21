require "test_helper"

class StudentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:userOne)
    @student = students(:studentOne)
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
    assert_difference("Student.count") do
      post students_url, params: { student: { firstname: @student.firstname, lastname: @student.lastname, uin: @student.uin, email: @student.email, classification: @student.classification, major: @student.major, notes: @student.notes, course_id: @student.course_id} }
    end

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
end
