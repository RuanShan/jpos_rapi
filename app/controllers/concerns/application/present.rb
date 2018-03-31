# rubocop:disable Style/ClassAndModuleChildren
module Application::Present

  # http://railscasts.com/episodes/287-presenters-from-scratch
  def present(object, klass = nil)
    klass ||= "#{object.class}Presenter".constantize
    klass.new(object, view_context)
  end

end
# rubocop:enable all
