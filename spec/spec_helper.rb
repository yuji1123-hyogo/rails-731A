# spec/spec_helper.rb
RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
    expectations.max_formatted_output_length = 200
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.filter_run_when_matching :focus
  config.example_status_persistence_file_path = 'spec/examples.txt'
  config.disable_monkey_patching!
  config.warnings = false # 警告を非表示

  # カラー出力設定
  config.color_mode = :automatic

  # 進捗表示の改善
  config.default_formatter = 'progress' if config.files_to_run.one?

  # パフォーマンス分析
  config.profile_examples = 10
  config.order = :random
  Kernel.srand config.seed

  # 失敗時の詳細表示
  config.failure_exit_code = 1

  # テスト結果の統計情報表示
  config.after(:suite) do
    puts "\n" + ('=' * 80)
    puts 'テスト実行完了！'
    puts '=' * 80
  end
end
