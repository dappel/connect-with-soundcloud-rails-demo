class User < ActiveRecord::Base
  # Please don't use these keys.
  # You can register your own app: http://soundcloud.com/you/apps
  # http://soundcloud.com/you/apps/localhost-3001/edit
  #SOUNDCLOUD_CLIENT_ID     = "BXnNn9AjpkQVs8SMnri8g"
  #SOUNDCLOUD_CLIENT_SECRET = "FlhLpivGUdRZMszLxlQ3w1Xl70hSMvH39ILze9748"
  # http://soundcloud.com/you/apps/connect-with-soundcloud-rails-demo
  SOUNDCLOUD_CLIENT_ID     = "vkTWPNTmafS9UEsfOmeqQ"
  SOUNDCLOUD_CLIENT_SECRET = "2oXHSyfwAozLkuXsMmGnQFK7pGqwEJitSAL6PIng"

  def self.soundcloud_client(options={})
    options = {
      :client_id     => SOUNDCLOUD_CLIENT_ID,
      :client_secret => SOUNDCLOUD_CLIENT_SECRET,
    }.merge(options)

    Soundcloud.new(options)
  end
  
  
  def soundcloud_client(options={})
    options= {
      :expires_at    => soundcloud_expires_at,
      :access_token  => soundcloud_access_token,
      :refresh_token => soundcloud_refresh_token
    }.merge(options)
    
    client = self.class.soundcloud_client(options)
    
    # define a callback for successful token exchanges
    # this will make sure that new access_tokens are persisted once an existing 
    # access_token expired and a new one was retrieved from the soundcloud api
    client.on_exchange_token do
      self.update_attributes!({
        :soundcloud_access_token  => client.access_token,
        :soundcloud_refresh_token => client.refresh_token,
        :soundcloud_expires_at    => client.expires_at,
      })
    end
    
    client
  end
end
