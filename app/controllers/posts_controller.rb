class PostsController < ApplicationController
	before_action :is_owner?, only: [:edit, :update, :destroy]
	before_action :authenticate_user!, only: [:new, :create]
	def index
		@posts = Post.all.order('created_at DESC').paginate(:page => params[:page], :per_page => 5)
	end
	def new
		@post = Post.new
	end
	def edit
  		@post = Post.find(params[:id])
	end

	def create
  		@post = current_user.posts.create(post_params)
  		if @post.valid?
    		redirect_to root_path
  		else
    		render :new, status: :unprocessable_entity
  		end
	end
	def update
  		@post = Post.find(params[:id])
  		@post.update(post_params)
  		if @post.valid?
    		redirect_to root_path
  		else
    		render :edit, status: :unprocessable_entity
  		end
	end
	def destroy
  		@post = Post.find(params[:id])
  		user_id = @post.user_id
  		@post.destroy
  		redirect_to user_path(user_id)
	end
	def show
  		@post = Post.find(params[:id])
	end


	private
	
	def post_params
  		params.require(:post).permit(:user_id, :photo, :description)
	end
	def is_owner?
  		if Post.find(params[:id]).user != current_user
    		redirect_to root_path
  		end
	end
end
