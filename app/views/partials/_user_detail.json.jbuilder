json.set! :id, user.id
json.set! :email, user.email
json.set! :first_name, user.first_name
json.set! :last_name, user.last_name
json.set! :createdAt, user.created_at
json.set! :updatedAt, user.updated_at
json.set! :token, user.token if user.token.present?
