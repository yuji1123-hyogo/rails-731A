class JwtService
  SECRET_KEY = ENV.fetch('JWT_SECRET_KEY', nil)

  def self.encode(payload)
    payload[:exp] = 24.hours.from_now.to_i
    JWT.encode(payload, SECRET_KEY)
  end

  def self.decode(token)
    decoded = JWT.decode(token, SECRET_KEY)[0]
    ActiveSupport::HashWithIndifferentAccess.new(decoded)
  rescue JWT::DecodeError => e
    nil
  end
end
