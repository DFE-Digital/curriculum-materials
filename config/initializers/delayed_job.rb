Delayed::Worker.destroy_failed_jobs = false # Keep jobs for debugging
Delayed::Worker.max_run_time = 5.minutes
Delayed::Worker.sleep_delay = 15 # Look for new jobs every 15 seconds
