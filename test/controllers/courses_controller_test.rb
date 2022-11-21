require "test_helper"

class CoursesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:userOne)
    @course = courses(:courseOne)
    @course2 = courses(:courseOneSemesterTwo)
    @student = students(:studentOneCourseOne)

  end

  test "should get index" do
    get courses_url
    assert_response :success
  end

  test "should get new" do
    get new_course_url
    assert_response :success
  end

  test "should create course" do
    assert_difference("Course.count") do
      post courses_url, params: { course: { course_name: @course.course_name, section: @course.section, semester: @course.semester} }
    end
    assert_redirected_to course_url(Course.last)
  end

  test "should show course" do
    get course_url(@course)
    assert_response :success
  end

  test "course page: should say course not found if course doesn't belong to user" do
    sign_out users(:userOne)
    sign_in users(:userTwo)
    get course_url(@course)
    assert_redirected_to courses_url
  end

  test "edit page: should say course not found if course doesn't belong to user" do
    sign_out users(:userOne)
    sign_in users(:userTwo)
    get edit_course_url(@course)
    assert_redirected_to courses_url
  end

  test "should get edit" do
    get edit_course_url(@course)
    assert_response :success
  end

  test "should update course" do
    patch course_url(@course), params: { course: { course_name: @course.course_name, section: @course.section, semester: @course.semester } }
    assert_redirected_to course_url(@course)
  end

  test "should destroy course" do
    assert_difference("Course.count", -1) do
      delete course_url(@course)
    end

    assert_redirected_to courses_url
  end

  test "should get course index sign in page" do
    sign_out users(:userOne)
    get courses_url
    assert_redirected_to '/users/sign_in'
  end

  test "should get new sign in page" do
    sign_out users(:userOne)
    get new_course_url
    assert_redirected_to '/users/sign_in'
  end

  test "should successfully render partial with no filters" do
      get course_url(@course), params: {selected_semester: '', selected_section: '', selected_tag:''}
      assert_response :success
  end

  test "should successfully render partial with nil filters" do
      get course_url(@course), params: {selected_semester: nil, selected_section: nil, selected_tag:nil}
      assert_response :success
  end

  test "should successfully render partial with only semester filter" do
      get course_url(@course), params: {selected_semester: @course.semester, selected_section: '', selected_tag:''}
      assert_response :success
  end

  test "should successfully render partial with only section filter" do
      get course_url(@course), params: {selected_semester: '', selected_section: @course.section.to_s, selected_tag:''}
      assert_response :success
  end

  test "should successfully render partial with only tags filter" do
      get course_url(@course), params: {selected_semester: '', selected_section: '', selected_tag: @student.tags}
      assert_response :success
  end

  test "should successfully render partial with all filters set" do
      get course_url(@course), params: {selected_semester: @course.semester, selected_section: @course.section, selected_tag: @student.tags}
      assert_response :success
  end

  test "should view course history" do
    get courses_history_path(@course)
    assert_response :success
  end

  test "should say course history not found" do
    @courseFake = courses(:courseOne)
    @courseFake.id = 10
    get courses_history_path(@courseFake)
    assert_redirected_to courses_url
  end
end
