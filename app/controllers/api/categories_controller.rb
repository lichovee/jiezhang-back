class Api::CategoriesController < Api::ApiController
  before_action :categories, only: [:index, :parent]
  before_action :category, only: [:show, :update, :destroy]
  def index; end

  def parent; end
  
  def show; end

  def create
    category = params.require(:category).permit(:name, :parent_id, :icon_path, :type).to_hash
    current_user.categories.create!(category)
    render_success
  end

  def update
    category = params.require(:category).permit(:name, :parent_id, :icon_path, :type).to_hash
    @category.update_attributes!(category)
    render_success
  end

  def destroy
    @category.destroy
    render_success
  end

  private

  def categories
    @categories = current_user.categories.where('type = ?', params[:type]).order('`order` asc, `id` asc')
  end

  def category
    @category ||= current_user.categories.find_by_id(params[:id])
    return render_404 if @category.blank?
  end

end