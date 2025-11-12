# Redis Docker Setup

Dự án này cung cấp môi trường Redis sử dụng Docker với các công cụ quản lý dễ sử dụng.

## 📋 Yêu cầu hệ thống

- Docker
- Bash shell

## 🚀 Cài đặt nhanh

### Cách 1: Sử dụng script quản lý (Khuyến nghị)

```bash
# Khởi động Redis
./redis-manager.sh start

# Kiểm tra trạng thái
./redis-manager.sh status
```

### Cách 2: Sử dụng Docker trực tiếp

```bash
docker run -d \
  --name redis \
  -p 127.0.0.1:6379:6379 \
  --restart unless-stopped \
  redis:7-alpine \
  redis-server --requirepass password123
```

## 🛠️ Redis Manager Script

Script `redis-manager.sh` cung cấp interface dễ sử dụng để quản lý Redis container.

### Các lệnh có sẵn:

| Lệnh | Mô tả |
|------|-------|
| `start` | Khởi động Redis container |
| `stop` | Tắt Redis container |
| `restart` | Khởi động lại Redis container |
| `status` | Kiểm tra trạng thái Redis |
| `remove` | Xóa Redis container |
| `logs` | Xem logs của Redis |
| `connect` | Kết nối tới Redis CLI |
| `help` | Hiển thị trợ giúp |

### Ví dụ sử dụng:

```bash
# Khởi động Redis
./redis-manager.sh start

# Kiểm tra trạng thái
./redis-manager.sh status

# Tắt Redis
./redis-manager.sh stop

# Xem logs
./redis-manager.sh logs

# Kết nối Redis CLI
./redis-manager.sh connect

# Xóa container (cẩn thận!)
./redis-manager.sh remove
```

## 📊 Thông tin kết nối

- **Host**: `localhost` hoặc `127.0.0.1`
- **Port**: `6379`
- **Password**: `password123`
- **Image**: `redis:7-alpine`

## 🔧 Cấu hình

### Thông tin container:
- **Container name**: `redis`
- **Restart policy**: `unless-stopped`
- **Bind IP**: `127.0.0.1` (chỉ local access)

### Thay đổi cấu hình:
Chỉnh sửa các biến trong file `redis-manager.sh`:

```bash
CONTAINER_NAME="redis"
REDIS_IMAGE="redis:7-alpine"
REDIS_PORT="127.0.0.1:6379:6379"
REDIS_PASSWORD="password123"
```

## 🌐 Kết nối từ ứng dụng

### Python (redis-py):
```python
import redis

r = redis.Redis(
    host='localhost',
    port=6379,
    password='password123',
    decode_responses=True
)

# Test connection
r.ping()
```

### Node.js (ioredis):
```javascript
const Redis = require('ioredis');

const redis = new Redis({
    host: 'localhost',
    port: 6379,
    password: 'password123'
});

// Test connection
redis.ping().then(() => {
    console.log('Connected to Redis');
});
```

### CLI:
```bash
# Kết nối bằng Redis CLI
redis-cli -h localhost -p 6379 -a password123

# Hoặc sử dụng script
./redis-manager.sh connect
```

## 🔍 Troubleshooting

### Redis không khởi động được:
```bash
# Kiểm tra logs
./redis-manager.sh logs

# Kiểm tra port có bị chiếm không
netstat -tlnp | grep 6379

# Xóa container cũ và tạo lại
./redis-manager.sh remove
./redis-manager.sh start
```

### Không thể kết nối:
```bash
# Kiểm tra container đang chạy
./redis-manager.sh status

# Test kết nối
redis-cli -h localhost -p 6379 -a password123 ping
```

### Permission denied:
```bash
# Cấp quyền thực thi cho script
chmod +x redis-manager.sh
```

## 🔐 Bảo mật

- Redis chỉ bind tới `127.0.0.1` (localhost)
- Có password protection
- Không expose ra internet

### Thay đổi password:
1. Chỉnh sửa `REDIS_PASSWORD` trong `redis-manager.sh`
2. Restart container: `./redis-manager.sh restart`

## 📈 Monitoring

```bash
# Xem thông tin server
redis-cli -h localhost -p 6379 -a password123 info

# Monitor real-time commands
redis-cli -h localhost -p 6379 -a password123 monitor

# Xem memory usage
redis-cli -h localhost -p 6379 -a password123 info memory
```

## 🤝 Đóng góp

Mọi đóng góp và phản hồi đều được chào đón!

## 📝 License

MIT License - Sử dụng tự do cho mọi mục đích. 