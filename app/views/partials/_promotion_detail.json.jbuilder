json.set! :id, promotion.id
json.set! :code, promotion.code
json.set! :user_id, promotion.user_id
if promotion.user.present?
  json.set! :user, promotion.user, partial: 'partials/user_detail', as: :user
end
json.set! :value, promotion.value
json.set! :state, check_expried(promotion)
json.set! :started_at, promotion.started_at
json.set! :end_at, promotion.end_at
