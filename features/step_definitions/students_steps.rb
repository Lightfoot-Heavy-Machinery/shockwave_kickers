  When('I go to the students page') do
    visit students_path()
  end

  Then('I select {string} under semester') do |string|
    find("#selected_semester").select(string)
  end

  Then('I submit the form') do
    find("[value='Filter Students List']").click
  end

  When('I click show this student') do
    first("button", text: "Show this student").click
  end

  When('I fill in student {string} with {string}') do |string, string2|
    fill_in "student[#{string}]", with: string2
  end
  