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
    StudentCourse.new(course_id: Course.find_by(course_name: 'CSCE 411', semester: 'Fall 2022', section: '501').id, student_id: Student.find_by(uin: '734826482').id, final_grade: '100')
    StudentCourse.new(course_id: Course.find_by(course_name: 'CSCE 411', semester: 'Fall 2022', section: '501').id, student_id: Student.find_by(uin: '926409274').id, final_grade: "")
    StudentCourse.new(course_id: Course.find_by(course_name: 'CSCE 411', semester: 'Spring 2023', section: '501').id, student_id: Student.find_by(uin: '274027450').id, final_grade: "")
    StudentCourse.new(course_id: Course.find_by(course_name: 'CSCE 411', semester: 'Spring 2023', section: '501').id, student_id: Student.find_by(uin: '720401677').id, final_grade: "")
    StudentCourse.new(course_id: Course.find_by(course_name: 'CSCE 412', semester: 'Spring 2023', section: '501').id, student_id: Student.find_by(uin: '734826482').id, final_grade: "")
    StudentCourse.new(course_id: Course.find_by(course_name: 'CSCE 412', semester: 'Spring 2023', section: '501').id, student_id: Student.find_by(uin: '983650274').id, final_grade: "")
end

When(/I sign in/) do
    visit new_user_session_path()
    fill_in("Email", with: "team_cluck_admin@gmail.com")
    fill_in("Password", with: "team_cluck_12345!")
    click_button("Log in")
end 

When(/I go to the courses page/) do
    visit courses_path()
end

Then('I should see {string} offered in {string}') do |course_name, semester|
    #course = Course.find_by("course_name: course_name", "semester: semester")
    #hasCourse = false
    #courses = all(:xpath, './/div[@id="coursesDiv"]/tbody')
    #courses = all(:xpath, './/div/tbody')
    #puts page.has_xpath?('.//div/tbody')
    #courses = page.find(:html, "tbody").all
    hasCourse = false
    #expect(all('tr').each).to have_content(course_name)
    #expect(all('tr').each).to have_content(semester)
    all('tr').each do |tr|
        expect(tr).not_to have_content(course_name)
        expect(tr).not_to have_content(semester)
        puts "Not yet found"
    end
    #    #expect(tr).to have_content(semester)
    #end
    expect(hasCourse).to eq(true)
    #for course in courses do
    #    courseData = course.all
    #    if courseData[0] == course_name do
    #        hasCourse = true
    #        break
    #    end
    #end
    #hasCourse = 
    #.any?{course_name == }
    #expect(page).to have_content(course_name)
    #expect(page).to have_content()
end
