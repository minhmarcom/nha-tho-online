# Thánh Đường Online · Amen, Tạ Ơn Chúa ✝️

Web game giả lập không gian Thánh Đường Công Giáo trực tuyến — lấy cảm hứng từ mô hình giả lập web tĩnh tâm như `chuasen.com`. 
Người dùng có thể truy cập trực tiếp bằng điện thoại, máy tính bảng hoặc máy tính qua trình duyệt web mà không cần cài đặt bất kỳ ứng dụng nào.

## ✨ Tính năng nổi bật

- ⛪ **2 Bối cảnh Thánh Đường linh thiêng**:
  - **Cung Thánh Nhà Thờ**: Bàn Thờ dâng lễ, tượng Chúa Giêsu chịu nạn trên Thánh Giá trung tâm, hàng ghế gỗ trang nghiêm.
  - **Đài Đức Mẹ & Tháp Chuông**: Tượng Đức Mẹ Ban Ơn/Nữ Vương Hòa Bình giữa trời xanh ngắt, tháp chuông giáo đường vươn cao.
- 🚶 **Di chuyển tự do & Chọn chỗ ngồi**: Chạm hoặc bấm chuột đến bất kỳ vị trí nào để nhân vật bước đi, ngồi hàng ghế gỗ hoặc tiến lên Cung Thánh.
- 🕯️ **Thắp Nến Cầu Nguyện**: Chọn tâm tình (Bình an, Chữa lành, Cầu cho cha mẹ, Ơn khôn ngoan, Các linh hồn...) và thắp sáng nến thật trên Bàn Thờ.
- 🌹 **Dâng Hoa Đức Mẹ**: Dâng đóa hoa hồng tươi thắm lên Bàn Thờ cùng tiếng chuông nhẹ.
- ✝️ **Làm Dấu Thánh Giá**: Quỳ gối kính cẩn làm dấu Thánh Giá và đọc kinh.
- 📿 **Lần Hạt Mân Côi Tương Tác**: Lần từng hạt Kinh Kính Mừng, Kinh Lạy Cha, suy niệm Năm Sự Vui/Sáng/Thương/Mừng với bộ đếm hạt và thanh âm chuông thanh tịnh.
- 🔔 **Thỉnh Chuông Giáo Đường**: Đổ 3 hồi chuông truyền tin (Angelus) ngân vang trầm bổng và thả chim bồ câu trắng bay lên trời.
- 📜 **Sổ Ý Nguyện & Hiệp Thông Cộng Đoàn**: Đăng lời cầu nguyện của mình và bấm **"Amen 🙏"** để cùng hiệp thông cho các ý nguyện của mọi người.
- 👤 **Chọn Nhân Vật & Tên Thánh**: Linh mục áo lễ đỏ, Lễ sinh áo trắng, Nữ tu / Sơ khăn lúp, Thiếu nhi Thánh thể khăn quàng vàng, Giáo dân nam / nữ.
- 🎵 **Âm thanh & Thánh ca**: Tích hợp tiếng chuông, đàn Organ và nhạc Thánh ca du dương, nhẹ nhàng.

---

## 🚀 Cách chạy trên máy (Local)

Chỉ cần cài Node.js:

```bash
cd NhaThoOnline
npm start
```

Mở trình duyệt: **`http://localhost:8080`**

---

## 🌐 Cách đưa lên mạng (Deploy Online) để mọi người cùng chơi

Dự án được xây dựng dưới dạng **Static Web Application (HTML / CSS / Vanilla JS)**, tương thích 100% với các nền tảng hosting miễn phí hàng đầu:

### 1. Vercel (Khuyên dùng - 1 click)
- Cài Vercel CLI: `npm i -g vercel` rồi chạy `vercel` trong thư mục `NhaThoOnline`.
- Hoặc đẩy lên GitHub và Import vào [vercel.com](https://vercel.com).

### 2. GitHub Pages (Hoàn toàn miễn phí)
- Tạo một kho lưu trữ GitHub (ví dụ: `ThanhDuongOnline`).
- Đẩy toàn bộ mã nguồn thư mục `NhaThoOnline` lên GitHub.
- Vào **Settings** -> **Pages** -> chọn nhánh `main` và thư mục `/ (root)` -> bấm **Save**.
- Trang web sẽ online ngay tại địa chỉ: `https://<username>.github.io/ThanhDuongOnline/`.

### 3. Netlify
- Đăng nhập [netlify.com](https://www.netlify.com), kéo thả thư mục `NhaThoOnline` vào mục **Drop your site here**.
- Trang web sẽ có link online ngay lập tức!
