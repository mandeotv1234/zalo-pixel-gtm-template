> **Lưu ý (2026-11-11):** file này mô tả cấu hình **Event Builder thuần** (webElement id/class/nội dung) trong Zalo Ads Manager, dùng khi **không** dùng GTM template này để track. Nếu bạn dùng tag Track event của `template.tpl` cho một event, **đừng** đồng thời tạo conversion Event Builder cho cùng event đó — xem cảnh báo trùng event trong README.md. Riêng dòng dưới đây về `AddPaymentInfo`/`btn-purchase` mô tả landing-page bản cũ; bản hiện tại (`landing-page-v2`) đã tách `AddPaymentInfo` ra nút riêng, không còn dùng chung `btn-purchase` với `Purchase` nữa.

# 11 Conversion còn lại — Zalo Ads Manager

> Tạo sau khi đã test xong 6 conversion chính.
> Tất cả đều dùng **Loại conversion: Khác** vì Zalo chỉ có 7 loại active.
> URL trang đích: dùng **Có chứa** + domain Vercel của landing page.

---

## Conversion 7: ViewContent

| Field | Giá trị |
|---|---|
| Tên | `ZTech - Xem nội dung` |
| Loại conversion | **Khác** |
| Trang đích liên kết | `Có chứa` · `https://<vercel-domain>` |
| Sự kiện | **Thêm sự kiện đường dẫn URL** → `Có chứa` · `/` |

> Dùng URL event thay vì button vì ViewContent fire khi load trang và khi click vào product card — không có 1 nút cố định.

---

## Conversion 8: AddToWishlist

| Field | Giá trị |
|---|---|
| Tên | `ZTech - Thêm vào yêu thích` |
| Loại conversion | **Khác** |
| Trang đích liên kết | `Có chứa` · URL landing page |
| Sự kiện | **Thêm sự kiện nút bấm** → Class → `btn-wishlist` |

> Nút heart (♥) trên mỗi product card — dùng class vì có 6 nút.

---

## Conversion 9: AddPaymentInfo

| Field | Giá trị |
|---|---|
| Tên | `ZTech - Thêm thông tin thanh toán` |
| Loại conversion | **Khác** |
| Trang đích liên kết | `Có chứa` · URL landing page |
| Sự kiện | **Thêm sự kiện nút bấm** → ID → `btn-purchase` |

> Event AddPaymentInfo fire cùng lúc với Purchase khi submit form thanh toán — cùng nút `btn-purchase`.

---

## Conversion 10: Search

| Field | Giá trị |
|---|---|
| Tên | `ZTech - Tìm kiếm` |
| Loại conversion | **Khác** |
| Trang đích liên kết | `Có chứa` · URL landing page |
| Sự kiện | **Thêm sự kiện nút bấm** → Nội dung → `Tìm kiếm` |

> Nút icon tìm kiếm trên Header. Event fire khi user type vào ô search.

---

## Conversion 11: CustomizeProduct

| Field | Giá trị |
|---|---|
| Tên | `ZTech - Tùy chỉnh sản phẩm` |
| Loại conversion | **Khác** |
| Trang đích liên kết | `Có chứa` · URL landing page |
| Sự kiện | **Thêm sự kiện nút bấm** → Nội dung → `Đen Titan` |

> Chọn màu "Đen Titan" (màu mặc định, thường click đầu tiên). Nếu muốn track tất cả màu → thêm 4 button event trong cùng 1 conversion: `Đen Titan`, `Xanh Biển`, `Trắng Ngọc`, `Vàng Gold`.

---

## Conversion 12: Subscribe

| Field | Giá trị |
|---|---|
| Tên | `ZTech - Đăng ký nhận tin` |
| Loại conversion | **Khác** |
| Trang đích liên kết | `Có chứa` · URL landing page |
| Sự kiện | **Thêm sự kiện nút bấm** → ID → `btn-subscribe` |

---

## Conversion 13: Donate

| Field | Giá trị |
|---|---|
| Tên | `ZTech - Đóng góp` |
| Loại conversion | **Khác** |
| Trang đích liên kết | `Có chứa` · URL landing page |
| Sự kiện | **Thêm sự kiện nút bấm** → Class → `btn-donate` |

> Có 4 mức: 50k / 100k / 200k / 500k — dùng class để track tất cả.

---

## Conversion 14: Schedule

| Field | Giá trị |
|---|---|
| Tên | `ZTech - Đặt lịch tư vấn` |
| Loại conversion | **Khác** |
| Trang đích liên kết | `Có chứa` · URL landing page |
| Sự kiện | **Thêm sự kiện nút bấm** → ID → `btn-schedule` |

---

## Conversion 15: FindLocation

| Field | Giá trị |
|---|---|
| Tên | `ZTech - Tìm cửa hàng` |
| Loại conversion | **Khác** |
| Trang đích liên kết | `Có chứa` · URL landing page |
| Sự kiện | **Thêm sự kiện nút bấm** → ID → `btn-find-location` |

---

## Conversion 16: StartTrial

| Field | Giá trị |
|---|---|
| Tên | `ZTech - Dùng thử` |
| Loại conversion | **Khác** |
| Trang đích liên kết | `Có chứa` · URL landing page |
| Sự kiện | **Thêm sự kiện nút bấm** → ID → `btn-start-trial` |

---

## Conversion 17: SubmitApplication

| Field | Giá trị |
|---|---|
| Tên | `ZTech - Đăng ký đại lý` |
| Loại conversion | **Khác** |
| Trang đích liên kết | `Có chứa` · URL landing page |
| Sự kiện | **Thêm sự kiện nút bấm** → ID → `btn-submit-application` |

---

## Tổng hợp tất cả button selectors

| Button ID / Class | Event | Loại selector |
|---|---|---|
| `btn-purchase` | Purchase + AddPaymentInfo | ID |
| `btn-initiate-checkout` | InitiateCheckout | ID |
| `btn-lead` | Lead | ID |
| `btn-register` | CompleteRegistration | ID |
| `btn-schedule` | Schedule | ID |
| `btn-find-location` | FindLocation | ID |
| `btn-subscribe` | Subscribe | ID |
| `btn-submit-application` | SubmitApplication | ID |
| `btn-start-trial` | StartTrial | ID |
| `btn-add-to-cart` | AddToCart | Class |
| `btn-wishlist` | AddToWishlist | Class |
| `btn-donate` | Donate | Class |
