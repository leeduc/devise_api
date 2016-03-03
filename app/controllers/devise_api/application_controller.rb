module DeviseApi
  class ApplicationController < DeviseController
    include DeviseApi::Concerns::TokenHelper
  end
end
