class MessagesController < ApplicationController
  before_filter :login_required
  
  def new
    if params[:freecycle]
      @freecycle = Freecycle.find(params[:freecycle]) 
    elsif params[:product]
      @product = Product.find(params[:product])
    end
  end
  
  def create
    @message = Message.new(params[:message])
    if @message.valid?
      if params[:freecycle]
        item = Freecycle.find(params[:freecycle])
        recipient = Member.find(item.member) 
      elsif params[:product]
        item = Product.find(params[:product])
        recipient = Seller.find(item.seller)
      end
      path = (item.is_a? Freecycle) ? freecycle_url(item) : detail_product_url(item)
      MemberMailer.deliver_message(
        :member => current_member,
        :recipient => recipient,
        :message => @message,
        :item_url => path
      )
      flash[:notice] = "Your message has been sent."
      redirect_to path
    else
      if params[:freecycle]
        @freecycle = Freecycle.find(params[:freecycle]) 
      elsif params[:product]
        @product = Product.find(params[:product])
      end
      render :action => :new
    end
  end
end
