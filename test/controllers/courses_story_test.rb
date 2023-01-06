Given /the following courses exist/ do |courses_table|
    courses_table.hashes.each do |course|
      Course.create course
    end
end

Given('I am on the courses page')
    visit "/courses"
end