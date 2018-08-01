class Api::WalletController < Api::ApiController
  before_action :assets
  def index; end
  
  def show
    @asset = @assets.find_by_id(params[:id])
    return render_404 if @asset.blank?
  end

  def surplus
    asset = current_user.assets.find_by(id: params[:asset_id])
    return render_404 if asset.blank?
    asset.update_attribute(:amount, params[:amount].to_f)
    render_success
  end

  # asset_detail.wpy
  # 资产详情的 header
  def information
    asset_id = params[:asset_id]
    asset = current_user.assets.find_by(id: params[:asset_id])
    return render_404 if asset.blank?

    statements = current_user.statements.where(asset_id: asset_id)
    expend_amount = statements.where("type = 'expend'").sum(:amount)
    income_amount = statements.where("type = 'income'").sum(:amount)
    surplus = income_amount - expend_amount
    render json: {
      name: asset.name,
      income: money_format(income_amount), 
      expend: money_format(expend_amount), 
      surplus: money_format(asset.amount.zero? ? surplus : asset.amount),
      source_surplus: asset.amount.zero? ? surplus : asset.amount
    }
  end

  # 资产详情分类列表 
  def detail
    asset_id = params[:asset_id].to_i
    @statements = current_user.statements.where(asset_id: asset_id)
    return render json: [] if @statements.blank?
    res = Rails.cache.fetch("@user_id_#{current_user.id}_asset_detail_asset_id_#{asset_id}@",expires_in:2.hours) do
      group_st = @statements.group(:year, :month).order('year desc, month desc')
      group_st.map do |gs|
        sts = @statements.where(year: gs.year, month: gs.month).includes(:category).order('created_at desc')
        expend_amount = sts.where("statements.type = 'expend'").sum(:amount)
        income_amount = sts.where("statements.type = 'income'").sum(:amount)
        {
          month: gs.month,
          year: gs.year,
          expend_amount: money_format(expend_amount),
          income_amount: money_format(income_amount),
          surplus: money_format(income_amount - expend_amount),
          hidden: true,
          childs: sts.map{|st|
            {
              id: st.id,
              day: st.day,
              week: weekday(Time.parse("#{st.year}-#{st.month}-#{st.day}").wday),
              type: st.type,
              name: st.category.name,
              icon_path: st.category.icon_url,
              description: st.description,
              amount: money_format(st.amount),
              timeStr: st.created_at.strftime("%m-%d %H:%M"),
              asset: st.asset.name
            }
          }
        }
      end
    end
    render json: res
  end


  private

  def assets
    @assets ||= current_user.assets
  end
end
