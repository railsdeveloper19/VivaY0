class UsersController < ApplicationController
  before_filter :authorize_user!
  layout 'vivayo'
  
  def show
    user = User.find(params[:id]) rescue nil
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => user }
    end
  end
  
  def edit
    user = User.find(params[:id]) rescue nil
    respond_to do |format|
      format.html # edit.html.erb
      format.json { render :json => user }
    end
  end
  
  def organisations
    @orgs = User.where("user_type='organisation'") rescue nil
  end
  
  def joinus
    usr_mapping = UserMapping.where("user_id=? AND join_id=?",current_user.id,params['org_id'])
    
    if(usr_mapping.blank?)
      UserMapping.create(:user_id=>current_user.id ,:join_id=>params['org_id'])
      UserMapping.create(:user_id=>params['org_id'] ,:join_id=>current_user.id)
    end
    render :nothing=>true
  end
  
  def update
    if !params[:user].blank?
    current_user.update_attributes(user_params)
    render :action=>'show'
    else
      profile_photo
    end
  end
  
  
  def profile_photo
    if current_user.photos.blank?
      Photo.create(:data => params[:file].read,:filename => params[:file].original_filename,:mime_type=>params[:file].content_type,:photable_type=>'User',:photable_id=>current_user.id) if !params[:file].blank?
    else
      current_user.photos.first.update_attributes(:data => params[:file].read,:filename => params[:file].original_filename,:mime_type=>params[:file].content_type,:photable_type=>'User',:photable_id=>current_user.id) if !params[:file].blank?
    end 
    redirect_to posts_path
  end
  
  private
  def user_params
    params.require(:user).permit(:first_name,:last_name,:state,:address,:gender,:dob,:contact,:qualification, :occupation,:objective,:work,:few_words ,:user_type)
  end
end
