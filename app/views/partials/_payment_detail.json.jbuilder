json.set! :id, payment.id
json.set! :user_id, payment.user_id
json.set! :booking_id, payment.booking_id
json.set! :listing_id, payment.listing_id
json.set! :user, payment.user, partial: 'partials/user_detail', as: :user
json.set! :booking, payment.booking,
          partial: 'partials/booking_detail', as: :booking
json.set! :listing, payment.listing,
          partial: 'partials/listing_detail', as: :listing
json.set! :price, payment.price
json.set! :purchase_date, payment.purchase_date
json.set! :started_at, payment.started_at
json.set! :end_at, payment.end_at
json.set! :created_at, payment.created_at
json.set! :updated_at, payment.updated_at
