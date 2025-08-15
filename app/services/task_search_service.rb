class TaskSearchService
  def initialize(user, search_params = {})
    @user = user
    @search_params = search_params.to_h
    @search_params = ActiveSupport::HashWithIndifferentAccess.new(@search_params)
  end

  # ユーザーと検索条件を受け取ってタスクを返す
  # ユーザーのタスクをすべて取得したのち検索条件に従ってタスクを絞り込む
  def call
    return { tasks: [], total_count: 0 } unless @user

    tasks = base_scope
    tasks = apply_filters(tasks)
    tasks = apply_sorting(tasks)
    {
      tasks: tasks,
      total_count: tasks.count,
      search_params: @search_params
    }
  end

  private

  def base_scope
    # タスクの検索
    # user.tasksでもできる
    # user-project-taskといった関連でuser-taskの間接的なアソシエーションを定義していない場合以下のようになる
    @user.projects.joins(:tasks).includes(:tasks).flat_map(&:tasks)
  end

  def apply_filters(tasks)
    tasks = filter_by_search(tasks)
    tasks = filter_by_status(tasks)
    filter_by_project(tasks)
  end

  def filter_by_search(tasks)
    return tasks if @search_params[:search].blank?

    query = @search_params[:search]
    # selectはrubyの配列のメソッド。すでに取得済みの配列の中から条件に合う要素を抽出する。
    # javascriptでいうところのfilterメソッドに対応している
    tasks.select { |task| task.name.downcase.include?(query.downcase) }
  end

  def filter_by_status(tasks)
    return tasks if @search_params[:status].blank?

    tasks.select { |task| task.status == @search_params[:status] }
  end

  def filter_by_project(tasks)
    return tasks if @search_params[:project_id].blank?

    tasks.select { |task| task.project_id == @search_params }
  end

  def apply_sorting(tasks)
    case @search_params[:sort_by]
    when 'due_date'
      tasks.sort_by(&:due_date)
    when 'status'
      tasks.sort_by(&:status)
    else
      tasks.sort_by(&:created_at).reverse
    end
  end
end
