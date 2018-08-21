class Api::IndexController < Api::ApiController
  def index
    begin_week = Time.now.beginning_of_week.beginning_of_day
    end_week = Time.now.end_of_week.end_of_day
    @statements = current_user.statements.includes(:category, :asset).where("created_at >= ? AND created_at <= ?", begin_week, end_week).order('created_at desc')
    return render json: { status: 405, msg: '没有更多啦' } if @statements.blank?
  end

  def header
    today = Time.now
    @user_statements = current_user.statements.includes(:category, :asset).order('statements.created_at desc')
    @today_statements = @user_statements.where("statements.type = 'expend' AND year = ? and month = ? and day = ?", today.year, today.month, today.day)
    @today_pay = @today_statements.sum(:amount)
    @month_pay = @user_statements.where("statements.type = 'expend' and year = ? and month = ?", today.year, today.month).sum(:amount)
  end

  def bill
    @statement = current_user.statements.find_by(id: params[:id])
    return render_404 unless @statement
  end
end