#!/bin/bash

# PostgreSQL Container Manager
CONTAINER_NAME="postgres"
POSTGRES_IMAGE="postgres:15-alpine"
POSTGRES_PORT="127.0.0.1:5432:5432"
POSTGRES_USER="pguser"
POSTGRES_PASSWORD="Nx4yP9K5xwwkDrdPJ6qMHUl37V1utceRa"
POSTGRES_DB="pguser"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to check if container exists
container_exists() {
    docker ps -a --format "table {{.Names}}" | grep -q "^${CONTAINER_NAME}$"
}

# Function to check if container is running
container_running() {
    docker ps --format "table {{.Names}}" | grep -q "^${CONTAINER_NAME}$"
}

# Function to start PostgreSQL
start_postgres() {
    if container_running; then
        echo -e "${YELLOW}PostgreSQL container đã đang chạy!${NC}"
        return 0
    fi
    
    if container_exists; then
        echo -e "${GREEN}Khởi động PostgreSQL container...${NC}"
        docker start ${CONTAINER_NAME}
    else
        echo -e "${GREEN}Tạo và chạy PostgreSQL container mới...${NC}"
        docker run -d \
            --name ${CONTAINER_NAME} \
            -p ${POSTGRES_PORT} \
            -e POSTGRES_USER=${POSTGRES_USER} \
            -e POSTGRES_PASSWORD=${POSTGRES_PASSWORD} \
            -e POSTGRES_DB=${POSTGRES_DB} \
            --restart unless-stopped \
            ${POSTGRES_IMAGE}
    fi
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ PostgreSQL đã khởi động thành công!${NC}"
        echo -e "${GREEN}🌐 Kết nối: localhost:5432${NC}"
        echo -e "${GREEN}👤 User: ${POSTGRES_USER}${NC}"
        echo -e "${GREEN}🗄️ Database: ${POSTGRES_DB}${NC}"
        echo -e "${GREEN}🔑 Password: ${POSTGRES_PASSWORD}${NC}"
    else
        echo -e "${RED}❌ Lỗi khi khởi động PostgreSQL!${NC}"
    fi
}

# Function to stop PostgreSQL
stop_postgres() {
    if container_running; then
        echo -e "${YELLOW}Đang tắt PostgreSQL container...${NC}"
        docker stop ${CONTAINER_NAME}
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✅ PostgreSQL đã được tắt thành công!${NC}"
        else
            echo -e "${RED}❌ Lỗi khi tắt PostgreSQL!${NC}"
        fi
    else
        echo -e "${YELLOW}PostgreSQL container không đang chạy!${NC}"
    fi
}

# Function to restart PostgreSQL
restart_postgres() {
    echo -e "${YELLOW}Đang khởi động lại PostgreSQL...${NC}"
    stop_postgres
    sleep 3
    start_postgres
}

# Function to show PostgreSQL status
status_postgres() {
    if container_running; then
        echo -e "${GREEN}✅ PostgreSQL đang chạy${NC}"
        echo -e "${GREEN}📊 Thông tin container:${NC}"
        docker ps --filter "name=${CONTAINER_NAME}" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
    elif container_exists; then
        echo -e "${RED}❌ PostgreSQL container tồn tại nhưng không chạy${NC}"
    else
        echo -e "${RED}❌ PostgreSQL container không tồn tại${NC}"
    fi
}

# Function to remove PostgreSQL container
remove_postgres() {
    if container_running; then
        echo -e "${YELLOW}Tắt PostgreSQL trước khi xóa...${NC}"
        docker stop ${CONTAINER_NAME}
    fi
    
    if container_exists; then
        echo -e "${YELLOW}Xóa PostgreSQL container...${NC}"
        docker rm ${CONTAINER_NAME}
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✅ PostgreSQL container đã được xóa!${NC}"
        else
            echo -e "${RED}❌ Lỗi khi xóa PostgreSQL container!${NC}"
        fi
    else
        echo -e "${YELLOW}PostgreSQL container không tồn tại!${NC}"
    fi
}

