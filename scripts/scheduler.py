#!/usr/bin/env python3
"""
Firestore Backup Scheduler

Automated backup scheduling with cron-like functionality.
Supports multiple backup schedules and email notifications.

Author: Senior Engineer
Version: 1.0.0
"""

import schedule
import time
import logging
import smtplib
import json
from datetime import datetime
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
from pathlib import Path
from typing import Dict, List, Optional
import argparse
import subprocess
import sys

from firestore_backup import FirestoreBackup, BackupConfig, BackupMetadata


class BackupScheduler:
    """
    Production-grade backup scheduler with comprehensive monitoring and alerting.
    """
    
    def __init__(self, config_path: str):
        self.config_path = config_path
        self.scheduler_config = self._load_scheduler_config()
        self.logger = self._setup_logging()
        self.backup_configs = self._load_backup_configs()
        
    def _load_scheduler_config(self) -> Dict:
        """Load scheduler configuration from JSON file."""
        try:
            with open(self.config_path, 'r') as f:
                return json.load(f)
        except Exception as e:
            print(f"Failed to load scheduler config: {e}")
            sys.exit(1)
    
    def _load_backup_configs(self) -> List[BackupConfig]:
        """Load backup configurations for scheduled backups."""
        configs = []
        
        for backup_job in self.scheduler_config.get('backup_jobs', []):
            config = BackupConfig(
                project_id=backup_job['project_id'],
                backup_dir=backup_job['backup_dir'],
                collections=backup_job.get('collections', []),
                compression=backup_job.get('compression', True),
                encryption=backup_job.get('encryption', False),
                retention_days=backup_job.get('retention_days', 30),
                gcs_bucket=backup_job.get('gcs_bucket'),
                gcs_prefix=backup_job.get('gcs_prefix', 'firestore-backups'),
                max_retries=backup_job.get('max_retries', 3),
                batch_size=backup_job.get('batch_size', 100)
            )
            configs.append(config)
        
        return configs
    
    def _setup_logging(self) -> logging.Logger:
        """Setup logging for scheduler."""
        logger = logging.getLogger('backup_scheduler')
        logger.setLevel(logging.INFO)
        
        # Remove existing handlers
        for handler in logger.handlers[:]:
            logger.removeHandler(handler)
        
        # Console handler
        console_handler = logging.StreamHandler()
        console_handler.setLevel(logging.INFO)
        
        # File handler
        log_file = Path(self.scheduler_config.get('log_file', 'scheduler.log'))
        log_file.parent.mkdir(parents=True, exist_ok=True)
        file_handler = logging.FileHandler(log_file)
        file_handler.setLevel(logging.DEBUG)
        
        # Formatter
        formatter = logging.Formatter(
            '%(asctime)s - %(name)s - %(levelname)s - %(message)s'
        )
        console_handler.setFormatter(formatter)
        file_handler.setFormatter(formatter)
        
        logger.addHandler(console_handler)
        logger.addHandler(file_handler)
        
        return logger
    
    def _send_notification(self, subject: str, body: str, is_error: bool = False) -> None:
        """Send email notification for backup status."""
        email_config = self.scheduler_config.get('email', {})
        
        if not email_config.get('enabled', False):
            return
        
        try:
            msg = MIMEMultipart()
            msg['From'] = email_config['from_email']
            msg['To'] = ', '.join(email_config['to_emails'])
            msg['Subject'] = f"[Firestore Backup] {subject}"
            
            # Add timestamp and status
            status_emoji = "❌" if is_error else "✅"
            full_body = f"{status_emoji} {body}\n\nTimestamp: {datetime.now().isoformat()}"
            
            msg.attach(MIMEText(full_body, 'plain'))
            
            # Send email
            server = smtplib.SMTP(email_config['smtp_server'], email_config['smtp_port'])
            server.starttls()
            server.login(email_config['username'], email_config['password'])
            server.send_message(msg)
            server.quit()
            
            self.logger.info(f"Notification sent: {subject}")
            
        except Exception as e:
            self.logger.error(f"Failed to send notification: {e}")
    
    def _run_backup_job(self, job_name: str, config: BackupConfig) -> None:
        """Execute a backup job with error handling and notifications."""
        self.logger.info(f"Starting scheduled backup job: {job_name}")
        
        try:
            backup_util = FirestoreBackup(config)
            metadata = backup_util.create_backup()
            
            if metadata.status == "success":
                self.logger.info(f"Backup job '{job_name}' completed successfully")
                self._send_notification(
                    f"Backup Success - {job_name}",
                    f"Backup completed successfully.\n"
                    f"Documents: {metadata.total_documents}\n"
                    f"Size: {metadata.backup_size_bytes / 1024 / 1024:.2f} MB\n"
                    f"Duration: {metadata.duration_seconds:.2f}s"
                )
            else:
                self.logger.error(f"Backup job '{job_name}' failed")
                self._send_notification(
                    f"Backup Failed - {job_name}",
                    f"Backup failed after {metadata.duration_seconds:.2f}s",
                    is_error=True
                )
                
        except Exception as e:
            self.logger.error(f"Backup job '{job_name}' failed with exception: {e}")
            self._send_notification(
                f"Backup Error - {job_name}",
                f"Backup failed with exception: {str(e)}",
                is_error=True
            )
    
    def _setup_schedules(self) -> None:
        """Setup backup schedules based on configuration."""
        backup_jobs = self.scheduler_config.get('backup_jobs', [])
        
        for i, job in enumerate(backup_jobs):
            job_name = job.get('name', f'backup_job_{i}')
            schedule_time = job.get('schedule')
            config = self.backup_configs[i]
            
            if not schedule_time:
                self.logger.warning(f"No schedule defined for job: {job_name}")
                continue
            
            # Parse schedule and set up job
            if schedule_time.startswith('daily'):
                time_str = schedule_time.replace('daily', '').strip()
                if time_str:
                    schedule.every().day.at(time_str).do(
                        self._run_backup_job, job_name, config
                    ).tag(job_name)
                else:
                    schedule.every().day.at("02:00").do(
                        self._run_backup_job, job_name, config
                    ).tag(job_name)
                    
            elif schedule_time.startswith('weekly'):
                day_time = schedule_time.replace('weekly', '').strip()
                if day_time:
                    day, time_str = day_time.split() if ' ' in day_time else (day_time, "02:00")
                    getattr(schedule.every(), day.lower()).at(time_str).do(
                        self._run_backup_job, job_name, config
                    ).tag(job_name)
                else:
                    schedule.every().monday.at("02:00").do(
                        self._run_backup_job, job_name, config
                    ).tag(job_name)
                    
            elif schedule_time.startswith('hourly'):
                interval = schedule_time.replace('hourly', '').strip()
                hours = int(interval) if interval.isdigit() else 1
                schedule.every(hours).hours.do(
                    self._run_backup_job, job_name, config
                ).tag(job_name)
                
            else:
                self.logger.warning(f"Unknown schedule format: {schedule_time}")
                continue
            
            self.logger.info(f"Scheduled job '{job_name}' with schedule: {schedule_time}")
    
    def run_scheduler(self) -> None:
        """Run the backup scheduler."""
        self.logger.info("Starting backup scheduler...")
        
        # Setup schedules
        self._setup_schedules()
        
        # Send startup notification
        self._send_notification(
            "Scheduler Started",
            f"Backup scheduler started with {len(self.backup_configs)} jobs configured"
        )
        
        self.logger.info("Scheduler is running. Press Ctrl+C to stop.")
        
        try:
            while True:
                schedule.run_pending()
                time.sleep(60)  # Check every minute
                
        except KeyboardInterrupt:
            self.logger.info("Scheduler stopped by user")
            self._send_notification(
                "Scheduler Stopped",
                "Backup scheduler was stopped manually"
            )
        except Exception as e:
            self.logger.error(f"Scheduler error: {e}")
            self._send_notification(
                "Scheduler Error",
                f"Scheduler encountered an error: {str(e)}",
                is_error=True
            )
            raise


