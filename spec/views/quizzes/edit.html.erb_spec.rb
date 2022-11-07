require 'rails_helper'

RSpec.describe "quizzes/edit", type: :view do
  let(:quiz) {
    Quiz.create!(
      course_id: 1,
      correct: 1,
      incorrect: 1,
      score: 1.5,
      longest_streak: 1
    )
  }

  before(:each) do
    assign(:quiz, quiz)
  end

  it "renders the edit quiz form" do
    render

    assert_select "form[action=?][method=?]", quiz_path(quiz), "post" do

      assert_select "input[name=?]", "quiz[course_id]"

      assert_select "input[name=?]", "quiz[correct]"

      assert_select "input[name=?]", "quiz[incorrect]"

      assert_select "input[name=?]", "quiz[score]"

      assert_select "input[name=?]", "quiz[longest_streak]"
    end
  end
end
