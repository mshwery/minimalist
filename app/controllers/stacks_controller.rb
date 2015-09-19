class StacksController < ApplicationController

  respond_to :html, :json

  def index
    redirect_to :root
  end

  def new
    @stack = Stack.new

    if @stack.save
      redirect_to new_stack_list_path(@stack)
    else
      redirect_to :root
    end
  end

  def show
    @stack = Stack.find_by_token(params[:id])
    if @stack
      respond_with @stack
    else
      redirect_to root_url
    end
  end
  
end
