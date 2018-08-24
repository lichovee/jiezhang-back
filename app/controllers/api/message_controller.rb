class Api::MessageController < Api::ApiController
  # before_action :get_data, only: [:index, :test]
  def index
    # content = render_to_string(:template => 'month_payment/index.html', layout: false)
    # content = File.read(File.join('log/test.md'))
    # current_user.messages.create(
    #   title: '账单',
    #   target_id: 1,
    #   target_type: 0,
    #   content: content,
    #   content_type: 'md',
    #   page_url: '/pages/message/message_detail'
    # )
    @messages = current_user.messages.order('created_at desc')
  end

  def show
    @message = current_user.messages.find_by_id(params[:id])
    @message.update_attribute(:already_read, 1) if @message.already_read == 0
  end
  
  def test
    render 'month_payment/index.html'
  end

  def get_data
    last_month = (Time.now - 1.month).beginning_of_month
    @statements = current_user.statements.where(year: last_month.year, month: last_month.month)
    @prev_statements = current_user.statements.where(year: (last_month - 1.month).year, month: (last_month - 1.month).month)
    # 总览的数据
    # 当前收支
    @expend_count = @statements.expend.sum(:amount)
    @income_count = @statements.income.sum(:amount)
    @afford_count = @statements.joins(:asset).where("assets.type = 'debt'").sum(:amount)
    @surplus = @income_count - @expend_count
    @total_asset = @expend_count + @income_count + @afford_count + @surplus
    # 同期收支
    @prev_expend_count = @prev_statements.expend.sum(:amount)
    @prev_income_count = @prev_statements.income.sum(:amount)
    @prev_afford_count = @prev_statements.joins(:asset).where("assets.type = 'debt'").sum(:amount)
    @prev_surplus = @prev_income_count - @prev_expend_count
    
    # 消费类型排行前10
    @categories_order_10 = @statements.expend
                             .joins("inner join `categories` as c1 on `c1`.id = `statements`.category_id")
                             .joins("inner join `categories` as c2 on `c2`.id = `c1`.parent_id")
                             .group('c2.id')
                             .select('sum(`statements`.amount) as amount_sum, c2.name')
                             .order('amount_sum desc')

    # 单笔消费排行前10
    @expend_order_10 = @statements.expend.includes(:category).order('amount desc').limit(10)

    # 消费最多的一天
    expend_most_day = @statements.expend.group(:day).select('`statements`.*, sum(`statements`.amount) as day_count').order('day_count desc').first
    @expend_most_day = @statements.where(year: expend_most_day.year, month: expend_most_day.month, day: expend_most_day.day).order('amount desc')

    # 支出最大的一笔
    @most_expend_obj = @statements.expend.maximum(:amount)

    # 支出类型使用频率
    @category_frequent = @statements.expend.joins(:category).group(:category_id).having('count >= 3').select('count(`statements`.id) as count, `categories`.name as category_name').order('count desc')

    # 转账情况
    @assets_logs = current_user.asset_logs.where('created_at >= ? and created_at <= ?', last_month.beginning_of_day, Time.now.beginning_of_month.beginning_of_day).order('amount desc')

    # 有备注的消费
    @has_remark_sts = @statements.expend.where("description is not null and description != ''").order('created_at asc')

    # 消费最多的一周
    @week_sts = @statements.order('amount desc').group_by(&:week)
    @week_sts = @week_sts.map do |week_number, statements|
      {
        amount: @statements.expend.where("week(created_at, 1) = ?", week_number).sum(:amount),
        statements: statements
      }
    end
    @week_sts = @week_sts.sort_by{|s| s[:amount] }.reverse.first

    # 预算列表
    @budgets = current_user.categories.where("type = 'expend' and budget != 0 and parent_id != 0")

  end

end
