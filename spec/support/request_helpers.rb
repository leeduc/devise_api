module Requests
  module JsonHelpers
    def json(response)
      JSON.parse(response)
    end
  end
end
