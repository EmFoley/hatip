class UsersController < ApplicationController
  def show
     @user = User.find(params[:id])
     @post = Post.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.update_attributes(params[:user])
    if @user.save
      redirect_to user_path
    else
      flash[:errors] = @user.errors.full_messages
      render "update_form_error"
    end
  end

  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      redirect_to root_path
    end
  end

end