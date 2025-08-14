module Searchable
  # taskモデルとprojectモデルで共通の検索機能を定義
  extend ActiveSupport::Concern

  class_methods do
    def search_by_name(query)
      return all if query.blank?

      where('name LIKE ?', "%#{query}%")
    end

    def search_by_fields(query, fields = [:name])
      return all if query.blank?

      conditions = fields.map { |field| "#{field} LIKE ?" }
      # 複数のカラムに対して同じキーワードで検索をかける
      where(conditions.join(' OR '), *([query] * fields.size))
    end
  end
end
