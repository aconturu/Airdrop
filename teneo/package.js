{
  "name": "teneo-auto-farm",
  "version": "1.0.0",
  "description": "auto farm for teneo extension",
  "main": "teneo.js",
  "scripts": {
    "start": "node teneo.js",
    "pm2-start": "node -e \"process.stdout.isTTY = false; require('./teneo.js')\""
  },
  "dependencies": {
    "axios": "^0.21.1",
    "chalk": "^4.1.2",
    "https-proxy-agent": "^5.0.0",
    "ws": "^8.0.0"
  }
}
