module ApplicationHelper
  def resource_class
    User
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def embedded_svg filename, options={}
    file = File.read(Rails.root.join('app', 'assets', 'images', 'svg', filename))
    doc = Nokogiri::HTML::DocumentFragment.parse file
    svg = doc.at_css 'svg'
    if options[:class].present?
    svg['class'] = options[:class]
    end
    doc.to_html.html_safe
  end

  def user_sex
    if current_user.sex == "male"
      @sex = "男子"
    else
      @sex = "女子"
    end
  end
end
