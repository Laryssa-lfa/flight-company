# frozen_string_literal: true

module FixtureHelper
  def load_json_symbolized(path)
    JSON.parse(load_fixture_file(path), symbolize_names: true)
  end

  def load_fixture_file(path)
    full_path = Rails.root.join('spec/fixtures/', path)
    File.read(full_path)
  end
end
