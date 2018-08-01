class Api::LoginController < ApplicationController

	# 获取 openid 存储并返回 key
	def check_openid
		code = request.headers['X-WX-Code']
		count = 0

		session = wx_get_session_key(code)
		session = JSON.parse(session)
		if session.blank? || session['session_key'].blank? || session['openid'].blank?
			return render json: { status: 401, msg: '登录失败' }
		end

		begin
			count = count + 1
			openid = session['openid']
			session_key = session['session_key']
			user = User.find_by_openid(openid)
			user = User.new(openid: openid, session_key: session_key) if user.blank?
			redis_v = Rails.cache.read(user.redis_session_key)
			if redis_v.present?
				return render json: { session: redis_v }
			end

			if user.present?
				third_session = Digest::SHA1.hexdigest("#{rand(9999)}#{session_key}#{rand(9999)}")
				user.third_session = third_session
				user.save!
				Rails.cache.write(user.redis_session_key, third_session, expires_in: 1.day)
				render json: { session: third_session }
			else
				render json: { status: 404, msg: '登录失败' }
			end
		rescue => ex
			retry if count < 3
			JieZhang::Logger.info "LoginController/check_openid: #{ex.message}"
			render json: { status: 500, msg: '登录失败' }
		end
	end
	
  # params: code
  # response: hash {  'session_key': '', 'openid': '' }
  def wx_get_session_key(code)
    uri = URI('https://api.weixin.qq.com/sns/jscode2session')
    params = { 
                appid: Settings.wechat.appid,
                secret: Settings.wechat.app_secret, 
                js_code: code, 
                grant_type: 'authorization_code' 
              }
    uri.query = URI.encode_www_form(params)
    resp = Net::HTTP.get_response(uri)
    if resp.is_a?(Net::HTTPSuccess) && !resp.body['errcode']
      return resp.body
    else
      raise("wx get session Fail #{resp.body}")
    end
  end

end
