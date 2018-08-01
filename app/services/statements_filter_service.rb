class StatementsFilterService
  attr_accessor :statements, :params, :current_user
  def initialize(current_user, statements, params = {})
    @current_user = current_user
    @statements = statements
    @params = params
  end

  def execute
    result = case params[:scope]
             when 'today'
               today
             when 'week'
               week
             when 'month'
               month
             when 'year'
               year
             end
    [result, left_money]
  end

  def today
    # .order("`statements`.year desc, `statements`.month desc, `statements`.day desc, `statements`.time desc, `statements`.id desc")
    today = Time.now
    @statements = @statements.includes(:category, :asset)
                             .where("year = ? and month = ? and day = ?", today.year, today.month, today.day)
    @asset_logs = current_user.asset_logs.includes(:source, :target)
                              .where('created_at >= ? and created_at <= ? ', today.beginning_of_day, today.end_of_day)
    @statements + @asset_logs
  end

  def week
    today = Time.now.strftime("%Y-%m-%d %H:%M:%S")
    week_begin = Time.now.beginning_of_week.beginning_of_day
    @statements = @statements.where("created_at >= ? and created_at <= ?", week_begin, today)
    @asset_logs = current_user.asset_logs.includes(:source, :target)
                              .where('created_at >= ? and created_at <= ? ', week_begin, today)
    @statements + @asset_logs
  end

  def month
    today = Time.now
    @statements = @statements.where("year = ? and month = ?", today.year, today.month)
    
    @pagination_sts = order_paginate(@statements)
    @group_sts = @pagination_sts.group_by(&:week)
    i = @group_sts.size + 1
    @group_sts = @group_sts.map do |week_number, sts|
      i = i - 1
      {
        header: { 
          index: "第 #{i} 周",
          income: @statements.where("week(created_at, 1) = ? and statements.type = 'income'", week_number).sum(:amount),
          expend: @statements.where("week(created_at, 1) = ? and statements.type = 'expend'", week_number).sum(:amount)
        },
        statements: sts
      }
    end
  end

  def year
    today = Time.now
    @statements = @statements.where("year = ?", today.year)
    @pagination_sts = order_paginate(@statements)
    @group_sts = @pagination_sts.group_by(&:month)
    @group_sts = @group_sts.map do |month, sts|
      {
        header: { 
          index: "#{month}月",
          income: @statements.where("month = ? and statements.type = 'income'", month).sum(:amount),
          expend: @statements.where("month = ? and statements.type = 'expend'", month).sum(:amount)
        },
        statements: sts
      }
    end
  end

  def order_paginate(statements)
    statements.includes(:category, :asset)
              .order("`statements`.year desc, `statements`.month desc, `statements`.day desc, `statements`.time desc, `statements`.id desc")
              .paginate(:page => params[:page], :per_page => params[:per_page] || 20)
  end

  def left_money
    expend = @statements.expend.sum(:amount)
    income = @statements.income.sum(:amount)
    {
      surplus: income - expend,
      income: income,
      expend: expend 
    }
  end
end