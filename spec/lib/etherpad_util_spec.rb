require 'spec_helper'

describe EtherpadUtil do
  include EtherpadUtil

  before do
    @protocol = 'http'
    @host = '0.0.0.0'
    @port = 9001
    @url = "#{@protocol}://#{@host}:#{@port}"
    @path = 'vendor/etherpad-lite'
    @git = "git://github.com/Pita/etherpad-lite.git"
    @ref = "8ec71a3225e0c3d77f04d07e42fb7820d8f1b04f"
    @apikey = "somekey"
  end

  describe "with_etherpad" do
    before do
      self.should_receive(:with_etherpad).and_yield(@protocol, @host, @port, @path, @git, @ref)
    end

    describe "with_etherpad_server" do
      it "should yeild protocol, host, and port" do
        with_etherpad_server do |protocol, host, port|
          protocol.should == @protocol
          host.should == @host
          port.should == @port
        end
      end
    end

    describe "with_etherpad_url" do
      it "should yield url" do
        with_etherpad_url do |url|
          url.should == @url
        end
      end
    end
  end

  describe "with_apikey" do
    before do
      @user = User.create! :name => "Test User", :email => 'test@test.com', :password => 'password', :password_confirmation => 'password'
      @document = Document.create! :name => 'test_document', :owner => @user
      @group = Group.create! :document => @document
      @user.groups << @group
      self.should_receive(:with_apikey).and_yield(@url, @apikey)
    end

    describe "create_author_if_not_exists_for" do
      it "should return author_id" do
        self.create_author_if_not_exists_for(@user).should == ETHERPAD_AUTHOR_ID
      end
    end

    describe "create_group_if_not_exists_for" do
      it "should return etherpad_group_id" do
        self.create_group_if_not_exists_for(@document).should == ETHERPAD_GROUP_ID
      end
    end

    describe "create_group_pad" do
      it "should return success code" do
        self.create_group_pad(@document).should == 0
      end
    end

    describe "create_session" do
      it "should return session_id" do
        self.create_session(@user, @document, 1.days.from_now.to_time.to_i).should == ETHERPAD_SESSION_ID
      end
    end

    describe "get_revisions_count" do
      it "should return revision count when revision count is 1" do
        self.get_revisions_count("#{@etherpad_group_id}?test_pad").should == 1
      end
      it "should return 0 when pad does not exist" do
        JsonUtil.should_receive(:get_json).and_yield({"code" => 1})
        self.get_revisions_count("#{@etherpad_group_id}?test_pad2").should == 0
      end
    end
  end
end