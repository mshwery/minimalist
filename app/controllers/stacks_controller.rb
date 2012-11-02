class StacksController < ApplicationController

  respond_to :html, :xml, :json

  def index
    redirect_to :root
  end

  def show
    @stack = Stack.find_by_token(params[:id])
    if @stack
      redirect_to stack_lists_path(@stack)
    else
      redirect_to root_url
    end
  end
  
end
