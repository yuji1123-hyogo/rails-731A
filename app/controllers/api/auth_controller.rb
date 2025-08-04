class Api::AuthController < ApplicationController
  def register
    user = User.new(user_params)

    if user.save
      token = JwtService.encode(user_id: user.id)
      render json: {
        message: 'ユーザー登録が完了しました',
        token: token,
        user: { id: user.id, name: user.name, email: user.email }
      }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def login
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      token = JwtService.encode(user_id: user.id)
      render json: {
        message: 'ログインしました',
        token: token,
        user: { id: user.id, name: user.name, email: user.email }
      }
    else
      render json: { error: 'メールアドレスまたはパスワードが正しくありません' }, status: :unauthorised
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end
end
