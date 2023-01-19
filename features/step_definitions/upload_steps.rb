Given('I am on the upload page') do
    visit upload_index_path()
    expect(page).to have_content 'Upload Instructions'
end

When('I upload a zip file') do
    attach_file('file', './app/resources/ProfRitchey_Template.zip')
end

When('I input form information') do
    fill_in('course_temp', with: "CSCE 606")
    fill_in('section_temp', with: "001")
    fill_in('semester_temp', with: "Spring 2020")
end

When('I click save') do
    click_button('Save')
end

Then('I should see the upload was successful') do
    expect(page).to have_content 'Upload successful!'
end