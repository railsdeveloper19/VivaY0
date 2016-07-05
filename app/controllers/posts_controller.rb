class PostsController < ApplicationController
  
  before_filter :authorize_user!
  layout 'vivayo'
  include PostsHelper
  
  #before_filter :read_notification,:except =>['save_comment','like_unlike_post_and_comment','edit_and_delete_comment','mark_read_to_notification']
  
  # GET /posts.json

  def index
    if !params[:post_id].blank?
      @index_posts = Post.where("id  =?",params[:post_id])
    else
      @index_posts = Post.where("user_id in (?)",current_user.user_mappings.map(&:join_id).uniq).reverse rescue nil
    end
    #@is_liked = current_user.likes.where("likeable_id = ? and likeable_type=?",@post.id,@post.class.to_s).first rescue nil
    #@comments=@post.comments.order("created_at DESC").first(4) rescue []
    #posts = Post.all.reverse
    #@post_size=posts.size
    #@posts = posts.first(6)
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @post = Post.find(params[:id]) rescue nil
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @post }
    end
  end

  # GET /posts/new
  # GET /posts/new.json
  def new
    @post = Post.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @post }
    end
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id]) rescue nil
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)
    respond_to do |format|
      if @post.save
        Photo.create(:data => params[:file].read,:description=>params[:photo][:description],:filename => params[:file].original_filename,:mime_type=>params[:file].content_type,:photable_type=>'Post',:photable_id=>@post.id) if !params[:file].blank?
        format.html { redirect_to @post, :notice => 'Post was successfully created.' }
        format.json { render :json => @post, :status => :created, :location => @post }
      else
        format.html { render :action => "new" }
        format.json { render :json => @post.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.json
  def update
    @post = Post.find(params[:id]) rescue nil
    respond_to do |format|
      if @post.update_attributes(post_params)
        if @post.photos.blank?
          Photo.create(:data => params[:file].read,:description=>params[:photo][:description],:filename => params[:file].original_filename,:mime_type=>params[:file].content_type,:photable_type=>'Post',:photable_id=>@post.id) if !params[:file].blank?
        else
          @post.photos.first.update_attributes(:data => params[:file].read,:description=>params[:photo][:description],:filename => params[:file].original_filename,:mime_type=>params[:file].content_type,:photable_type=>'Post',:photable_id=>@post.id) if !params[:file].blank?
        end
        format.html { redirect_to @post, :notice => 'Post was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @post.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post = Post.find(params[:id]) rescue nil
    @post.destroy
    respond_to do |format|
      if params[:from_page]=="home"
        format.html { redirect_to posts_url }
      elsif params[:from_page]=="all_post"
        format.html { redirect_to post_all_post_path(@post) }
      else
        format.html { redirect_to root_path }
      end
      format.json { head :no_content }
    end
  end
 
  def save_comment
    @post=Post.where(:id =>  params[:post_id]).first rescue nil
    @comment= Comment.new(:post_id => params[:post_id], :commenter => current_user.email, :body => params[:comment],:user_id=>current_user.id)
    @comment.save
    @comments=Comment.where(:post_id => params[:post_id]).order("created_at ASC").last(4 * params[:no_click].to_i) rescue []
    #create_notification(@post,'comment on')
  end

  def all_post
    @posts = current_user.posts.paginate(:page => params[:page]).order("created_at DESC") rescue []
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @posts }
    end
  end
  
  def list_grid_view
    @posts = current_user.posts.paginate(:page => params[:page]).order("created_at DESC") rescue []
  end
  
  def show_post_and_comment
    @post=Post.where(:id =>  params[:post_id]).first rescue nil
    @comments=@post.comments.order("created_at ASC").last(4) rescue []
    @is_liked = current_user.likes.where("likeable_id = ? and likeable_type=?",@post.id,@post.class.to_s).first rescue nil
    posts = Post.all.reverse
    @post_size=posts.size
    @posts = posts.first(6)
  end

  def refresh_comments
    @post=Post.where(:id =>  params[:post_id]).first rescue nil
    @post_comments = @post.comments.order("created_at DESC").last(4 * params[:no_click].to_i) rescue []
  end

  def like_unlike_post_and_comment
    post = Post.where(:id =>  params[:post_id]).first
    if params[:like_unlike]=='Like'
      Like.create(:user_id =>current_user.id,:likeable=>post)
      #create_notification(post,'like')
    else
      current_user.likes.where("likeable_id = ? and likeable_type=?",post.id,post.class.to_s).first.delete
    end 
  end

  def mark_read_to_notification
    notify_key_unread = 'bloggerlive_notify_unread' + current_user.id.to_s
    notify_key_read = 'bloggerlive_notify_read' + current_user.id.to_s
    list_range = $redis.llen(notify_key_unread)
    redis_notifications_unread = $redis.lrange(notify_key_unread,0,list_range) rescue []
    redis_notifications_unread.each do |notification_unread|
      $redis.rpush(notify_key_read,notification_unread)
    end
    $redis.del(notify_key_unread)
    render :nothing=>true
  end

  def edit_and_delete_comment
    comment=Comment.where(:id=> params[:comment_id]).first rescue nil
    #@post = comment.post
    #@post_comments = @post.comments.order("created_at ASC").last(4 * params[:no_click].to_i)
    if(params[:from_edit] == 'true')
      comment.update_attributes(:body =>params[:comment])
      @comment = Comment.where(:id=> params[:comment_id]).first
    elsif(params[:from_delete] == 'true')
      comment.delete
      render :nothing=>true
    end
  end
  
  def search_post
    @posts = Post.where("position('#{params[:content].downcase}' IN lower(title)) > 0");
  end
  
  def serve
    @photo = Photo.find(params[:id])
    send_data(@photo.data, :type => @photo.mime_type, :filename => "#{@photo.filename}", :disposition => "inline")
  end  
  
  private
  def post_params
    params.require(:post).permit(:text, :name, :title, :user_id)
  end
  
  def comment_params
    params.require(:comment).permit(:body, :commenter, :post_id, :user_id)
  end
end
