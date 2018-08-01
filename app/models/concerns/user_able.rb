module UserAble
	extend ActiveSupport::Concern
	included do
		after_create :initialize_user
	end

	def initialize_user
		initialize_uuid
		initialize_assets
		initialize_expend_categories
		initialize_income_categories
  end

	private
	
	def initialize_uuid
		self.update_attributes(uid: self.id + 10000)
	end

	def initialize_assets
		asset_icon_path = '/images/asset'
		parents = [
			{
				name: '现金账户',
				icon: "coin-2.png"
			}, 
			{
				name: '虚拟账户',
				icon: "coin-4.png"
			}, 
			{
				name: '负债账户',
				icon: "justice-scale.png"
			}, 
			{
				name: '投资账户',
				icon: "graph.png"
			}
		]

    parent_ids = []
    parents.each do |hs|
      asset = Asset.create!(name: hs[:name], creator_id: self.id, icon_path: "#{asset_icon_path}/#{hs[:icon]}")
      parent_ids << asset.id
      UsersAsset.create(
				user_id: self.id,
				asset_id: asset.id
			)
    end

    parent_id = parent_ids.shift
		[{name: '现金', icon: "wallet-1.png"}, {name: '银行卡', icon: "credit-card-6.png"}].each do |hs|
			asset = Asset.create!( name: hs[:name], creator_id: self.id, icon_path: "#{asset_icon_path}/#{hs[:icon]}", parent_id: parent_id)
      UsersAsset.create(
				user_id: self.id,
				asset_id: asset.id
			)
    end
    
		parent_id = parent_ids.shift
		[{name: '支付宝', icon: '12.png'}, {name:'微信钱包',icon: '9.png'}].each do |hs|
			asset = Asset.create!( name: hs[:name], creator_id: self.id, icon_path: "#{asset_icon_path}/#{hs[:icon]}", parent_id: parent_id)
      UsersAsset.create(
				user_id: self.id,
				asset_id: asset.id
			)
    end
    
		parent_id = parent_ids.shift
		[{name: '蚂蚁花呗', icon: 'huabei.png'}, {name:'京东白条',icon: 'jdbaitiao.png'}, {name: '信用卡', icon: 'credit-card-1.png'}].each do |hs|
			asset = Asset.create!( name: hs[:name], creator_id: self.id, icon_path: "#{asset_icon_path}/#{hs[:icon]}", parent_id: parent_id, type: 'debt')
      UsersAsset.create(
				user_id: self.id,
				asset_id: asset.id
			)
		end

		parent_id = parent_ids.shift
		[{name: '基金账户', icon: '1.png'}, {name:'余额宝',icon: 'yuebao.png'}, {name: '股票账户', icon: 'graph-3.png'}].each do |hs|
			asset = Asset.create!( name: hs[:name], creator_id: self.id, icon_path: "#{asset_icon_path}/#{hs[:icon]}", parent_id: parent_id)
      UsersAsset.create(
				user_id: self.id,
				asset_id: asset.id
			)
    end
  end
	
	def initialize_expend_categories
		category_icon_path = '/images/category'
		expend_parents = [
			{
				name: '伙食餐饮',
				icon: "035-meal.png"
			}, 
			{
				name: '休闲娱乐',
				icon: "032-game-pad.png"
			}, 
			{
				name: '行车交通',
				icon: "031-traffic-sign.png"
			}, 
			{
				name: '美容护肤',
				icon: "028-fashion.png"
			},
			{
				name: '衣服饰品',
				icon: "018-tshirt.png"
			},
			{
				name: '交流通讯',
				icon: "011-smartphone.png"
			},
			{
				name: '学习进修',
				icon: "007-laptop.png"
			},
			{
				name: '居家物业',
				icon: "001-house.png"
			},
			{
				name: '医疗保障',
				icon: "022-hospital-1.png"
			}
		]

		expend_ids = []
		expend_parents.each_with_index do |category, index|
			category = self.categories.create(name: category[:name], icon_path: "#{category_icon_path}/#{category[:icon]}", type: 'expend', order: index)
			expend_ids << category.id
		end

		parent_id = expend_ids.shift
		[
			{name: '一日三餐', icon_path: "#{category_icon_path}/004-diet.png", parent_id: parent_id, type: 'expend'},
			{name: '下午茶', icon_path: "#{category_icon_path}/013-coffee.png", parent_id: parent_id, type: 'expend'},
			{name: '宵夜', icon_path: "#{category_icon_path}/007-kebab.png", parent_id: parent_id, type: 'expend'},
			{name: '做饭食材', icon_path: "#{category_icon_path}/004-diet.png", parent_id: parent_id, type: 'expend'},
			{name: '商场购物', icon_path: "#{category_icon_path}/026-shopping-bag.png", parent_id: parent_id, type: 'expend'},
			{name: '水果', icon_path: "#{category_icon_path}/fruit.png", parent_id: parent_id, type: 'expend'},
			{name: '茶水', icon_path: "#{category_icon_path}/10.png", parent_id: parent_id, type: 'expend'},
			{name: '饮料', icon_path: "#{category_icon_path}/061-water.png", parent_id: parent_id, type: 'expend'},
			{name: '烟酒', icon_path: "#{category_icon_path}/060-pint.png", parent_id: parent_id, type: 'expend'},
			{name: '聚会消费', icon_path: "#{category_icon_path}/010-beer-1.png", parent_id: parent_id, type: 'expend'},
		].each{|hs| self.categories.create(hs) }
		
		parent_id = expend_ids.shift
		[
			{name: '运动健身', icon_path: "#{category_icon_path}/035-fitness.png", parent_id: parent_id, type: 'expend'},
			{name: '电影', icon_path: "#{category_icon_path}/006-cinema.png", parent_id: parent_id, type: 'expend'},
			{name: '电子产品', icon_path: "#{category_icon_path}/043-gaming.png", parent_id: parent_id, type: 'expend'},
			{name: '游戏', icon_path: "#{category_icon_path}/041-gamepad.png", parent_id: parent_id, type: 'expend'}
		].each{|hs| self.categories.create(hs) }

		parent_id = expend_ids.shift
		[
			{name: '公交', icon_path: "#{category_icon_path}/038-school-bus.png", parent_id: parent_id, type: 'expend'},
			{name: '地铁', icon_path: "#{category_icon_path}/a.png", parent_id: parent_id, type: 'expend'},
			{name: '打车租车', icon_path: "#{category_icon_path}/chuzuche.png", parent_id: parent_id, type: 'expend'},
		].each{|hs| self.categories.create(hs) }

		parent_id = expend_ids.shift
		[
			{name: '化妆品', icon_path: "#{category_icon_path}/makeup.png", parent_id: parent_id, type: 'expend'},
			{name: '面膜', icon_path: "#{category_icon_path}/054-mask.png", parent_id: parent_id, type: 'expend'},
			{name: '口红', icon_path: "#{category_icon_path}/056-lipstick.png", parent_id: parent_id, type: 'expend'},
			{name: '香水', icon_path: "#{category_icon_path}/perfume.png", parent_id: parent_id, type: 'expend'},
			{name: '指甲', icon_path: "#{category_icon_path}/053-cologne.png", parent_id: parent_id, type: 'expend'},
		].each{|hs| self.categories.create(hs) }

		parent_id = expend_ids.shift
		[
			{name: '衣服', icon_path: "#{category_icon_path}/031-jacket.png", parent_id: parent_id, type: 'expend'},
			{name: '裤子', icon_path: "#{category_icon_path}/029-jeans.png", parent_id: parent_id, type: 'expend'},
			{name: '鞋子', icon_path: "#{category_icon_path}/027-jogging.png", parent_id: parent_id, type: 'expend'},
			{name: '包包', icon_path: "#{category_icon_path}/handbag.png", parent_id: parent_id, type: 'expend'}
		].each{|hs| self.categories.create(hs) }

		parent_id = expend_ids.shift
		[
			{name: '手机费', icon_path: "#{category_icon_path}/037-smartphone.png", parent_id: parent_id, type: 'expend'},
			{name: '上网费', icon_path: "#{category_icon_path}/036-laptop.png", parent_id: parent_id, type: 'expend'},
		].each{|hs| self.categories.create(hs) }

		parent_id = expend_ids.shift
		[
			{name: '书籍费用', icon_path: "#{category_icon_path}/033-open-book.png", parent_id: parent_id, type: 'expend'},
			{name: '培训学习', icon_path: "#{category_icon_path}/diary.png", parent_id: parent_id, type: 'expend'}
		].each{|hs| self.categories.create(hs) }

		parent_id = expend_ids.shift
		[
			{name: '房租', icon_path: "#{category_icon_path}/hee.png", parent_id: parent_id, type: 'expend'},
			{name: '日常用品', icon_path: "#{category_icon_path}/towel.png", parent_id: parent_id, type: 'expend'}
		].each{|hs| self.categories.create(hs) }

		parent_id = expend_ids.shift
		[
			{name: '药品', icon_path: "#{category_icon_path}/jiaonang.png", parent_id: parent_id, type: 'expend'},
			{name: '就诊', icon_path: "#{category_icon_path}/021-emergency-kit.png", parent_id: parent_id, type: 'expend'},
			{name: '保健', icon_path: "#{category_icon_path}/024-hospital.png", parent_id: parent_id, type: 'expend'}
		].each{|hs| self.categories.create(hs) }
	end

	def initialize_income_categories
		category_icon_path = '/images/category'
		income_parents = %w(职业收入 其他收入)
		income_ids = []
		income_parents.each_with_index do |name, index|
			category = self.categories.create(name: name, type: 'income', order: index)
			income_ids << category.id
		end

		parent_id = income_ids.shift
		[
			{name: '工资收入', icon_path: "#{category_icon_path}/cash.png", parent_id: parent_id, type: 'income'},
			{name: '利息收入', icon_path: "#{category_icon_path}/bank.png", parent_id: parent_id, type: 'income'},
			{name: '加班收入', icon_path: "#{category_icon_path}/jiaban.png", parent_id: parent_id, type: 'income'},
			{name: '投资收入', icon_path: "#{category_icon_path}/money-bag.png", parent_id: parent_id, type: 'income'}
		].each{|hs| self.categories.create(hs) }

		parent_id = income_ids.shift
		[
			{name: '中奖收入', icon_path: "#{category_icon_path}/caipiao.png", parent_id: parent_id, type: 'income'},
			{name: '意外来钱', icon_path: "#{category_icon_path}/chuangyi.png", parent_id: parent_id, type: 'income'},
			{name: '红包收入', icon_path: "#{category_icon_path}/hongbao.png", parent_id: parent_id, type: 'income'},
		].each{|hs| self.categories.create(hs) }
	end

end