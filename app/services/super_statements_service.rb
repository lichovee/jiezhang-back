class SuperStatementsService
  attr_accessor :current_user, :params, :source_params
  include ApplicationHelper
  def initialize(current_user, params = {})
    @current_user = current_user
    @params = params
  end

  def super_months
    @statements = filter_statements
    expend_statements = @statements.where(type: 'expend').group(:year, :month)
                                   .select("`statements`.year, `statements`.month, sum(`statements`.amount) as expend_amount")
    income_statements = @statements.where(type: 'income').group(:year, :month)
                                   .select("`statements`.year, `statements`.month, sum(`statements`.amount) as income_amount")
    statements = @statements.joins("left join (#{expend_statements.to_sql}) s1 on s1.year = statements.year and s1.month = statements.month")
                            .joins("left join (#{income_statements.to_sql}) s2 on s2.year = statements.year and s2.month = statements.month")
                            .select('statements.year, statements.month, 
                                    IFNULL(expend_amount, 0) as expend_amount, 
                                    IFNULL(income_amount, 0) as income_amount, 
                                    (IFNULL(income_amount, 0) - IFNULL(expend_amount, 0)) as surplus,
                                    1 as hidden')
                            .group(:year, :month)
                            .order('year desc, month desc')
    header = {
      expend: statements.inject(0){ |sum, e| sum += e.expend_amount.to_f },
      income: statements.inject(0){ |sum, e| sum += e.income_amount.to_f }
    }
    header[:left] = money_format(header[:income] - header[:expend])
    header[:expend] = money_format(header[:expend])
    header[:income] = money_format(header[:income])
    { statements: statements, header: header }
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
  
  private
    def filter_statements
      @statements = current_user.statements
      if params[:year].present?
        @statements = @statements.where(year: params[:year])
      end
      if params[:month].present? && params[:month].to_i != -1
        @statements = @statements.where(month: params[:month])
      end
      if params[:asset].present?
        asset_ids = current_user.assets.where('parent_id = ?', params[:asset]).pluck(:id)
        @statements = @statements.where(asset_id: asset_ids)
      end
      if params[:asset_id].present?
        @statements = @statements.where(asset_id: params[:asset_id])
      end
      if params[:category_id].present?
        @statements = @statements.where(category_id: params[:category_id])
      end
      @statements
    end

end