class User < ActiveRecord::Base
  # for app localhost:3001@dev
  #SOUNDCLOUD_CLIENT_ID     = "fv3XJjs1YsmmjdeT90sDw"
  #SOUNDCLOUD_CLIENT_SECRET = "Qg3cIOCwP8WViwvtSN5FpiQkMjSMymUADB1pxkgGaw"
  # for app localhost:3001@live
  SOUNDCLOUD_CLIENT_ID     = "BXnNn9AjpkQVs8SMnri8g"
  SOUNDCLOUD_CLIENT_SECRET = "FlhLpivGUdRZMszLxlQ3w1Xl70hSMvH39ILze9748"
  
  def self.soundcloud_client(options={})
    options = {
      :client_id     => SOUNDCLOUD_CLIENT_ID,
      :client_secret => SOUNDCLOUD_CLIENT_SECRET,
  #    :site          => "soundcloud.dev" #TODO just testing
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
        :soundcloud_access_token  => @soundcloud_client.access_token,
        :soundcloud_refresh_token => @soundcloud_client.refresh_token,
        :soundcloud_expires_at    => @soundcloud_client.expires_at,
      })
    end
    
    client
  end
end
