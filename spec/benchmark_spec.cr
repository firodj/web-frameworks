require "json"
require "./spec_helper"

describe "framework" do
  describe "get on /" do
    it "should return successfully with empty body" {
      r = HTTP::Client.get "http://#{remote_address}/"
      r.status.success?.should be_true
      r.body.should eq ""
    }
  end

  describe "get on /user/0" do
    it "should return successfully with <0>" {
      r = HTTP::Client.get "http://#{remote_address}/user/0"
      r.status.success?.should be_true
      r.body.should eq "0"
    }
  end

  describe "post on /user" do
    it "should return successfully with empty body" {
      r = HTTP::Client.post "http://#{remote_address}/user"
      r.status.success?.should be_true
      r.body.should eq ""
    }
  end
end
