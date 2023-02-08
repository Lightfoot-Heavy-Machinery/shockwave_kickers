require 'rails_helper'

RSpec.describe "teachers/edit", type: :view do
  let(:teacher) {
    Teacher.create!()
  }

  before(:each) do
    assign(:teacher, teacher)
  end

  it "renders the edit teacher form" do
    render

    assert_select "form[action=?][method=?]", teacher_path(teacher), "post" do
    end
  end
end
