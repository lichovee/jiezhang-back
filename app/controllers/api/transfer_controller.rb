class Api::TransferController < Api::ApiController
  
  def show
    @transfer = current_user.asset_logs.includes(:source, :target).find_by_id(params[:id])
    return render_404 if @transfer.blank?
  end

end