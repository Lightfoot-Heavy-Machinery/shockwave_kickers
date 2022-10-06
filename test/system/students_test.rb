class StudentsTest < ApplicationSystemTestCase
    setup do
      @student = students(:one)
    end
  
    test "visiting the index" do
      visit students_url
      assert_selector "h1", text: "Students"
    end
  
    test "should create student" do
      visit students_url
      click_on "New student"
  
      fill_in "FirstName", with: @student.firstname
      fill_in "LastName", with: @student.lastname
      fill_in "Uin", with: @student.uin
      fill_in "Email", with: @student.email
      fill_in "Classification", with: @student.classification
      fill_in "Major", with: @student.major
      fill_in "Notes", with: @student.notes
      click_on "Create Student"
  
      assert_text "Student was successfully created"
      click_on "Back"
    end
  
    test "should update Student" do
      visit course_url(@student)
      click_on "Edit this student", match: :first
  
      fill_in "FirstName", with: @student.firstname
      fill_in "LastName", with: @student.lastname
      fill_in "Uin", with: @student.uin
      fill_in "Email", with: @student.email
      fill_in "Classification", with: @student.classification
      fill_in "Major", with: @student.major
      fill_in "Notes", with: @student.notes
      click_on "Update Student"
  
      assert_text "Student was successfully updated"
      click_on "Back"
    end
  
    test "should destroy Student" do
      visit course_url(@course)
      click_on "Destroy this student", match: :first
  
      assert_text "Student was successfully destroyed"
    end
  end