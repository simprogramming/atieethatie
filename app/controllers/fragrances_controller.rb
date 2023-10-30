class FragrancesController < ApplicationController
  include AdminSideHelper
  before_action :set_fragrance, only: %i[edit update show destroy]
  before_action -> { authorize @fragrance || Fragrance }

  decorates_assigned :fragrance, :fragrances
  add_controller_helpers :fragrances, only: :index

  def index
    @fragrances = policy_scope(Fragrance).order(:name_fr)
  end

  def show
  end

  def new
    @fragrance = Fragrance.new
  end

  def edit
  end

  def create
    @fragrance = Fragrance.new(permitted_attributes(Fragrance))

    if @fragrance.save
      redirect_to @fragrance, notice: create_successful_notice
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @fragrance.assign_attributes(fragrance_params)
    if @fragrance.save
      redirect_to fragrances_path, notice: update_successful_notice
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @fragrance.destroy
    redirect_to fragrances_path, notice: destroy_successful_notice
  end

  private

  def set_fragrance
    @fragrance = policy_scope(Fragrance).find(params[:id])
  end
end
