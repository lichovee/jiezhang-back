class Api::PreOrderController < Api::ApiController

  def index
    @pre_orders = current_user.pre_orders.order("created_at desc")
  end

  def create
    pre_order = params.require(:pre_order)
    pre_order = pre_order.permit(:name, :amount, :remark, :address)
    return api_error(status: 400, msg: '商品名称不能为空') if pre_order[:name].blank?
    pre_order[:amount] = pre_order[:amount] || 0
    pre_order = current_user.pre_orders.create(pre_order)
    render_success
  end

  def update
    @pre_order = current_user.pre_orders.find_by_id(params[:id])
    return render_404 if @pre_order.blank?

    pre_order = params.require(:pre_order)
    pre_order = pre_order.permit(:name, :amount, :remark, :address)
    return api_error(status: 400, msg: '商品名称不能为空') if pre_order[:name].blank?
    @pre_order.update_attributes(pre_order)
    render_success
  end

  def destroy
    @pre_order = current_user.pre_orders.find_by_id(params[:id])
    return render_404 if @pre_order.blank?

    @pre_order.destroy
    render_success
  end

  def show
    @pre_order = current_user.pre_orders.find_by_id(params[:id])
  end
  
end
