# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  include ActiveModel::Validations

  primary_abstract_class
end
