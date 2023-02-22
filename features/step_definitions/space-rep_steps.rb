Then('I should not see {string}') do |string|
    expect(page).not_to have_content(string) 
end

Then('I should see {string}') do |string|
    expect(page).to have_content(string) 
end