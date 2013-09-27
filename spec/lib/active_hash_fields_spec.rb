require 'spec_helper'

class Dummy < ActiveRecord::Base
  active_hash_fields :notifications,
    hello:                   false,
    hi:                      false,
    some_boolean_value:      false,
    answers_to_my_questions: true,
    news:                    false
end

describe ActiveHashFields do

  before(:each) do
    @dummy = Dummy.create()
    @dummy.notifications = { "hello" => "hello", "hi" => "hi", "some_boolean_value" => "1" }
  end

  it "gets hash values by calling methods on a field" do
    @dummy.notifications.hello.should == "hello"
    @dummy.notifications.hi.should    == "hi"
  end

  it "converts 0 and 1 strings to boolean values" do
    @dummy.valid?
    @dummy.notifications.some_boolean_value.should be_true
    @dummy.notifications.some_boolean_value = "0"
    @dummy.notifications.some_boolean_value.should be_false
  end

  it "sets default values to the hash as soon as object is initialized" do
    user1 = Dummy.new(notifications: { news: false } )
    user2 = Dummy.new
    user3 = Dummy.create(notifications: { news: "true" })
    user1.notifications.should_not be_nil
    user2.notifications.should_not be_nil
    user3.notifications.news.should be_true
  end
  
  it "removes hash elements that are not listed in default values" do
    @dummy.notifications = { "nonexistent_key" => true }
    @dummy.notifications.nonexistent_key.should be_nil
    @dummy.notifications.nonexistent_key = true
    @dummy.notifications.nonexistent_key.should be_nil
  end

end
