json.title @message.title
json.content @message.content
json.time @message.created_at.strftime("%Y-%m-%d %H:%S")
json.content_type @message.content_type
json.msg_type @message.msg_type