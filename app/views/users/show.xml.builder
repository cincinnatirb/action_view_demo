xml.user do
  @user.attributes.each { |k, v| xml.tag!(k, v) }
  xml.url(user_url(@user, format: :xml))
end
