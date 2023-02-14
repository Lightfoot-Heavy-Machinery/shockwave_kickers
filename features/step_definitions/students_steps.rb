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

  When('I fill in student {search} with {input}') do |search, input|
    fill_in "student[#{search}]", with: input
  end
  