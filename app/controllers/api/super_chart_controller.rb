class Api::SuperChartController < Api::ApiController
  before_action :get_statements, only: [:index]
  # type: month 按月份筛选
  #       year 按年筛选
  #       all  不筛选，默认所有
  def index
    statement_type = params[:statement_type] || 'expend'
    # 当前收支
    expend_count = @statements.expend.sum(:amount)
    income_count = @statements.income.sum(:amount)
    surplus = income_count - expend_count
    # 同期收支
    prev_expend_count = @prev_statements.expend.sum(:amount)
    prev_income_count = @prev_statements.income.sum(:amount)
    prev_surplus = prev_income_count - prev_expend_count

    charts = @statements.where(type: statement_type).joins(:category).group(:category_id).select("sum(`statements`.amount) as data, `categories`.id, `categories`.name").order("data desc")
    charts = charts.map do |c|
      {
        name: c.name,
        data: c.data,
        format_amount: money_format(c.data),
        percent: sprintf("%.2f", (c.data.to_f / expend_count.to_f)*100),
        category_id: c.id
      }
    end
    wx_charts = charts.collect{|c| { name: c[:name], data: c[:data].to_i } }
    header = {
      expend_count: money_format(expend_count),
      income_count: money_format(income_count),
      surplus: money_format(surplus)
    }
    header[:expend_percent], header[:expend_rise] = get_percent(expend_count, prev_expend_count)
    header[:income_percent], header[:income_rise] = get_percent(income_count, prev_income_count)
    header[:surplus_percent], header[:surplus_rise] = get_percent(surplus, prev_surplus)
    render json: { header: header, charts: charts, wx_charts: wx_charts }
  end

  def line_chart
    @statements = current_user.statements.where(year: params[:year] || Time.now.year)
    @months = @statements.group(:month).order('month asc').pluck(:month)
    @expends = @statements.where(type: 'expend').group(:month).order('month asc').select('month, sum(`statements`.amount) as data')
    @incomes = @statements.where(type: 'income').group(:month).order('month asc').select('month, sum(`statements`.amount) as data')
    @months.each do |month|
      @surplus ||= []
      income = @incomes.find{|income| income.month == month}.try(:data) || 0
      expend = @expends.find{|expend| expend.month == month}.try(:data) || 0
      @surplus << (income - expend)
    end
    @expends = @expends.collect(&:data)
    @incomes = @incomes.collect(&:data)
    render json: {months: @months, expends: @expends, incomes: @incomes, surplus: @surplus}
  end

  private
    def get_statements
      type = params[:type] || 'month'
      month = params[:month]  || Time.now.month
      year = params[:year] || Time.now.year  
      if type == 'month'
        local_time = Time.parse("#{year}-#{month}-01")
        last_month = local_time.last_month
        @statements = current_user.statements.where(year: year, month: month)
        @prev_statements = current_user.statements.where(year: last_month.year, month: last_month.month)
      elsif type == 'year'
        @statements = current_user.statements.where(year: year)
        @prev_statements = current_user.statements.where(year: year.to_i - 1)
      elsif type == 'all'
        @statements = current_user.statements
        @prev_statements = current_user.statements
      end
    end
end