class MediaMailsController < ApplicationController
  before_filter :login_required
  # GET /media_mails
  # GET /media_mails.xml
  def index
    @media_mails = MediaMail.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @media_mails }
    end
  end

  # GET /media_mails/1
  # GET /media_mails/1.xml
  def show
    @media_mail = MediaMail.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @media_mail }
    end
  end

  # GET /media_mails/new
  # GET /media_mails/new.xml
  def new
    @media_mail = MediaMail.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @media_mail }
    end
  end

  # GET /media_mails/1/edit
  def edit
    @media_mail = MediaMail.find(params[:id])
  end

  # POST /media_mails
  # POST /media_mails.xml
  def create
    @media_mail = MediaMail.new(params[:media_mail])

    respond_to do |format|
      if @media_mail.save
        flash[:notice] = 'MediaMail was successfully created.'
        format.html { redirect_to(@media_mail) }
        format.xml  { render :xml => @media_mail, :status => :created, :location => @media_mail }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @media_mail.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /media_mails/1
  # PUT /media_mails/1.xml
  def update
    @media_mail = MediaMail.find(params[:id])

    respond_to do |format|
      if @media_mail.update_attributes(params[:media_mail])
        flash[:notice] = 'MediaMail was successfully updated.'
        format.html { redirect_to(@media_mail) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @media_mail.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /media_mails/1
  # DELETE /media_mails/1.xml
  def destroy
    @media_mail = MediaMail.find(params[:id])
    @media_mail.destroy

    respond_to do |format|
      format.html { redirect_to(media_mails_url) }
      format.xml  { head :ok }
    end
  end
end
