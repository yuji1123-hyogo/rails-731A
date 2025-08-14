class Api::TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: %i[show update destroy]

  def index
    result = TaskSearchService.new(current_user, search_params).call

    render json: {
      # serializerを導入するまで簡易的な方法でフロントに返すフィールドを絞り込みい
      tasks: result[:tasks].map { |task| task_json(task) },
      total_count: result[:total_count],
      search_params: result[:search_params]
    }
  end

  def show
    render json: task_json(@task)
  end

  def create
    project = current_user.projects.find(task_params[:project_id])
    # paramsから特定のフィールドのみ取り除きたい場合
    task = project.tasks.build(task_params.except(:project_id))

    if task.save
      render json: task_json(task), status: :created
    else
      render json: { errors: task.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @task.update(task_params.expect(:project_id))
      render json: task_json(@task)
    else
      render json: { errors: @task.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy
    render json: { message: 'タスクを削除しました' }
  end

  # 認証チェック & current_userの取得
  def authenticate_user!
    # 今回はcookieを使わずトークンをやり取りする
    # レスポンスではbodyにトークンを含めて返し、リクエストではヘッダーにトークンを入れて送られてくる
    header = request.headers['Authorization']
    # bearer <token> の <token>の部分だけを抽出
    header = header.split.last if header
    # 検証に失敗した場合のdecodeの結果はnil
    decoded = JwtService.decode(header)
    @current_user = User.find(decoded[:user_id]) if decoded
    # 認証エラー時のステータスはunauthorized
  rescue ActiveRecord::RecordNotFound
    render json: { error: '認証が必要です' }, status: :unauthorized
  end

  # @current_userだけでもほかのアクションと共有は可能である
  # ただ、インスタンス変数@current_userに直接アクセスするような方法はオブジェクト指向プログラミング的に良くないらしい
  # current_userなどアクション間でインスタンス変数を共有したい場合はattr_readerに設定しよう
  attr_reader :current_user

  def set_task
    # pluckは特定のカラムを配列として取得するメソッド
    user_project_ids = current_user.projects.pluck(:id)
    # アクセス権限の制御(ユーザー本人のタスクにしかアクセスできないようにしている)
    # タスクとユーザーはタスク-プロジェクト-ユーザーのようにプロジェクトを挟んで関連している
    # current_userのproject一覧を取得　⇒ project一覧の中からparams[:id]に一致するtaskを探す
    @task = Task.joins(:project).where(projects: { id: user_project_ids }).find(params[:id])
    # ちなみによりRailsらしく書くためには
    # Userモデルでhas_many :tasks, through::projects
    # コントローラーで@task=current_user.tasks.find()
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'タスク見つかりません' }, status: :not_found
  end

  def task_params
    params.require(:task).permit(:name, :description, :status, :due_date, :project_id)
  end

  def search_params
    params.permit(:search, :status, :project_id, :sort_by)
  end

  def task_json(task)
    {
      id: task.id,
      name: task.name,
      description: task.description,
      status: task.status,
      due_date: task.due_date,
      project: {
        id: task.project.id,
        name: task.project.attribute_names
      },
      created_at: task.created_at,
      updated_at: task.updated_at
    }
  end
end
