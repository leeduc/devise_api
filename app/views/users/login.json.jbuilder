json.partial! 'layouts/format', object: OpenStruct.new
@resource.token = @token
json.entities [@resource], partial: 'partials/user_detail', as: :user
