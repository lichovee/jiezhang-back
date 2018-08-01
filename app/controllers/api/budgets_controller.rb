class Api::BudgetsController < Api::ApiController
  
  def index
    all_budget = current_user.budget
    used = current_user.statements.where('type = ? and year = ? and month = ?', 'expend', Time.now.year, Time.now.month).sum(:amount)
    
    render json: {
      source_amount: all_budget,
      amount: all_budget == 0 ? '未设置' : money_format(all_budget),
      used: money_format(used), # 已用
      surplus: all_budget == 0 ? 0 : money_format(all_budget - used) # 可用
    }
  end

  def parent
    categories = current_user.categories.where("type = 'expend' and parent_id = 0")
    categories = categories.map do |c|
      ids = [c.id] + current_user.categories.where('parent_id = ?', c.id).pluck(:id)
      # 当月此分类共消费
      ids = [c.id] + current_user.categories.where('parent_id = ?', c.id).pluck(:id)
      used_amount = current_user.statements.where(year: Time.now.year, month: Time.now.month, category_id: ids).sum(:amount)

      use_percent = (used_amount * 100 / c.budget).to_i rescue 0
      use_percent = use_percent > 100 ? 100 : use_percent
      surplus_percent = 100 - use_percent
      {
        id: c.id,
        name: c.name,
        icon_path: c.icon_url,
        source_amount: c.budget,
        amount: money_format(c.budget.zero? ? '未设置' : c.budget),
        surplus: money_format(c.budget.zero? ? 0 : c.budget - used_amount), # 余额
        use_percent: use_percent,
        surplus_percent: surplus_percent,
      }
    end
    render json: categories
  end

  def show
    category = current_user.categories.find_by_id(params[:id])
    childs = current_user.categories.where('parent_id = ?', category.id)

    # 当月此分类共消费
    ids = [category.id] + current_user.categories.where('parent_id = ?', category.id).pluck(:id)

    # 此处有bug,收入与支出应分开计算
    used_amount = current_user.statements.where(year: Time.now.year, month: Time.now.month, category_id: ids).sum(:amount)

    use_percent = (used_amount * 100 / category.budget).to_i rescue 0
    use_percent = use_percent > 100 ? 100 : use_percent
    surplus_percent = 100 - use_percent
    
    res = {
      root: {
        id: category.id,
        name: category.name,
        icon_path: category.icon_url,
        source_amount: category.budget,
        used_amount: money_format(used_amount),
        amount: money_format(category.budget),
        surplus: money_format(category.budget.zero? ? 0 : category.budget - used_amount), # 余额
        use_percent: use_percent,
        surplus_percent: surplus_percent,
      },
      childs: childs.map do |c|
        used_amount = current_user.statements.where(category_id: c.id, year: Time.now.year, month: Time.now.month).sum(:amount)
        use_percent = (used_amount * 100 / c.budget).to_i rescue 0
        use_percent = use_percent > 100 ? 100 : use_percent
        surplus_percent = 100 - use_percent
        {
          id: c.id,
          name: c.name,
          icon_path: c.icon_url,
          source_amount: c.budget,
          amount: money_format(c.budget),
          surplus: money_format(c.budget.zero? ? 0 : c.budget - used_amount), # 余额
          use_percent: use_percent,
          surplus_percent: surplus_percent,
        }
      end
    }
    render json: res
  end

  # 设置分类预算
  def update
    type = params[:type]
    amount = params[:amount].to_f
    category_id = params[:category_id].to_i
    if type == 'user'
      # 设置总预算
      category_amount = current_user.categories.where('parent_id = 0').sum(:budget)
      if amount >= category_amount
        current_user.update_attribute(:budget, amount)
      else
        return render json: { status: 500, msg: '根预算不能少于一级预算总和' }
      end
    else
      # 设置一级/二级预算
      category = current_user.categories.find_by(id: category_id)
      return render json: { status: 404, msg: '无效的分类' } if category.blank?
      
      # 一级分类
      if category.is_parent?
        child_category_amount = current_user.categories.where(parent_id: category.id).sum(:budget)
        if amount < child_category_amount
          return render json: { status: 500, msg: '一级分类预算不能少于二级分类的总和' }
        end
      else
      # 二级分类
        parent_category = current_user.categories.find_by(id: category.parent_id)
        if parent_category.present? && amount > parent_category.budget
          parent_category.update_attributes!(budget: amount)
        end
      end
      category.update_attributes!(budget: amount)
      user_budget_amount = current_user.categories.where('parent_id = 0').sum(:budget)
      current_user.update_attribute(:budget, user_budget_amount)
    end

    render json: { status: 200 }
  end
end
