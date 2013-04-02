require 'spec_helper'

describe "the default page" do
  context "when authenticated" do
    before do
      Sinatra::Application.any_instance.stub(:current_user){'toto'}
    end
    it "displays the login of the connected user" do
      get '/'
      last_response.body.should match /toto/
    end
    it "displays a link to /resource/foo" do
      get '/'
      last_response.body.should match /< a href="\/resource\/foo"/
    end
  end
  context "when not authenticated" do
    before  do
      Sinatra::Application.any_instance.stub(:current_user){nil}
    end
    it "displays a link to sign in" do
      get '/'
      last_response.body.should match /<a.*href='login'/
    end
  end
end