# Function to show logs
logs_postgres() {
    if container_exists; then
        echo -e "${GREEN}📋 Logs của PostgreSQL:${NC}"
        docker logs ${CONTAINER_NAME}
    else
        echo -e "${RED}❌ PostgreSQL container không tồn tại!${NC}"
    fi
}

# Function to connect to PostgreSQL
connect_postgres() {
    if container_running; then
        echo -e "${GREEN}🔗 Kết nối tới PostgreSQL...${NC}"
        docker exec -it ${CONTAINER_NAME} psql -U ${POSTGRES_USER} -d ${POSTGRES_DB}
    else
        echo -e "${RED}❌ PostgreSQL container không đang chạy!${NC}"
    fi
}

# Function to create database
create_db() {
    if container_running; then
        if [ -z "$1" ]; then
            echo -e "${RED}❌ Vui lòng nhập tên database!${NC}"
            echo "Sử dụng: $0 createdb <tên_database>"
            return 1
        fi
        
        echo -e "${GREEN}🗄️ Tạo database: $1${NC}"
        docker exec -it ${CONTAINER_NAME} psql -U ${POSTGRES_USER} -d ${POSTGRES_DB} -c "CREATE DATABASE $1;"
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✅ Database '$1' đã được tạo thành công!${NC}"
        else
            echo -e "${RED}❌ Lỗi khi tạo database '$1'!${NC}"
        fi
    else
        echo -e "${RED}❌ PostgreSQL container không đang chạy!${NC}"
    fi
}

# Function to list databases
list_db() {
    if container_running; then
        echo -e "${GREEN}📋 Danh sách databases:${NC}"
        docker exec -it ${CONTAINER_NAME} psql -U ${POSTGRES_USER} -d ${POSTGRES_DB} -c "\\l"
    else
        echo -e "${RED}❌ PostgreSQL container không đang chạy!${NC}"
    fi
}

# Function to backup database
backup_db() {
    if container_running; then
        if [ -z "$1" ]; then
            echo -e "${RED}❌ Vui lòng nhập tên database để backup!${NC}"
            echo "Sử dụng: $0 backup <tên_database>"
            return 1
        fi
        
        BACKUP_FILE="${1}_backup_$(date +%Y%m%d_%H%M%S).sql"
        echo -e "${GREEN}💾 Backup database '$1' vào file: $BACKUP_FILE${NC}"
        docker exec -t ${CONTAINER_NAME} pg_dump -U ${POSTGRES_USER} -d $1 > $BACKUP_FILE
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✅ Backup thành công: $BACKUP_FILE${NC}"
        else
            echo -e "${RED}❌ Lỗi khi backup database '$1'!${NC}"
        fi
    else
        echo -e "${RED}❌ PostgreSQL container không đang chạy!${NC}"
    fi
}

# Function to export database
export_db() {
    if container_running; then
        if [ -z "$1" ]; then
            echo -e "${RED}❌ Vui lòng nhập tên database để export!${NC}"
            echo "Sử dụng: $0 export <tên_database> [tên_file]"
            return 1
        fi
        
        if [ -z "$2" ]; then
            EXPORT_FILE="${1}_export_$(date +%Y%m%d_%H%M%S).sql"
        else
            EXPORT_FILE="$2"
        fi
        
        echo -e "${GREEN}📤 Export database '$1' vào file: $EXPORT_FILE${NC}"
        docker exec -t ${CONTAINER_NAME} pg_dump -U ${POSTGRES_USER} -d $1 --clean --if-exists > $EXPORT_FILE
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✅ Export thành công: $EXPORT_FILE${NC}"
            echo -e "${GREEN}📊 Kích thước file: $(ls -lh $EXPORT_FILE | awk '{print $5}')${NC}"
        else
            echo -e "${RED}❌ Lỗi khi export database '$1'!${NC}"
        fi
    else
        echo -e "${RED}❌ PostgreSQL container không đang chạy!${NC}"
    fi
}

