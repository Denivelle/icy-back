# frozen_string_literal: true

require 'dry/monads'

class ApplicationService
  include Dry::Monads[:result, :do, :maybe, :try]

  # - Class methods
  class << self
    def call(...)
      new.call(...)
    end
  end
end
