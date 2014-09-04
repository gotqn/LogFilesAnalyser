module UsersHelper

  def avatar_url(user)
    if user.avatar_url.present?
      user.avatar_url
    else
      #default_url = "#{root_url}images/guest.png"
      default_url = 'https://raw.githubusercontent.com/railscasts/244-gravatar/master/grav/public/images/guest.png'
      gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
      "http://gravatar.com/avatar/#{gravatar_id}.png?s=48&d=#{CGI.escape(default_url)}"
    end
  end

end