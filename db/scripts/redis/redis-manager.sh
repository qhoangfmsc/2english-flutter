#!/bin/bash

# Redis Container Manager
CONTAINER_NAME="redis"
REDIS_IMAGE="redis:7-alpine"
REDIS_PORT="127.0.0.1:6379:6379"
REDIS_PASSWORD="password123"

# Redis configuration for better connection stability
REDIS_CONFIG="
# Network settings
timeout 300
tcp-keepalive 60
tcp-backlog 511

# Memory settings
maxmemory 256mb
maxmemory-policy allkeys-lru

# Persistence settings
save 900 1
save 300 10
save 60 10000
stop-writes-on-bgsave-error yes
rdbcompression yes
rdbchecksum yes

# Logging
loglevel notice

# Security
protected-mode yes
bind 0.0.0.0

# Performance
databases 16
hash-max-ziplist-entries 512
hash-max-ziplist-value 64
list-max-ziplist-size -2
set-max-intset-entries 512
zset-max-ziplist-entries 128
zset-max-ziplist-value 64
activerehashing yes
client-output-buffer-limit normal 0 0 0
client-output-buffer-limit slave 256mb 64mb 60
client-output-buffer-limit pubsub 32mb 8mb 60
hz 10
aof-rewrite-incremental-fsync yes
"

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

# Function to start Redis
start_redis() {
    if container_running; then
        echo -e "${YELLOW}Redis container đã đang chạy!${NC}"
        return 0
    fi
    
    if container_exists; then
        echo -e "${GREEN}Khởi động Redis container...${NC}"
        docker start ${CONTAINER_NAME}
    else
        echo -e "${GREEN}Tạo và chạy Redis container mới với cấu hình tối ưu...${NC}"
        
        # Create Redis config file
        cat > /tmp/redis.conf << EOF
${REDIS_CONFIG}
EOF
        
        docker run -d \
            --name ${CONTAINER_NAME} \
            -p ${REDIS_PORT} \
            --restart unless-stopped \
            --memory="512m" \
            --cpus="1.0" \
            -v /tmp/redis.conf:/usr/local/etc/redis/redis.conf \
            ${REDIS_IMAGE} \
            redis-server /usr/local/etc/redis/redis.conf --requirepass ${REDIS_PASSWORD}
    fi
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Redis đã khởi động thành công!${NC}"
        echo -e "${GREEN}🌐 Kết nối: localhost:6379${NC}"
        echo -e "${GREEN}🔑 Password: ${REDIS_PASSWORD}${NC}"
    else
        echo -e "${RED}❌ Lỗi khi khởi động Redis!${NC}"
    fi
}

# Function to stop Redis
stop_redis() {
    if container_running; then
        echo -e "${YELLOW}Đang tắt Redis container...${NC}"
        docker stop ${CONTAINER_NAME}
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✅ Redis đã được tắt thành công!${NC}"
        else
            echo -e "${RED}❌ Lỗi khi tắt Redis!${NC}"
        fi
    else
        echo -e "${YELLOW}Redis container không đang chạy!${NC}"
    fi
}

# Function to restart Redis
restart_redis() {
    echo -e "${YELLOW}Đang khởi động lại Redis...${NC}"
    stop_redis
    sleep 2
    start_redis
}

# Function to show Redis status
status_redis() {
    if container_running; then
        echo -e "${GREEN}✅ Redis đang chạy${NC}"
        echo -e "${GREEN}📊 Thông tin container:${NC}"
        docker ps --filter "name=${CONTAINER_NAME}" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
    elif container_exists; then
        echo -e "${RED}❌ Redis container tồn tại nhưng không chạy${NC}"
    else
        echo -e "${RED}❌ Redis container không tồn tại${NC}"
    fi
}

# Function to remove Redis container
remove_redis() {
    if container_running; then
        echo -e "${YELLOW}Tắt Redis trước khi xóa...${NC}"
        docker stop ${CONTAINER_NAME}
    fi
    
    if container_exists; then
        echo -e "${YELLOW}Xóa Redis container...${NC}"
        docker rm ${CONTAINER_NAME}
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✅ Redis container đã được xóa!${NC}"
        else
            echo -e "${RED}❌ Lỗi khi xóa Redis container!${NC}"
        fi
    else
        echo -e "${YELLOW}Redis container không tồn tại!${NC}"
    fi
}

# Function to show logs
logs_redis() {
    if container_exists; then
        echo -e "${GREEN}📋 Logs của Redis:${NC}"
        docker logs ${CONTAINER_NAME}
    else
        echo -e "${RED}❌ Redis container không tồn tại!${NC}"
    fi
}

# Function to connect to Redis CLI
connect_redis() {
    if container_running; then
        echo -e "${GREEN}🔗 Kết nối tới Redis CLI...${NC}"
        docker exec -it ${CONTAINER_NAME} redis-cli -a ${REDIS_PASSWORD}
    else
        echo -e "${RED}❌ Redis container không đang chạy!${NC}"
    fi
}

# Function to show Redis configuration
config_redis() {
    if container_running; then
        echo -e "${GREEN}⚙️ Cấu hình Redis hiện tại:${NC}"
        docker exec ${CONTAINER_NAME} redis-cli -a ${REDIS_PASSWORD} CONFIG GET timeout
        docker exec ${CONTAINER_NAME} redis-cli -a ${REDIS_PASSWORD} CONFIG GET tcp-keepalive
        docker exec ${CONTAINER_NAME} redis-cli -a ${REDIS_PASSWORD} CONFIG GET maxmemory
        docker exec ${CONTAINER_NAME} redis-cli -a ${REDIS_PASSWORD} CONFIG GET maxmemory-policy
        echo ""
        echo -e "${GREEN}📊 Thông tin kết nối:${NC}"
        docker exec ${CONTAINER_NAME} redis-cli -a ${REDIS_PASSWORD} CLIENT LIST | head -10
    else
        echo -e "${RED}❌ Redis container không đang chạy!${NC}"
    fi
}

# Function to show help
show_help() {
    echo -e "${GREEN}Redis Container Manager${NC}"
    echo "Cách sử dụng: $0 [COMMAND]"
    echo ""
    echo "Các lệnh có sẵn:"
    echo "  start    - Khởi động Redis container"
    echo "  stop     - Tắt Redis container"
    echo "  restart  - Khởi động lại Redis container"
    echo "  status   - Kiểm tra trạng thái Redis"
    echo "  remove   - Xóa Redis container"
    echo "  logs     - Xem logs của Redis"
    echo "  connect  - Kết nối tới Redis CLI"
    echo "  config   - Xem cấu hình Redis hiện tại"
    echo "  help     - Hiển thị trợ giúp này"
    echo ""
    echo "Ví dụ:"
    echo "  $0 start"
    echo "  $0 stop"
    echo "  $0 status"
}

# Main script logic
case "$1" in
    start)
        start_redis
        ;;
    stop)
        stop_redis
        ;;
    restart)
        restart_redis
        ;;
    status)
        status_redis
        ;;
    remove)
        remove_redis
        ;;
    logs)
        logs_redis
        ;;
    connect)
        connect_redis
        ;;
    config)
        config_redis
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