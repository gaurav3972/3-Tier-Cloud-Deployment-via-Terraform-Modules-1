output "web_instance_ids" {
  value = module.web.instance_ids
}

output "app_instance_ids" {
  value = module.app.instance_ids
}

output "db_endpoint" {
  value = module.db.db_endpoint
}
