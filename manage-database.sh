#!/bin/bash

# R-Mart Database Management Script
# Usage: ./manage-database.sh [start|stop|restart|status|logs|backup|restore]

DB_CONTAINER="rmart_postgres"
DB_NAME="DB_Rmart"
DB_USER="postgres"
BACKUP_DIR="./backups"

case "$1" in
    start)
        echo "🚀 Starting R-Mart Database..."
        cd Ecommerce && docker-compose up -d
        echo "✅ Database started successfully!"
        echo "📊 Connection: localhost:5432"
        echo "🗄️  Database: $DB_NAME"
        echo "👤 User: $DB_USER"
        ;;
    
    stop)
        echo "🛑 Stopping R-Mart Database..."
        cd Ecommerce && docker-compose down
        echo "✅ Database stopped successfully!"
        ;;
    
    restart)
        echo "🔄 Restarting R-Mart Database..."
        cd Ecommerce && docker-compose restart
        echo "✅ Database restarted successfully!"
        ;;
    
    status)
        echo "📊 R-Mart Database Status:"
        cd Ecommerce && docker-compose ps
        echo ""
        echo "📈 Database Statistics:"
        docker exec $DB_CONTAINER psql -U $DB_USER -d $DB_NAME -c "
        SELECT 'Categories:' as info, count(*) as count FROM categories 
        UNION ALL SELECT 'Products:', count(*) FROM products 
        UNION ALL SELECT 'Users:', count(*) FROM users
        UNION ALL SELECT 'Orders:', count(*) FROM orders;"
        ;;
    
    logs)
        echo "📋 R-Mart Database Logs:"
        docker logs $DB_CONTAINER --tail=50 -f
        ;;
    
    backup)
        echo "💾 Creating database backup..."
        mkdir -p $BACKUP_DIR
        BACKUP_FILE="$BACKUP_DIR/DB_Rmart_backup_$(date +%Y%m%d_%H%M%S).sql"
        docker exec $DB_CONTAINER pg_dump -U $DB_USER $DB_NAME > $BACKUP_FILE
        echo "✅ Backup created: $BACKUP_FILE"
        ;;
    
    restore)
        if [ -z "$2" ]; then
            echo "❌ Please specify backup file: ./manage-database.sh restore <backup_file>"
            exit 1
        fi
        echo "🔄 Restoring database from $2..."
        docker exec -i $DB_CONTAINER psql -U $DB_USER -d $DB_NAME < $2
        echo "✅ Database restored successfully!"
        ;;
    
    connect)
        echo "🔗 Connecting to R-Mart Database..."
        docker exec -it $DB_CONTAINER psql -U $DB_USER -d $DB_NAME
        ;;
    
    *)
        echo "🛒 R-Mart Database Management"
        echo "Usage: $0 {start|stop|restart|status|logs|backup|restore|connect}"
        echo ""
        echo "Commands:"
        echo "  start    - Start the database"
        echo "  stop     - Stop the database"
        echo "  restart  - Restart the database"
        echo "  status   - Show database status and statistics"
        echo "  logs     - Show database logs"
        echo "  backup   - Create database backup"
        echo "  restore  - Restore from backup file"
        echo "  connect  - Connect to database shell"
        exit 1
        ;;
esac