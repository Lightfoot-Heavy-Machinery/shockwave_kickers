require 'rails_helper'

RSpec.describe "quizzes/new", type: :view do
  before(:each) do
    assign(:quiz, Quiz.new(
      course_id: 1,
      correct: 1,
      incorrect: 1,
      score: 1.5,
      longest_streak: 1
    ))
  end

  it "renders new quiz form" do
    render

    assert_select "form[action=?][method=?]", quizzes_path, "post" do

      assert_select "input[name=?]", "quiz[course_id]"

      assert_select "input[name=?]", "quiz[correct]"

      assert_select "input[name=?]", "quiz[incorrect]"

      assert_select "input[name=?]", "quiz[score]"

      assert_select "input[name=?]", "quiz[longest_streak]"
    end
  end
end
