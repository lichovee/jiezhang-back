class Feedback < ApplicationRecord
	self.inheritance_column = nil
	belongs_to :user
	validates_presence_of(:content, msg: '内容不能为空')
	
	FeatureType = 1
	BugType = 2
end
