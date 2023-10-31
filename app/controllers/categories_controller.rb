class CategoriesController < ApplicationController
  include AdminSideHelper
  before_action :set_category, only: %i[edit update show destroy]
  before_action -> { authorize @category || Category }

  decorates_assigned :category, :categories
  add_controller_helpers :categories, only: :index

  def index
    @categories = policy_scope(Category).order(:name_fr)
  end


  def show
  end

  def new
    @category = Category.new
  end

  def edit
  end

  def create
    @category = Category.new(permitted_attributes(Category))

    if @category.save
      UpsertServices::Category.new(category: @category, params: permitted_attributes(Category)).run!
      redirect_to @category, notice: create_successful_notice
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @category.update(permitted_attributes(category))
    if @category.save
      UpsertServices::Category.new(category: @category, params: permitted_attributes(category)).run!
      redirect_to categories_path, notice: update_successful_notice
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    DeleteServices::Category.new(@category.square_id).run!
    @category.destroy
    redirect_to categories_path, notice: destroy_successful_notice
  end

  def sync
    skip_policy_scope
    PullServices::Categories.new.run!
    redirect_to categories_path, notice: update_successful_notice
  end

  private

  def set_category
    @category = policy_scope(Category).find(params[:id])
  end
end
