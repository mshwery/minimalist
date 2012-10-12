class StacksController < ApplicationController

  respond_to :html, :xml, :json

  def index
    redirect_to :root
  end

  def show
    @stack = Stack.find_by_token(params[:id])
    if @stack
      respond_with @stack
    else
      redirect_to root_url
    end
  end

  #TODO: Get rid of this. Users shouldn't be able to destroy records
  def destroy
    @stack = Stack.find_by_token(params[:id])
    if @stack.destroy
      flash[:notice] = "Stack deleted"
      redirect_to root_url
    else
      flash[:error] = "Could not delete stack."
      redirect_to stack_url(@stack)
    end
  end
  
end
