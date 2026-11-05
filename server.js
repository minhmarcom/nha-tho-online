'use strict';
const express = require('express');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 8080;

// Phục vụ toàn bộ file tĩnh (HTML, CSS, JS, Assets hình ảnh & âm thanh)
app.use(express.static(path.join(__dirname), {
  maxAge: '1d'
}));

app.get('/', (_req, res) => {
  res.sendFile(path.join(__dirname, 'index.html'));
});

app.get('/health', (_req, res) => {
  res.json({ status: 'ok', name: 'Thánh Đường Online', port: PORT });
});

app.listen(PORT, '0.0.0.0', () => {
  console.log(`\n======================================================`);
  console.log(`✝️  THÁNH ĐƯỜNG ONLINE — ĐI NHÀ THỜ, AMEN & TẠ ƠN CHÚA`);
  console.log(`   Web Simulator Game chạy tại: http://localhost:${PORT}`);
  console.log(`======================================================\n`);
});
