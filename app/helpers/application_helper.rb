module ApplicationHelper

  # Returns the full title on a per-page basis, the function is used app/views/layouts/application.html.erb
  def full_title(page_title='')

    base_title = 'Ruby on Rails Tutorial Sample App'

    # check if page_title is empty
    if page_title.empty?
      # If empty return base_title
      base_title
    else
      # Else return page_title in combination with base_title
      page_title  + ' | ' + base_title
    end

  end

end