# Function to import database
import_db() {
    if container_running; then
        if [ -z "$1" ] || [ -z "$2" ]; then
            echo -e "${RED}❌ Vui lòng nhập tên database và file để import!${NC}"
            echo "Sử dụng: $0 import <tên_database> <file_sql>"
            return 1
        fi
        
        if [ ! -f "$2" ]; then
            echo -e "${RED}❌ File '$2' không tồn tại!${NC}"
            return 1
        fi
        
        echo -e "${GREEN}📥 Import dữ liệu từ file '$2' vào database '$1'...${NC}"
        echo -e "${YELLOW}⚠️  Lưu ý: Dữ liệu hiện tại trong database '$1' có thể bị ghi đè!${NC}"
        
        # Kiểm tra xem database có tồn tại không, nếu không thì tạo mới
        DB_EXISTS=$(docker exec -t ${CONTAINER_NAME} psql -U ${POSTGRES_USER} -d ${POSTGRES_DB} -tAc "SELECT 1 FROM pg_database WHERE datname='$1'")
        if [ -z "$DB_EXISTS" ]; then
            echo -e "${YELLOW}🗄️ Database '$1' không tồn tại. Đang tạo mới...${NC}"
            docker exec -it ${CONTAINER_NAME} psql -U ${POSTGRES_USER} -d ${POSTGRES_DB} -c "CREATE DATABASE $1;"
        fi
        
        cat "$2" | docker exec -i ${CONTAINER_NAME} psql -U ${POSTGRES_USER} -d $1
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✅ Import thành công vào database '$1'!${NC}"
        else
            echo -e "${RED}❌ Lỗi khi import dữ liệu vào database '$1'!${NC}"
        fi
    else
        echo -e "${RED}❌ PostgreSQL container không đang chạy!${NC}"
    fi
}

# Function to show help
show_help() {
    echo -e "${GREEN}PostgreSQL Container Manager${NC}"
    echo "Cách sử dụng: $0 [COMMAND]"
    echo ""
    echo "Các lệnh có sẵn:"
    echo "  start             - Khởi động PostgreSQL container"
    echo "  stop              - Tắt PostgreSQL container"
    echo "  restart           - Khởi động lại PostgreSQL container"
    echo "  status            - Kiểm tra trạng thái PostgreSQL"
    echo "  remove            - Xóa PostgreSQL container"
    echo "  logs              - Xem logs của PostgreSQL"
    echo "  connect           - Kết nối tới PostgreSQL"
    echo "  createdb <db>     - Tạo database mới"
    echo "  listdb            - Liệt kê tất cả databases"
    echo "  backup <db>       - Backup database"
    echo "  export <db> [file] - Export database ra file SQL"
    echo "  import <db> <file> - Import dữ liệu từ file SQL vào database"
    echo "  help              - Hiển thị trợ giúp này"
    echo ""
    echo "Ví dụ:"
    echo "  $0 start"
    echo "  $0 stop"
    echo "  $0 status"
    echo "  $0 createdb myapp"
    echo "  $0 backup myapp"
    echo "  $0 export myapp"
    echo "  $0 export myapp myapp_export.sql"
    echo "  $0 import myapp myapp_export.sql"
}

# Main script logic
case "$1" in
    start)
        start_postgres
        ;;
    stop)
        stop_postgres
        ;;
    restart)
        restart_postgres
        ;;
    status)
        status_postgres
        ;;
    remove)
        remove_postgres
        ;;
    logs)
        logs_postgres
        ;;
    connect)
        connect_postgres
        ;;
    createdb)
        create_db "$2"
        ;;
    listdb)
        list_db
        ;;
    backup)
        backup_db "$2"
        ;;
    export)
        export_db "$2" "$3"
        ;;
    import)
        import_db "$2" "$3"
        ;;
    help|--help|-h)
        show_help
        ;;
    "")
        show_help
        ;;
    *)
        echo -e "${RED}❌ Lệnh không hợp lệ: $1${NC}"
        echo ""
        show_help
        exit 1
        ;;
esac 