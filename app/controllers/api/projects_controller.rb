class Api::ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: %i[show update destroy]

  # プロジェクト一覧
  def index
    projects = current_user.projects
    render json: projects
  end

  # プロジェクト詳細
  def show
    render json: @project
  end

  # プロジェクト作成
  def create
    project = @current_user.projects.build(project_params)

    if project.save
      render json: project, status: :created
    else
      render json: { errors: project.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  # プロジェクト更新
  def update
    if @project.update(project_params)
      render json: @project
    else
      render json: { errors: @project.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  # プロジェクト削除
  def destroy
    @project.destroy
    render json: { message: 'プロジェクトを削除しました' }
  end

  private

  # JWT認証チェック
  def authenticate_user!
    header = request.headers['Authorization']
    header = header.split(' ').last if header

    decoded = JwtService.decode(header)
    @current_user = User.find(decoded[:user_id]) if decoded
  rescue ActiveRecord::RecordNotFound
    render json: { error: '認証が必要です' }, status: :unauthorized
  end

  attr_reader :current_user

  # 自分のプロジェクトのみアクセス可能
  def set_project
    @project = current_user.projects.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'プロジェクトが見つかりません' }, status: :not_found
  end

  def project_params
    params.require(:project).permit(:name, :description)
  end
end
