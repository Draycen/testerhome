# coding: utf-8
require "spec_helper"

describe LikesHelper do
  describe "likeable_tag" do
    let(:user) { Factory :user }
    let(:topic) { Factory :topic }

    it "should run with nil param" do
      helper.stub(:current_user).and_return(nil)
      helper.likeable_tag(nil).should == ""
    end

    it "should result when logined user liked" do
      helper.stub(:current_user).and_return(user)
      topic.stub(:liked_by_user?).and_return(true)
      helper.likeable_tag(topic).should == %(<a class=\"likeable\" data-count=\"0\" data-id=\"1\" data-state=\"liked\" data-type=\"Topic\" href=\"#\" onclick=\"return App.likeable(this);\" rel=\"twipsy\" title=\"取消赞\"><i class=\"icon small_liked\"></i> <span>赞</span></a>)
      topic.stub(:likes_count).and_return(3)
      helper.likeable_tag(topic).should == %(<a class=\"likeable\" data-count=\"3\" data-id=\"1\" data-state=\"liked\" data-type=\"Topic\" href=\"#\" onclick=\"return App.likeable(this);\" rel=\"twipsy\" title=\"取消赞\"><i class=\"icon small_liked\"></i> <span>3 人赞</span></a>)
    end

    it "should result when unlogin user" do
      allow(helper).to receive(:current_user).and_return(nil)
      expect(helper.likeable_tag(topic)).to eq(%(<a class=\"\" href=\"/account/sign_in\"><i class=\"fa fa-thumbs-up\"></i> <span></span></a>))
    end

    it "should result with no_cache params" do
      str = %(<a class=\"likeable\" data-count=\"0\" data-id=\"1\" data-state=\"\" data-type=\"Topic\" href=\"#\" onclick=\"return App.likeable(this);\" rel=\"twipsy\" title=\"赞\"><i class=\"icon small_like\"></i> <span>赞</span></a>)
      helper.stub(:current_user).and_return(user)
      helper.likeable_tag(topic, :cache => true).should == str
    end
  end
end