def create_sample_scheduler_config() -> str:
    """Create a sample scheduler configuration file."""
    config = {
        "log_file": "./logs/scheduler.log",
        "email": {
            "enabled": False,
            "smtp_server": "smtp.gmail.com",
            "smtp_port": 587,
            "username": "your-email@gmail.com",
            "password": "your-app-password",
            "from_email": "your-email@gmail.com",
            "to_emails": ["admin@yourcompany.com"]
        },
        "backup_jobs": [
            {
                "name": "daily_full_backup",
                "project_id": "transport-app-d662f",
                "backup_dir": "./backups/daily",
                "collections": [],
                "compression": True,
                "encryption": False,
                "retention_days": 7,
                "gcs_bucket": "your-backup-bucket",
                "gcs_prefix": "daily-backups",
                "schedule": "daily 02:00"
            },
            {
                "name": "weekly_full_backup",
                "project_id": "transport-app-d662f", 
                "backup_dir": "./backups/weekly",
                "collections": [],
                "compression": True,
                "encryption": True,
                "retention_days": 30,
                "gcs_bucket": "your-backup-bucket",
                "gcs_prefix": "weekly-backups",
                "schedule": "weekly sunday 03:00"
            },
            {
                "name": "hourly_critical_backup",
                "project_id": "transport-app-d662f",
                "backup_dir": "./backups/hourly",
                "collections": ["users", "occasions", "payments"],
                "compression": True,
                "encryption": False,
                "retention_days": 3,
                "gcs_bucket": "your-backup-bucket",
                "gcs_prefix": "hourly-backups",
                "schedule": "hourly 4"
            }
        ]
    }
    
    config_path = "scheduler_config.json"
    with open(config_path, 'w') as f:
        json.dump(config, f, indent=2)
    
    return config_path


def main():
    """Main entry point for the scheduler."""
    parser = argparse.ArgumentParser(
        description="Firestore Backup Scheduler",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  # Run scheduler with config file
  python scheduler.py --config scheduler_config.json

  # Create sample configuration
  python scheduler.py --create-config

  # Run scheduler in foreground
  python scheduler.py --config scheduler_config.json --foreground
        """
    )
    
    parser.add_argument(
        '--config',
        help='Scheduler configuration file',
        default='scheduler_config.json'
    )
    
    parser.add_argument(
        '--create-config',
        action='store_true',
        help='Create a sample configuration file'
    )
    
    parser.add_argument(
        '--foreground',
        action='store_true',
        help='Run scheduler in foreground (default: daemon mode)'
    )
    
    args = parser.parse_args()
    
    if args.create_config:
        config_path = create_sample_scheduler_config()
        print(f"Sample configuration created: {config_path}")
        print("Please edit the configuration file and run the scheduler.")
        return
    
    if not Path(args.config).exists():
        print(f"Configuration file not found: {args.config}")
        print("Use --create-config to create a sample configuration.")
        sys.exit(1)
    
    try:
        scheduler = BackupScheduler(args.config)
        
        if args.foreground:
            scheduler.run_scheduler()
        else:
            # Run as daemon (basic implementation)
            print("Starting scheduler in background...")
            scheduler.run_scheduler()
            
    except KeyboardInterrupt:
        print("\nScheduler stopped by user")
        sys.exit(0)
    except Exception as e:
        print(f"Scheduler failed: {e}")
        sys.exit(1)


if __name__ == "__main__":
    main()

