class StatementsService
  attr_accessor :current_user, :params, :source_params
  include ApplicationHelper
  def initialize(current_user, params = {})
    @current_user = current_user
    @source_params = params
    @params = params.require(:statement) if params[:statement].present?
  end

  def list
    @statements = filter_statements.includes(:category, :asset).order('created_at desc')
    @statements.collect do |st|
      {
        id: st.id,
        day: st.day,
        week: weekday(Time.parse("#{st.year}-#{st.month}-#{st.day}").wday),
        type: st.type,
        category: st.category.name,
        icon_path: st.category.icon_url,
        description: st.description,
        money: money_format(st.amount),
        timeStr: st.created_at.strftime("%m-%d %H:%M"),
        asset: st.asset.name
      }
    end
  end

  def create!
    if params[:type] == 'expend' || params[:type] == 'income'
      create_statement
    elsif params[:type] == 'transfer'
      create_transfer
    else
      raise '无效的类型'
    end
  end

  def update!
    if params[:type] == 'expend' || params[:type] == 'income'
      update_statement
    elsif params[:type] == 'transfer'
      update_transfer
    else
      raise '无效的类型'
    end
  end

  private

  def create_statement
    validate_asset_category!
    statement = current_user.statements.new(api_params)
		asset_amount = statement.asset.amount
    amount = statement.type == 'expend' ? asset_amount - statement.amount : asset_amount + statement.amount
    statement.residue = amount
    statement.save!
    statement
  end
  
  def update_statement
    validate_asset_category!
    time = Time.parse("#{params[:date]} #{params[:time]}")
    statement.update_attributes!(api_params)
    statement
  end

  def create_transfer
    from_asset = current_user.assets.find_by_id(params[:from])
    to_asset = current_user.assets.find_by_id(params[:to])
    if from_asset.blank? || to_asset.blank?
      raise '无效的资产类型'
    end

    asset_logs = current_user.asset_logs.new(
      type: AssetLog::TRANSFER,
      from: from_asset.id,
      to: to_asset.id,
      amount: params[:amount],
      description: params[:description]
    )
    
    from_amount = from_asset.amount - asset_logs.amount
    to_amount = to_asset.amount + asset_logs.amount
    from_asset.update_attribute(:amount, from_amount)
    to_asset.update_attribute(:amount, to_amount)
    asset_logs.residue = from_amount
    asset_logs.save!
  end
  
  def update_transfer
    from_asset = current_user.assets.find_by_id(params[:from])
    to_asset = current_user.assets.find_by_id(params[:to])
    if from_asset.blank? || to_asset.blank?
      raise '无效的资产类型'
    end

    transfer_asset = current_user.asset_logs.find_by_id(params[:asset_log_id])
    raise '转账记录或已删除' if transfer_asset.blank?

    # 还原原来的资产金额记录
    source_asset = transfer_asset.source
    target_asset = transfer_asset.target
    source_asset.update_attribute(:amount, source_asset.amount + transfer_asset.amount)
    target_asset.update_attribute(:amount, target_asset.amount - transfer_asset.amount)

    # 更新 asset_logs 记录
    transfer_asset.from = from_asset.id
    transfer_asset.to = to_asset.id
    transfer_asset.amount = params[:amount]
    transfer_asset.description = params[:description]

    # 更新转账的资产记录
    from_amount = from_asset.amount - transfer_asset.amount
    to_amount = to_asset.amount + transfer_asset.amount
    from_asset.update_attribute(:amount, from_amount)
    to_asset.update_attribute(:amount, to_amount)

    transfer_asset.residue = from_amount
    transfer_asset.save!
  end

  def validate_asset_category!
    asset = current_user.assets.find_by_id(params[:asset_id])
		category = current_user.categories.find_by_id(params[:category_id])
		if asset.blank? || category.blank?
			raise '无效的账户/分类'
    end
  end

  def statement
    return @statement if @statement.present?
    @statement = current_user.statements.find_by_id(source_params[:id])
    raise '该账单已删除' if @statement.blank?
    @statement
  end

  def filter_statements
    @statements = current_user.statements
    if source_params[:year].present?
      @statements = @statements.where(year: source_params[:year])
    end

    if source_params[:month].present? && source_params[:month].to_i != -1
      @statements = @statements.where(month: source_params[:month])
    end

    if source_params[:category].present?
      category_ids = current_user.categories.where('parent_id = ?', source_params[:category]).pluck(:id)
      @statements = @statements.where(category_id: category_ids)
    end

    if source_params[:asset].present?
      asset_ids = current_user.assets.where('parent_id = ?', source_params[:asset]).pluck(:id)
      @statements = @statements.where(asset_id: asset_ids)
    end

    if source_params[:category_id].present?
      @statements = @statements.where(category_id: source_params[:category_id])
    end
    
    @statements
  end

  # 新建账单参数
  def api_params
    time = Time.parse("#{params[:date]} #{params[:time]}")
    p = {
      category_id: params[:category_id],
      asset_id: params[:asset_id],
			amount: params[:amount],
			type: params[:type],
      description: params[:description],
			year: time.year,
			month: time.month,
			day: time.day,
			time: time.strftime("%H:%M"),
			created_at: time
    }
    if params[:location].present?
      p.merge!(
        location: params[:location],
        nation: params[:nation],
        province: params[:province],
        city: params[:city],
        district: params[:district],
        street: params[:street]
      )
    end
    p
  end

end