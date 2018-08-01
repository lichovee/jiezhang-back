class HomeController < ActionController::Base
  def index
    render json: { msg: 'Welcome to JieZhang' }
  end
end
