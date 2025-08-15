require 'rails_helper'

RSpec.describe 'Api::Auth', type: :request do
  # POST /api/auth/registerのテスト
  describe 'POST /api/auth/register' do
    # フォームの入力データを準備
    let(:valid_params) do
      {
        user: {
          name: 'テストユーザー',
          email: 'test@example.com',
          password: 'password123'
        }
      }
    end

    # 有効なパラメータの場合のテスト
    context '有効なパラメータの場合' do
      it 'ユーザーを作成してトークンを返す' do
        post '/api/auth/register', params: valid_params

        # request specのテスト観点：httpステータス
        expect(response).to have_http_status(:created)

        # request specのテスト観点：レスポンスのJSONデータ
        json_response = JSON.parse(response.body)
        # message:'ユーザー登録が完了しました'　が含まれる
        expect(json_response['message']).to eq('ユーザー登録が完了しました')
        # tokenが含まれる
        expect(json_response['token']).to be_present
        expect(json_response['user']['email']).to eq('test@example.com')
      end
    end
  end
end
