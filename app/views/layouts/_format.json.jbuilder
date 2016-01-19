if object.version.present?
  json.version object.version
else
  json.version "1.0"
end

if object.errors.present?
  json.status "error"
  if object.errors.kind_of? String
    json.errors object.errors
  # elsif object.errors.count == 1
  #   json.errors object.errors.first.join(' ')
  else
    json.errors object.errors
  end

  if object.message.present?
    json.message object.message
  end
else
  json.status "success"
  if object.links.present?
    json.links object.links
  else
    json.links Hash.new(
      :self => {
        :link => request.original_url,
        :type => request.format.to_s
      }
    ).default
  end

  if object.meta.present?
    json.meta object.meta
  else
    json.meta Hash.new
  end

  if object.entities.present?
    json.entities object.entities
  else
    json.entities []
  end

  if object.linked.present?
    json.linked object.linked
  else
    json.linked Hash.new
  end
end
