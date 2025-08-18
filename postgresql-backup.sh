#!/bin/bash

# Daily backup script for DB_Rmart
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/Users/user/Documents/ProjectWeb/backups"

# Create backup directory if not exists
mkdir -p "$BACKUP_DIR"

# Create backup
echo "📦 Creating backup of DB_Rmart..."
pg_dump -h localhost -U postgres -d DB_Rmart > "$BACKUP_DIR/DB_Rmart_backup_$DATE.sql"

# Keep only last 7 backups
echo "🧹 Cleaning old backups..."
ls -t "$BACKUP_DIR"/DB_Rmart_backup_*.sql | tail -n +8 | xargs rm -f

echo "✅ Backup completed: DB_Rmart_backup_$DATE.sql"
echo "📁 Backup location: $BACKUP_DIR"