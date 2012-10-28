class ListsController < ApplicationController

  before_filter :find_user_or_stack
  respond_to :html, :xml, :json

  def new
    if current_user && params[:stack_id].nil?
      list = List.new
      membership = list.memberships.build
      membership.user = current_user
    else
    	list = @stack.lists.new
    end

    if list.save
      if current_user
        redirect_to user_list_path(current_user, list)
      else
        redirect_to stack_list_path(@stack, list)
      end
    else
      redirect_to @stack
    end
  end

  def index
    respond_with @stack.lists
  end

  def show
    @list = @stack.lists.find_by_slug(params[:id])
    respond_with @list
  end
  
  def update
    @list = @stack.lists.find_by_slug(params[:id])
    if @list.update_attributes(params[:list])
      #override the default respond_with behavoir to always send back the model with update
      render :json => @list, :status => :created
    else
      flash[:error] = "Could not update list"
      redirect_to edit_stack_list_path(@stack, @list)
    end
  end
  
  def destroy
    @list = @stack.lists.find_by_slug(params[:id])
    if @list.delete!
      render :json => true
    else
      render :json => 'Permission denied'
    end
  end

  def join
    list = List.find_by_slug(params[:list_id])

    if current_user# && !@stack.lists.include?(list)
      list.build_membership_for(current_user)
    end

    redirect_to request.referer
  end

  def find_user_or_stack
    if params[:stack_id].nil?
      if current_user
        @stack = current_user
      else
        redirect_to :root
      end
    else
      @stack = Stack.find_or_create_by_token(params[:stack_id])
    end
  end
end
