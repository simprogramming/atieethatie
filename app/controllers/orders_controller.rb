class OrdersController < ApplicationController
  include AdminSideHelper
  before_action :set_order, only: %i[edit update show destroy]
  before_action -> { authorize @order || Order }

  decorates_assigned :order, :orders
  add_controller_helpers :orders, only: :index

  def index
    @orders = policy_scope(Order)
  end

  def show
  end

  def new
    @order = Order.new
  end

  def edit
  end

  def create
    @order = Order.new(permitted_attributes(Order))

    if @order.save
      redirect_to @order, notice: create_successful_notice
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @order.update(permitted_attributes(order))
    if @order.save
      redirect_to orders_path, notice: update_successful_notice
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @order.destroy
    redirect_to orders_path, notice: destroy_successful_notice
  end

  private

  def set_order
    @order = policy_scope(Order).find(params[:id])
  end
end
