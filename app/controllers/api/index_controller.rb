class Api::IndexController < Api::ApiController
  
  def index
    @statements = current_user.statements
    @statements, @surplus = StatementsFilterService.new(current_user, @statements, params).execute
    if params[:scope] == 'year' || params[:scope] == 'month'
      return render 'api/index/year'
    end
    return render json: { status: 405, msg: '没有更多啦' } if @statements.blank?
    @statements = Kaminari.paginate_array(@statements).page(params[:page]).per(20)
    @statements.sort_by!(&:created_at).reverse!
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