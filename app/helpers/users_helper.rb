module UsersHelper

  # Used at app/views/users/show.html.erb
  def gravatar_for(user, options = { size: 80})
    if user.email.include? '@stargate.gov'
      img_name = user.email.split('@').first
      image_tag(img_name + '.jpg', alt:user.name, width: options[:size])
    else
      # Creates an id based in the email
      gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
      size = options[:size]
      # Get the image based on the generated id (if it exists)
      gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
      # Creates image tag
      image_tag(gravatar_url, alt: user.name, class: "gravatar")
    end
  end

end
