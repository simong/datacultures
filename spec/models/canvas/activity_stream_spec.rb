require 'rails_helper'

RSpec.describe Canvas::ActivityStream, :type => :model do

  it "returns non-nil if Canvas is responding" do
    pending "test for non-nil return when Canvas is running"
  end

  it "returns an error code if invalid credentials are presented" do
    pending "returns simply 401 (Fixnum, not string) if credentials are invalid"
  end

  it "returns an array if Canvas is running and credentials are valid" do
    pending "returns an array"
  end

  it "elements of the array are all Hashes if Canvas is running" do
    pending "first element of returned Array is a Hash"
  end



end
