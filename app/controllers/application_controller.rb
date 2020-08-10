class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :handle_error

  private

  def handle_error(error)
    render_errors([error.to_s], :not_found)
  end

  def render_errors(errors, status)
    render json: { errors: errors }, status: status
  end
end
