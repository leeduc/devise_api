json.set! :id, static_page.id
json.set! :user_id, static_page.user_id
json.set! :slug, static_page.slug
json.set! :title, static_page.title
json.set! :description, static_page.description
json.set! :content, static_page.content
json.set! :created_at, static_page.created_at
json.set! :updated_at, static_page.updated_at
json.set! :user, static_page.user, partial: 'partials/user_detail', as: :user if static_page.user.present?
