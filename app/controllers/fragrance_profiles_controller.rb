class FragranceProfilesController < ApplicationController
  include AdminSideHelper
  before_action :set_fragrance_profile, only: %i[edit update show destroy]
  before_action -> { authorize @fragrance_profile || FragranceProfile }

  decorates_assigned :fragrance_profile, :fragrance_profiles
  add_controller_helpers :fragrance_profiles, only: :index

  def index
    @fragrance_profiles = policy_scope(FragranceProfile).order(:name_fr)
  end

  def show
  end

  def new
    @fragrance_profile = FragranceProfile.new
  end

  def edit
  end

  def create
    @fragrance = FragranceProfile.new(permitted_attributes(FragranceProfile))

    if @fragrance.save
      redirect_to @fragrance, notice: create_successful_notice
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @fragrance_profile.assign_attributes(fragrance_profile_params)
    if @fragrance_profile.save
      redirect_to fragrance_profiles_path, notice: update_successful_notice
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @fragrance_profile.destroy
    redirect_to fragrance_profiles_path, notice: destroy_successful_notice
  end

  private

  def set_fragrance_profile
    @fragrance_profile = policy_scope(FragranceProfile).find(params[:id])
  end
end
