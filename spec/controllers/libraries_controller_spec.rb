require 'spec_helper'

describe LibrariesController do
  render_views
  describe "GET 'show'" do
    before do
      @library = Library.create(url: "google.com")
    end
    it "returns http success for html" do
      get "show", { id: @library.id}
      response.should be_success
    end
    it "includes the library" do
      get "show", { id: @library.id}
      response.body.should include @library.url.to_s
    end
     it "returns http success for json" do
      get "show", {id: @library.id, format: :json}
      response.status.should == 200
    end
    it "includes library without id for json" do  
      get "show", {id: @library.id, format: :json}
      response.body.should include @library.to_json(except: :id)
      response.body.should_not include @library.to_json(only: :id)
    end
  end

  describe "GET 'index'" do
    before do
      @libraries = []
      for i in 1..5 do
        @libraries << Library.create(url: "google.com#{i}")
      end
    end
    it "returns http success for html " do
      get 'index'
      response.status.should == 200
    end
    it "includes libaries" do
      get 'index'
      response.body.should include(@libraries[0].url)
      response.body.should include(@libraries[3].url)
    end

    it "returns http success for json" do
      get 'index', {format: :json}
      response.status.should == 200
    end
    it "includes libraries without ids for json" do
      get 'index', {format: :json}
      response.body.should include @libraries[3].to_json(except: :id)
      response.body.should include @libraries[1].to_json(except: :id)
      response.body.should_not include @libraries[2].to_json(only: :id)
    end
  end

  describe "GET 'new'" do
    it "returns http success for html" do
      get 'new'
      response.status.should == 200
    end
    it "returns 404 for json" do
      get 'new', {format: :json}
      response.status.should == 404
    end
  end

end
