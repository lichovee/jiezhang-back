class Api::SuperStatementsController < Api::ApiController

  def filter
		@statements = current_user.statements
		@years = @statements.group('year').order('year desc').pluck(:year)
		@months = @statements.group('month').order('month desc').pluck(:month)
		@categories = current_user.categories.parent_list
		@assets = current_user.assets.parent_list
  end
  
  def time
    months = SuperStatementsService.new(current_user, params).super_months
    render_success data: months
  end

  def list
    statements = SuperStatementsService.new(current_user, params).list
    render_success data: statements
  end

end