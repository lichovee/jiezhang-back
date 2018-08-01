module Wechat
  require "openssl"
  require "base64"
  require "json"
  class Crypt

    #"openId"=>"xxx"
    #"nickName"=>"youngiii"
    #"gender"=>1
    #"language"=>"zh_CN"
    #"city"=>"Shenzhen"
    #"province"=>"Guangdong"
    #"country"=>"China"
    #"avatarUrl"=>"0"
    #"watermark"=>{"timestamp"=>1518411465, "appid"=>"xxx"}}
    def self.decrypt(session_key, encrypted_data, iv)
      session_key = Base64.decode64(session_key)
      encrypted_data= Base64.decode64(encrypted_data)
      iv = Base64.decode64(iv)
      cipher = OpenSSL::Cipher::AES128.new(:CBC)
      cipher.decrypt
      cipher.key = session_key
      cipher.iv = iv
      decrypted = JSON.parse(cipher.update(encrypted_data) + cipher.final)
      raise('Invalid App Object') if decrypted['watermark']['appid'] != Settings.wechat.appid
      decrypted
    end
    
  end
end