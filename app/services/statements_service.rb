class StatementsService
  attr_accessor :current_user, :params, :source_params, :from_asset, :to_asset
  include ApplicationHelper
  def initialize(current_user, params = {})
    @current_user = current_user
    @source_params = params
    @params = params.require(:statement) if params[:statement].present?
  end

  def create!
    validate_asset_category!
    current_user.statements.create!(api_params)
  end

  def update!
    validate_asset_category!
    time = Time.parse("#{params[:date]} #{params[:time]}")
    statement.update_attributes!(api_params)
    update_transfer_amount if statement.transfer?
    statement
  end
  
  private
  
  def update_transfer_amount
    # 还原原来的资产金额记录
    source_asset = statement.asset
    target_asset = statement.target_asset
    source_asset.update_attribute(:amount, source_asset.amount + statement.amount)
    target_asset.update_attribute(:amount, target_asset.amount - statement.amount)
    # 更新转账的资产记录
    from_asset.update_attribute(:amount, from_asset.amount - statement.amount)
    to_asset.update_attribute(:amount, to_asset.amount + statement.amount)
    # 更新变更后的余额
    statement.residue = from_asset.amount - statement.amount
    statement.save!
  end

  def validate_asset_category!
    if params[:type] == 'transfer'
      @from_asset = current_user.assets.find_by_id(params[:from])
      @to_asset = current_user.assets.find_by_id(params[:to])
      if from_asset.blank? || to_asset.blank?
        raise '无效的资产类型'
      end
    else
      asset = current_user.assets.find_by_id(params[:asset_id])
		  category = current_user.categories.find_by_id(params[:category_id])
      if asset.blank? || category.blank?
        raise '无效的账户/分类'
      end
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

    if params[:type] == 'transfer'
      p[:asset_id] = params[:from]
      p[:target_asset_id] = params[:to]
      p[:title] = "#{from_asset.name} -> #{to_asset.name}"
      p[:category_id] = current_user.categories.where(type: 'transfer', lock: 1, name: '转账').first.id
    end

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