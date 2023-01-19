Given(/the following users exist/) do |users_table|
    users_table.hashes.each do |user|
        User.create user
    end
end

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
    StudentCourse.create(course_id: Course.find_by(course_name: 'CSCE 411', semester: 'Fall 2022', section: '501').id, student_id: Student.find_by(uin: '734826482').id, final_grade: '100')
    StudentCourse.create(course_id: Course.find_by(course_name: 'CSCE 411', semester: 'Fall 2022', section: '501').id, student_id: Student.find_by(uin: '926409274').id, final_grade: "")
    StudentCourse.create(course_id: Course.find_by(course_name: 'CSCE 411', semester: 'Spring 2023', section: '501').id, student_id: Student.find_by(uin: '274027450').id, final_grade: "")
    StudentCourse.create(course_id: Course.find_by(course_name: 'CSCE 411', semester: 'Spring 2023', section: '501').id, student_id: Student.find_by(uin: '720401677').id, final_grade: "")
    StudentCourse.create(course_id: Course.find_by(course_name: 'CSCE 412', semester: 'Spring 2023', section: '501').id, student_id: Student.find_by(uin: '734826482').id, final_grade: "")
    StudentCourse.create(course_id: Course.find_by(course_name: 'CSCE 412', semester: 'Spring 2023', section: '501').id, student_id: Student.find_by(uin: '983650274').id, final_grade: "")
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
    hasCourse = false
    all('tr').each do |tr|
        next unless tr.has_content?(course_name)
        next unless tr.has_content?(semester)
        hasCourse = true
    end
    expect(hasCourse).to eq(true)
end

When('I fill in {string} with {string}') do |search, query|
    fill_in(search, with: query)
end

When('I click {string}') do |button|
    click_button(button)
end

Then('I should not see {string} offered in {string}') do |course_name, semester|
    hasCourse = false
    all('tr').each do |tr|
        next unless tr.has_content?(course_name)
        next unless tr.has_content?(semester)
        hasCourse = true
    end
    expect(hasCourse).to eq(false)
end
