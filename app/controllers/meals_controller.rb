class MealsController < ApplicationController
  before_action :set_meals, only: [:show, :edit, :destroy, :update]
  skip_before_action :authenticate_user!, only: [ :index, :show]

  def index
    @meals = policy_scope(Meal).order(created_at: :desc)
    authorize @meals
  end

  def show
    @order = Order.new
  end

  def new
    @meal = Meal.new
    authorize @meal
  end

  def create
    @meal = Meal.new(meal_params)
    @meal.cook = current_user
    #raise
    authorize @meal
    if @meal.save
      redirect_to meals_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    @meal.update(meal_params)
    redirect_to meal_path(@meal)
  end

  def destroy
    @meal.destroy
    redirect_to meals_path
  end

  def my_repository
    @my_meals = current_user.meals
    authorize @my_meals
  end

  private

  def meal_params
    params.require(:meal).permit(:name, :description, :address, :price, :grams_per_dose, :ingredients)
  end

  def set_meals
    @meal = Meal.find(params[:id])
    authorize @meal
  end

end
