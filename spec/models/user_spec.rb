require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーション' do
    subject { build(:user) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email) }
    it { is_expected.to have_secure_password }
  end

  describe 'アソシエーション' do
    it { is_expected.to have_many(:projects).dependent(:destroy) }
  end

  describe 'ファクトリー' do
    it '有効なファクトリーを持つ' do
      expect(build(:user)).to be_valid
    end
  end
end
