class ItemsController < ApplicationController

  # before_filter :login_required, except: [:get_items]
  before_action :authenticate_user!, except: [:get_items]

  def index
    @items = current_user.items.all
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    @item.user_id = current_user.id
    @item.latitude = session[:lat]
    @item.longitude = session[:lng]
    @item.place_name = session[:name]
    @item.address = session[:formatted_address]
    if @item.save
      redirect_to '/items'
    else
      render 'new'
    end
  end

  def show
    @item = Item.find(params[:id])
  end

  def edit
    @item = Item.find(params[:id])
  end

  def update
    @item = Item.find(params[:id])
    @item.update(item_params)
    redirect_to '/items'
  end

  def destroy
    @item = Item.find(params[:id])
    @item.destroy
    flash[:notice] = 'Item deleted successfully'
    redirect_to '/items'
  end

  def toggle
    @item = Item.find(params[:id])
    @item.completed == false ? @item.update(completed: true) : @item.update(completed: false)
  end

  def coords
    session[:lat] = params[:lat]
    session[:lng] = params[:lng]
    session[:name] = params[:name]
    session[:formatted_address] = params[:formatted_address]
  end

  def item_params
    params.require(:item).permit(:name, :description, :completed, :address, :post_code, :city, :street, :latitude, :longitude, :country)
  end

end
