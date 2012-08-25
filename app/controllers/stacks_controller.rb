class StacksController < ApplicationController

  respond_to :html, :xml, :json

  def index
    #@stacks = Stack.all
    redirect_to :root
  end

  def new
    @stack = Stack.new
  end

  def create
    @stack = Stack.new(params[:stack])
    if @stack.save
      flash[:notice] = "saved!"
      respond_with(@stack, :location => stack_url(@stack))
    else
      flash[:error] = "Couldn't create."
      redirect_to new_stack_url
    end
  end

  def show
    @stack = Stack.find_by_token(params[:id])
    if @stack
      @lists = @stack.lists
    else
      redirect_to root_url
    end
  end

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
