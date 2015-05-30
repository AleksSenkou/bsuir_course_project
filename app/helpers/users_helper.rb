module UsersHelper
  def gravatar_for(user, size = 100 )
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    gravatar_url = "http://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag gravatar_url, alt: user.name
  end

  def user_signup_with_provider?
    current_user.signup_with_provider
  end

  def admin?
    if user_signed_in? then current_user.admin?
    else return false
    end
  end
end
