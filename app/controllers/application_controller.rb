class ApplicationController < ActionController::Base
  include ActionController::MimeResponds
  rescue_from ActionView::MissingTemplate do |exception|
    raise ActionController::RoutingError.new('Not Found')
  end
  rescue_from ActiveRecord::RecordNotFound, :with => :render_not_found
end
