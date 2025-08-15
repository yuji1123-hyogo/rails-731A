# spec/rails_helper.rb
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'rspec/rails'

# SimpleCov設定（改善版）
require 'simplecov'
SimpleCov.start 'rails' do
  add_filter '/bin/'
  add_filter '/db/'
  add_filter '/spec/'
  add_filter '/config/'
  add_filter '/vendor/'

  # カバレッジ目標設定
  minimum_coverage 50

  # 出力形式の改善
  formatter SimpleCov::Formatter::MultiFormatter.new([
                                                       SimpleCov::Formatter::HTMLFormatter
                                                     ])
end

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

RSpec.configure do |config|
  # 基本設定
  config.fixture_path = Rails.root.join('spec/fixtures')
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  # FactoryBot設定
  config.include FactoryBot::Syntax::Methods

  # DatabaseCleaner設定
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)

    # テスト開始時の情報表示
    puts "\n" + ('=' * 80)
    puts '🚀 RSpecテスト開始'
    puts "環境: #{Rails.env}"
    puts "Ruby: #{RUBY_VERSION}"
    puts "Rails: #{Rails.version}"
    puts '=' * 80
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end

  # テスト後のクリーンアップ
  config.after(:suite) do
    puts "\n📊 カバレッジレポートが coverage/index.html に生成されました"
    puts '🎉 すべてのテストが完了しました！'
  end

  # 警告を抑制
  config.before(:each) do
    allow(Rails.logger).to receive(:warn)
  end
end

# Shoulda Matchers設定
Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

# テストヘルパーメソッド
module TestHelpers
  def json_response
    JSON.parse(response.body)
  end

  def auth_headers(user)
    token = JwtService.encode(user_id: user.id)
    { 'Authorization' => "Bearer #{token}" }
  end
end

RSpec.configure do |config|
  config.include TestHelpers, type: :request
end
