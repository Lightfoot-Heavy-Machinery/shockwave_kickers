require 'rails_helper'

RSpec.describe "quizzes/index", type: :view do
  before(:each) do
    assign(:quizzes, [
      Quiz.create!(
        course_id: 2,
        correct: 3,
        incorrect: 4,
        score: 5.5,
        longest_streak: 6
      ),
      Quiz.create!(
        course_id: 2,
        correct: 3,
        incorrect: 4,
        score: 5.5,
        longest_streak: 6
      )
    ])
  end

  it "renders a list of quizzes" do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new(2.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(3.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(4.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(5.5.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(6.to_s), count: 2
  end
end
