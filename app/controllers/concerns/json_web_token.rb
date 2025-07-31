module JsonWebToken
  extend ActiveSupport::Concern

  private

  def jwt_encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, Rails.application.credentials[:secret_key_base])
  end

  def jwt_decode(token)
    decoded = JWT.decode(token, Rails.application.credentials[:secret_key_base])[0]
    ActiveSupport::HashWithIndifferentAccess.new decoded
  rescue JWT::DecodeError => e
    Rails.logger.error "JWT Decode Error: #{e.message}"
    nil
  end

  def authenticate_request
    token = extract_token_from_header
    return render_unauthorized unless token

    decode_and_find_user(token)
  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.error "User not found: #{e.message}"
    render_unauthorized
  rescue JWT::DecodeError => e
    Rails.logger.error "JWT Decode Error: #{e.message}"
    render_unauthorized
  end

  def current_user
    @current_user
  end

  def extract_token_from_header
    header = request.headers['Authorization']
    header&.split&.last
  end

  def decode_and_find_user(token)
    @decoded = jwt_decode(token)
    @current_user = User.find(@decoded[:user_id]) if @decoded
  end

  def render_unauthorized
    render json: { errors: 'Unauthorized' }, status: :unauthorized
  end
end
