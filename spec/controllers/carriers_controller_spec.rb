require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CarriersController do

  def mock_carrier(stubs={})
    @mock_carrier ||= mock_model(Carrier, stubs)
  end
  
  describe "responding to GET index" do

    it "should expose all carriers as @carriers" do
      Carrier.should_receive(:find).with(:all).and_return([mock_carrier])
      get :index
      assigns[:carriers].should == [mock_carrier]
    end

    describe "with mime type of xml" do
  
      it "should render all carriers as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        Carrier.should_receive(:find).with(:all).and_return(carriers = mock("Array of Carriers"))
        carriers.should_receive(:to_xml).and_return("generated XML")
        get :index
        response.body.should == "generated XML"
      end
    
    end

  end

  describe "responding to GET show" do

    it "should expose the requested carrier as @carrier" do
      Carrier.should_receive(:find).with("37").and_return(mock_carrier)
      get :show, :id => "37"
      assigns[:carrier].should equal(mock_carrier)
    end
    
    describe "with mime type of xml" do

      it "should render the requested carrier as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        Carrier.should_receive(:find).with("37").and_return(mock_carrier)
        mock_carrier.should_receive(:to_xml).and_return("generated XML")
        get :show, :id => "37"
        response.body.should == "generated XML"
      end

    end
    
  end

  describe "responding to GET new" do
  
    it "should expose a new carrier as @carrier" do
      Carrier.should_receive(:new).and_return(mock_carrier)
      get :new
      assigns[:carrier].should equal(mock_carrier)
    end

  end

  describe "responding to GET edit" do
  
    it "should expose the requested carrier as @carrier" do
      Carrier.should_receive(:find).with("37").and_return(mock_carrier)
      get :edit, :id => "37"
      assigns[:carrier].should equal(mock_carrier)
    end

  end

  describe "responding to POST create" do

    describe "with valid params" do
      
      it "should expose a newly created carrier as @carrier" do
        Carrier.should_receive(:new).with({'these' => 'params'}).and_return(mock_carrier(:save => true))
        post :create, :carrier => {:these => 'params'}
        assigns(:carrier).should equal(mock_carrier)
      end

      it "should redirect to the created carrier" do
        Carrier.stub!(:new).and_return(mock_carrier(:save => true))
        post :create, :carrier => {}
        response.should redirect_to(carrier_url(mock_carrier))
      end
      
    end
    
    describe "with invalid params" do

      it "should expose a newly created but unsaved carrier as @carrier" do
        Carrier.stub!(:new).with({'these' => 'params'}).and_return(mock_carrier(:save => false))
        post :create, :carrier => {:these => 'params'}
        assigns(:carrier).should equal(mock_carrier)
      end

      it "should re-render the 'new' template" do
        Carrier.stub!(:new).and_return(mock_carrier(:save => false))
        post :create, :carrier => {}
        response.should render_template('new')
      end
      
    end
    
  end

  describe "responding to PUT udpate" do

    describe "with valid params" do

      it "should update the requested carrier" do
        Carrier.should_receive(:find).with("37").and_return(mock_carrier)
        mock_carrier.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :carrier => {:these => 'params'}
      end

      it "should expose the requested carrier as @carrier" do
        Carrier.stub!(:find).and_return(mock_carrier(:update_attributes => true))
        put :update, :id => "1"
        assigns(:carrier).should equal(mock_carrier)
      end

      it "should redirect to the carrier" do
        Carrier.stub!(:find).and_return(mock_carrier(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(carrier_url(mock_carrier))
      end

    end
    
    describe "with invalid params" do

      it "should update the requested carrier" do
        Carrier.should_receive(:find).with("37").and_return(mock_carrier)
        mock_carrier.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :carrier => {:these => 'params'}
      end

      it "should expose the carrier as @carrier" do
        Carrier.stub!(:find).and_return(mock_carrier(:update_attributes => false))
        put :update, :id => "1"
        assigns(:carrier).should equal(mock_carrier)
      end

      it "should re-render the 'edit' template" do
        Carrier.stub!(:find).and_return(mock_carrier(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end

    end

  end

  describe "responding to DELETE destroy" do

    it "should destroy the requested carrier" do
      Carrier.should_receive(:find).with("37").and_return(mock_carrier)
      mock_carrier.should_receive(:destroy)
      delete :destroy, :id => "37"
    end
  
    it "should redirect to the carriers list" do
      Carrier.stub!(:find).and_return(mock_carrier(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(carriers_url)
    end

  end

end
