{
  "name": "teneo-auto-farm",
  "version": "1.0.0",
  "description": "auto farm for teneo extension",
  "main": "main.js",
  "scripts": {
    "start": "node main.js",
    "pm2-start": "node -e \"process.stdout.isTTY = false; require('./main.js')\""
  },
  "dependencies": {
    "axios": "^0.21.1",
    "chalk": "^4.1.2",
    "https-proxy-agent": "^5.0.0",
    "ws": "^8.0.0"
  }
}
