require 'spec_helper'

describe AdventuresController do
  render_views
  describe "GET 'index'" do
    it "returns http success for html" do
      get 'index'
      response.should be_success
    end

    before do
      @adventures = []
      for i in 1..5 do
        @adventures << Adventure.create!(:title => "#{i} html Test Adventure", :author => "person #{i}")
      end
    end

    it "displays a list of adventures for html" do 
      get 'index'
      response.body.should include @adventures[1].title
      response.body.should include @adventures[3].author
    end
    it "returns http success for json" do
      get 'index', {format: :json}
      response.should be_success
    end
    it "returns a list of adventures originating from this server and includes their pages but not their ids" do 
      adventures = []
      for i in 1..5 do
        adventures << Adventure.create!(:title => "#{i} Test Adventure", :author => "person #{i}")
        adventures[-1].pages.create!(:name => "start#{i}", :text => "This is a great text adventure which is beginning right now!  I can't wait to [[see the end|end]]")
        adventures[-1].pages.create!(:name => "start#{i}2", :text => "This is a great text adventure which is beginning right now!  I can't wait to [[see the end|end]]")
      end
      adventures[-1].update(library_id: 2)
      get 'index', {format: :json}
      response.body.should include adventures[1].title.to_json
      response.body.should include adventures[3].author.to_json
      response.body.should include adventures[0].pages[0].to_json(except: [:id, :adventure_id])
      response.body.should include adventures[0].pages[1].to_json(except: [:id, :adventure_id])
      response.body.should include adventures[2].pages[0].to_json(except: [:id, :adventure_id])
      response.body.should_not include adventures[-1].title.to_json
      response.body.should_not include adventures[0].id.to_json
    end
  end

  describe "GET 'show'" do
    before do
      i = 1
      @adventure = Adventure.create!(:title => "#{i} show Test Adventure", :author => " show person #{i}")
    end
    it "returns http success for html" do
      get 'show', {id: @adventure.id}
      response.should be_success
    end
    before do
      i = 2
      @adventure = Adventure.create!(:title => "#{i} show Test Adventure", :author => " show person #{i}")
    end
    it "includes the adventure" do
      get 'show', {id: @adventure.id}
      response.body.should include(@adventure.title)
      
    end
  end

#   describe "GET 'edit'" do
#     it "returns http success" do
#       get 'edit'
#       response.should be_success
#     end
#   end

end
