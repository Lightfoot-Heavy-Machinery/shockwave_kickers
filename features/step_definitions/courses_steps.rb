Given(/the following courses exist/) do |courses_table|
    courses_table.hashes.each do |course|
        Course.create course
    end
end

Given(/the following students exist/) do |students_table|
    students_table.hashes.each do |student|
        Student.create student
    end
end

Given(/students are enrolled in their respective courses/) do 
    StudentCourse.new(course_id: Course.find_by("course_name: CSCE 121", "semster: Fall 2022", "section: 501"), student_id: Student.find_by("uin: 734826482").student_id, final_grade: "100")
    StudentCourse.new(course_id: Course.find_by("course_name: CSCE 121", "semster: Fall 2022", "section: 501"), student_id: Student.find_by("uin: 926409274").student_id, final_grade: "")
    StudentCourse.new(course_id: Course.find_by("course_name: CSCE 121", "semster: Spring 2023", "section: 501"), student_id: Student.find_by("uin: 274027450").student_id, final_grade: "")
    StudentCourse.new(course_id: Course.find_by("course_name: CSCE 121", "semster: Spring 2023", "section: 501"), student_id: Student.find_by("uin: 720401677").student_id, final_grade: "")
    StudentCourse.new(course_id: Course.find_by("course_name: CSCE 221", "semster: Spring 2023", "section: 501"), student_id: Student.find_by("uin: 734826482").student_id, final_grade: "")
    StudentCourse.new(course_id: Course.find_by("course_name: CSCE 221", "semster: Spring 2023", "section: 501"), student_id: Student.find_by("uin: 983650274").student_id, final_grade: "")
end

Given(/I am on the courses page/) do
    visit "/courses"
end