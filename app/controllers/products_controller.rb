class ProductsController < ApplicationController

  # before_action :authenticate_user!, except: [:index, :show, :buy, :new, :change]
  before_action :set_product, only: [:change]
  before_action :check_address, only: :buy
  before_action :check_payment, only: :buy
  before_action :set_api_for_payjp

  def index
    @category_item = ["レディース","メンズ","ベビー・キッズ","コスメ・香水・美容"]
    @categories = Category.where(name: @category_item)
  end

  def new
    @product = Product.new
    @image = @product.images.build
    @category = Category.ids
    @categories = Category.all
    @roots = @categories.roots

  end

  def create
    @product = Product.new(product_params)
   
    if @product.save
      params[:images]['image'].each do |a|
        @image = @product.images.create!(image:a)
      end
      redirect_to @product
    else
      render 'new'
    end

  end


  def show
  end

  def edit
    @product = Product.find(params[:id])
    @images = @product.images
    @category = @product.category
  end


  def update 
    @product = Product.find(params[:id])
    
    if @product.update(product_params)
      redirect_to @product
    else
      render 'edit'
    end
  end

  def buy
    # 住所の取得
    @address = Address.find_by(user_id: current_user.id)
    @user = User.find(current_user.id)
    # カード情報の取得
    @payment = Payment.find_by(user_id: current_user.id)
    customer = Payjp::Customer.retrieve(@payment.customer_id)
    @card_information = customer.cards.retrieve(@payment.card_id)
    @product = Product.find(params[:id])
  end

  def change
    @image = @product.images.first
  end

  def destroy
    @product.destroy
    redirect_to root_path
  end

  
  private
  def set_product
    @product = Product.find(params[:product_id])
  end

  def product_params

    params.require(:product).permit(:name, :description, :price, :condition, :who_to_pay, :origin_of_delivery, :size, :deliverying_date, :category_id, images_attributes: [:image])
  end

  # 以下で住所登録とクレジットカード登録を済ませたユーザーかどうかのチェック
  def check_address
    if Address.where(user_id: current_user.id).blank?
       redirect_to new_address_path
    end
  end

  def check_payment
    if Payment.where(user_id: current_user.id).blank?
       redirect_to new_payment_path
    end
  end
end

