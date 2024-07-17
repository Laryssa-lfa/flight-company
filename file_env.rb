# frozen_string_literal: true

# Class responsible for assembling ENVs
class FileEnv
  def initialize
    @envs = {}
  end

  def self.execute
    new.execute
  end

  def execute
    file_envs
  end

  private

  def file_envs
    @envs = File.read('.env').split(%r{=|\n})
    Hash[*@envs]
  end
end
