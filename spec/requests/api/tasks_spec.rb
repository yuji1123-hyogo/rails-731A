require 'rails_helper'

RSpec.describe 'Api::Tasks', type: :request do
  # factoryでユーザーを作成
  let(:user) { create(:user) }
  # factoryでプロジェクトを作成
  let(:project) { create(:project, user: user) }
  # factoryでタスクを作成
  let!(:task) { create(:task, project: project) }
  # JWTトークンを作成
  let(:token) { JwtService.encode(user_id: user.id) }
  # ヘッダーを作成
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }

  # GET /api/tasks
  describe 'GET /api/tasks' do
    # 認証済みユーザーの場合
    context '認証済みユーザーの場合' do
      it 'タスク一覧を返す' do
        get '/api/tasks', headers: headers
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['tasks']).to be_an(Array)
        expect(json_response['total_count']).to be_present
      end

      it '検索パラメータでフィルタリングできる' do
        get '/api/tasks', params: { search: task.name }, headers: headers
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['tasks'].size).to be > 0
      end
    end

    describe 'POST /api/tasks' do
      let(:valid_params) do
        {
          task: {
            name: '新しいタスク',
            description: 'テスト用タスク',
            status: 'pending',
            due_date: 1.week.from_now,
            project_id: project.id
          }
        }
      end

      context '認証済みで有効なパラメータの場合' do
        it 'タスクを作成できる' do
          expect do
            post '/api/tasks', params: valid_params, headers: headers
          end.to change(Task, :count).by(1)

          expect(response).to have_http_status(:created)
          json_response = JSON.parse(response.body)
          expect(json_response['name']).to eq('新しいタスク')
        end
      end
    end
  end

  describe 'GET /api/tasks/:id' do
    context '自分のタスクの場合' do
      it 'タスク詳細を返す' do
        get "/api/tasks/#{task.id}", headers: headers

        expect(response).to have_http_status(:ok)

        json_response = JSON.parse(response.body)
        expect(json_response['id']).to eq(task.id)
      end
    end
  end
end
