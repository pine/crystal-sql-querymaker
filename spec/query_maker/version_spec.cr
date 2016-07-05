require "../spec_helper"

describe "SQL::QueryMaker" do
  describe "VERSION" do
    it "is_a?" do
      SQL::QueryMaker::VERSION.should be_a(String)
    end
  end
end
