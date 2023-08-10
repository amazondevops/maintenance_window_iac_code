#Configuring the maintenance window
resource "aws_ssm_maintenance_window" "install_window" {
  name     = var.name
  schedule = var.schedule
  duration = var.maintenance_window_duration
  cutoff   = var.maintenance_window_cutoff
}

#Assigning the targets using tag:PatchGroup for the maintenance window
resource "aws_ssm_maintenance_window_target" "target_install" {
  window_id     = aws_ssm_maintenance_window.install_window.id
  resource_type = "INSTANCE"
   targets {
    key    = var.window_target.key
    values = [var.window_target.values]
  }
}


#Assigning the RunCommandTask to the maintenance windoow -> AWS-InstallWindowsUpdates
resource "aws_ssm_maintenance_window_task" "task_install_patches" {
  window_id        = aws_ssm_maintenance_window.install_window.id
  task_type        = "RUN_COMMAND"
  task_arn         = "AWS-InstallWindowsUpdates"
  priority         = var.task_install_priority
  service_role_arn = var.service_role_arn
  max_concurrency  = var.max_concurrency
  max_errors       = var.max_errors

  targets {
    key    = "WindowTargetIds"
    values = aws_ssm_maintenance_window_target.target_install.*.id
  }

  task_invocation_parameters {
    run_command_parameters {
      parameter {
        name   = "Action"
        values = [var.operation_type]
      }

      output_s3_bucket     = var.s3_bucket_name
      output_s3_key_prefix = var.s3_bucket_prefix_install_logs

    # service_role_arn = var.role_arn_for_notification
    #   dynamic "notification_config" {
    #     for_each = var.enable_notification_install ? [1] : []
    #     content {
    #       notification_arn    = var.notification_arn
    #       notification_events = var.notification_events
    #       notification_type   = var.notification_type
    #     }
    #   }
    }
  }
}

output targets {
  value = aws_ssm_maintenance_window_target.target_install.*.id
}