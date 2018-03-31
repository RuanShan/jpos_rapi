Rails.application.config.action_cable.log_tags = [
  -> request { request.env['user_id'] || "no-account" },
  :action_cable,
  -> request { request.uuid }
]
