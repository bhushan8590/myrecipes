class ChefsController < ApplicationController
  def new
    @chef = Chef.new
  end

  def create
    @chef = Chef.new(chef_params)
    if @chef.save
      flash[:success] = "Welcome #{@chef.chefname} to MyRecipe App...!!"
      redirect_to chef_path(@chef)
    else
      render 'new'
    end
  end

  def show
    @chef = Chef.find(params[:id])
    @chef_recipes = @chef.recipes.paginate(page:params[:page], per_page:5)
  end

  def edit
    @chef = Chef.find(params[:id])
  end

  def update
    @chef = Chef.find(params[:id])
    if @chef.update(chef_params)
      flash[:success] = "Your account updated successfully..."
      redirect_to chef_path(@chef)
    else
      render 'edit'
    end
  end

  def index
    @chefs = Chef.paginate(page:params[:page], per_page:5)
  end

  def destroy
    @chef = Chef.find(params[:id])
    @chef.destroy
    flash[:danger] = "Chef and all associated recipes have been deleted..."
    redirect_to chefs_path
  end

  private
  def chef_params
    params.require(:chef).permit(:chefname, :email, :password, :password_confirmation)
  end

end
