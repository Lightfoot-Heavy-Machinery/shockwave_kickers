require 'rails_helper'

RSpec.describe "quizzes/show", type: :view do
  before(:each) do
    assign(:quiz, Quiz.create!(
      course_id: 2,
      correct: 3,
      incorrect: 4,
      score: 5.5,
      longest_streak: 6
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/4/)
    expect(rendered).to match(/5.5/)
    expect(rendered).to match(/6/)
  end
end
