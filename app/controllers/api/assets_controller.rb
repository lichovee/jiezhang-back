class Api::AssetsController < Api::ApiController
  before_action :assets, only: [:index, :parent]
  before_action :asset, only: [:show, :update, :destroy]

  def index; end

  def parent; end
  
  def show; end

  def create
    wallet = params.require(:wallet).permit(:name, :amount, :parent_id, :icon_path, :remark).to_hash
    wallet.merge!(creator_id: current_user.id)
    asset = Asset.create!(wallet)
    UsersAsset.create!(user_id: current_user.id, asset_id: asset.id)
    render_success
  end

  def update
    wallet = params.require(:wallet).permit(:name, :amount, :parent_id, :icon_path, :remark).to_hash
    @asset.update_attributes!(wallet)
    render_success
  end

  def destroy
    @asset.destroy
    render_success
  end

  private

    def assets
      @assets = current_user.assets
    end

    def asset
      @asset ||= current_user.assets.find_by_id(params[:id])
      return render_404 if @asset.blank?
    end

end