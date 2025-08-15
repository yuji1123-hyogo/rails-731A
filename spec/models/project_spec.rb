require 'rails_helper'

RSpec.describe Project, type: :model do
  describe 'バリデーション' do
    subject { build(:project) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:user_id) }
  end

  describe 'アソシエーション' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:tasks).dependent(:destroy) }
  end

  describe 'Searchable Concern' do
    let!(:project1) { create(:project, name: 'Webアプリ開発') }
    let!(:project2) { create(:project, name: 'モバイルアプリ') }

    it '名前で検索できる' do
      results = Project.search_by_name('Web')
      expect(results).to include(project1)
      expect(results).not_to include(project2)
    end

    it '空の検索文字列では全件返す' do
      results = Project.search_by_name('')
      expect(results.count).to eq(2)
    end
  end
end
