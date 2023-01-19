require 'rails_helper'

RSpec.describe UploadController, type: :controller do
  before(:all) do
  end

  describe "index" do
    it "calls index" do
      get :index
    end
  end
end



