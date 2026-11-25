# Zalo Pixel — GTM Custom Tag Template

Tích hợp [Zalo Pixel](https://ads.zalo.me) vào website thông qua Google Tag Manager mà không cần chỉnh sửa mã nguồn.

---

## Tổng quan

Zalo Pixel là thư viện tracking của Zalo dành cho nhà quảng cáo. Nó ghi nhận lượt xem trang và sự kiện chuyển đổi, sau đó quy kết về chiến dịch quảng cáo Zalo thông qua tham số `zaclid` (Zalo Click ID).

Template này đóng gói `ztracker.js` (CDN dev: `https://dev-adtima-static.zdn.vn/ztr/ztracker.js` — chưa lên production `s.zzcdn.me`) thành GTM Custom Tag Template, hỗ trợ ba chế độ:

| Chế độ | Mục đích |
|---|---|
| **Initialize** | Tải `ztracker.js` và đăng ký Pixel ID. Chạy một lần mỗi trang với trigger `Initialization - All Pages`. |
| **Track event** | Ghi nhận sự kiện chuyển đổi (`ztrq('track', eventName, params)`). Tạo một tag riêng cho mỗi sự kiện nghiệp vụ (hoặc 1 tag dùng chung, event name lấy từ dataLayer variable — xem `GTM-SETUP.md`). |
| **Pageview (SPA)** | Gửi lượt xem trang thủ công (`ztrq('pageview')`). Chỉ cần nếu site dùng router tự viết tay — xem mục "SPA / pageview" bên dưới. |

> **Pixel V2** (bản này thay cho template V1 cũ): `contents` là **chuỗi mã trang/mã sản
> phẩm phân cách dấu phẩy** (vd. `'401,402'` — đúng theo tài liệu zalo-ads-v2, sự kiện
> dùng: `AddToWishlist`), và `track()` **luôn gửi beacon** bất kể event đã được cấu hình
> conversion trong Zalo Ads Manager hay chưa. Xem cảnh báo trùng event ở mục "Cơ chế ghi
> nhận chuyển đổi".

---

## Cơ chế hoạt động

### Luồng khởi tạo

GTM Sandbox không cho phép `injectScript` có query parameter, nên cách truyền `?id=PIXEL_ID` vào URL (dùng trong snippet tích hợp thông thường) không áp dụng được ở đây.

Thay vào đó, template dùng `window._ztrk.pid` — kênh truyền Pixel ID thứ cấp mà `ztracker.js` đọc trong constructor khi khởi tạo:

```
GTM tag kích hoạt
  → setInWindow('_ztrk', { pid: pixelId, queue: [] })   ← đặt Pixel ID TRƯỚC khi load script
  → injectScript('https://dev-adtima-static.zdn.vn/ztr/ztracker.js')
  → tracker đọc window._ztrk.pid trong constructor
  → gửi pageview beacon → https://dev-log.adtima.vn/tracklp?type=pageview&pId=...
  → fetch event config → https://dev-log.adtima.vn/ptrck/events?pixelId=...&url=...
  → window.ztrq = signalsEvents  (thay thế bất kỳ stub nào)
```

### Luồng track event

```
GTM track tag kích hoạt (Initialize đã chạy trước đó trên cùng trang)
  → injectScript (cache hit — không tải lại script)
  → callInWindow('ztrq', 'track', eventName, params)
  → handleStandardEvent kiểm tra this._events (lấy từ /ptrck/events)
  → nếu event được cấu hình trong Zalo Ads Manager → gửi beacon đến /ptrck/log
```

### Các endpoint beacon

| Endpoint (dev: `dev-log.adtima.vn`, production: `log.adtimaserver.vn`) | Khi nào gửi |
|---|---|
| `/tracklp` | Pageview, heartbeat — gửi mỗi lần script load |
| `/ptrck/events` | Lấy danh sách conversion đang active cho pixel + URL này |
| `/ptrck/log` | Conversion beacon — gửi khi event khớp với cấu hình |

---

## Cài đặt

### 1. Import template

Trong GTM: **Templates → Tag Templates → Search Gallery** → tìm **"Zalo Pixel"**.

Hoặc import thủ công: **Templates → New → Import** → chọn file `template.tpl`.

### 2. Tạo biến Pixel ID

Trong GTM: **Variables → New → Constant** → đặt tên `Zalo Pixel ID` → dán Pixel ID lấy từ **Zalo Ads Manager → Thư viện chuyển đổi → Lấy mã Pixel**.

### 3. Tạo tag Initialize

| Trường | Giá trị |
|---|---|
| Tag type | Zalo Pixel |
| Pixel ID | `{{Zalo Pixel ID}}` |
| Action | Initialize |
| Trigger | Initialization - All Pages |

### 4. Tạo tag Track event

Tạo một tag riêng cho mỗi sự kiện nghiệp vụ, ví dụ:

**Zalo Pixel — ViewContent**

| Trường | Giá trị |
|---|---|
| Tag type | Zalo Pixel |
| Pixel ID | `{{Zalo Pixel ID}}` |
| Action | Track event |
| Event type | Standard event |
| Standard event | ViewContent |
| Trigger | All Pages (hoặc trigger trang cụ thể) |

**Zalo Pixel — Purchase**

| Trường | Giá trị |
|---|---|
| Standard event | Purchase |
| currency | `VND` |
| value | `{{Transaction Revenue}}` |
| Trigger | Trang xác nhận đơn hàng |

---

## Danh sách Standard Event

| Tên event | Khi nào kích hoạt |
|---|---|
| `ViewContent` | Người dùng xem trang sản phẩm hoặc nội dung quan trọng |
| `AddToCart` | Người dùng thêm sản phẩm vào giỏ hàng |
| `AddToWishlist` | Người dùng lưu sản phẩm vào danh sách quan tâm |
| `InitiateCheckout` | Người dùng bắt đầu quy trình thanh toán |
| `AddPaymentInfo` | Người dùng nhập thông tin thanh toán |
| `Purchase` | Giao dịch hoàn tất ⚠ bắt buộc `currency` + `value` |
| `Lead` | Người dùng gửi form liên hệ / tư vấn |
| `CompleteRegistration` | Người dùng hoàn tất đăng ký tài khoản |
| `Contact` | Người dùng gọi điện, nhắn tin hoặc chat |
| `Search` | Người dùng thực hiện tìm kiếm ⚠ bắt buộc `query` |
| `Subscribe` | Người dùng bắt đầu gói đăng ký trả phí |
| `StartTrial` | Người dùng bắt đầu dùng thử |
| `Schedule` | Người dùng đặt lịch hẹn |
| `Donate` | Người dùng hoàn tất quyên góp |
| `FindLocation` | Người dùng tìm địa điểm cung cấp dịch vụ |
| `SubmitApplication` | Người dùng gửi hồ sơ hoặc đơn đăng ký |
| `CustomizeProduct` | Người dùng tùy chỉnh sản phẩm |

---

## Tham số sự kiện

Mỗi Standard event chỉ hiện đúng field khớp `SUGGESTED_PARAMS` của zalo-ads-v2
(`event-template.service.ts`) — không thừa, không thiếu. 9 event còn lại (không có
suggested params nào trong zalo-ads-v2) **không có field riêng**, chỉ dùng bảng
**Additional parameters** (key/value tự do) để thêm tham số nếu cần.

| Standard event | Field hiện ra | SUGGESTED_PARAMS khớp? |
|---|---|---|
| `ViewContent` | content_id, content_type | ✓ |
| `AddToCart` | content_id, content_type, quantity, currency, value | ✓ |
| `AddToWishlist` | content_id, contents | ✓ |
| `InitiateCheckout` | content_id, value, currency | ✓ |
| `AddPaymentInfo` | value, currency, content_id | ✓ |
| `Purchase` | value, currency, quantity, content_id, content_type | ✓ |
| `Lead` | value, currency | ✓ |
| `Search` | query | ✓ |
| `Contact`, `CompleteRegistration`, `CustomizeProduct`, `Donate`, `FindLocation`, `Schedule`, `StartTrial`, `SubmitApplication`, `Subscribe` | *(không có — dùng Additional parameters)* | zalo-ads-v2 không có suggestion |

Field `contents` là **chuỗi mã trang/mã sản phẩm phân cách dấu phẩy** (vd. `'401,402'`)
— đúng theo tài liệu zalo-ads-v2 ("Danh sách mã trang hoặc mã sản phẩm, phân cách bằng
dấu phẩy", sự kiện dùng: `AddToWishlist`). Không phải mảng — sandboxed JS forward
nguyên văn string, không transform gì cả.

Custom event (1 tag chung cho cả 17 event qua biến dataLayer) có thêm field riêng:
content_id, content_name, content_type, currency, value, quantity, contents — không bị
giới hạn theo SUGGESTED_PARAMS vì event name lúc đó là biến động, không biết trước.

Không event nào ép buộc param — field trống thì chỉ đơn giản không có mặt trong payload
gửi đi, tag vẫn fire bình thường (không có validation chặn fire nữa).

---

## Cơ chế ghi nhận chuyển đổi

**Pixel V2 = `kind=5` (`EventKind.NEW_STANDARD`, contract AS-3732).** `ztrq('track', eventName, params)` gọi `handleStandardEvent()` (`adtima-ztracker/src/index.ts:482-542`), luôn ghi `eventType: EventKind.NEW_STANDARD` (5) lên beacon — dù match hay không match với dashboard:

- **Khớp với một conversion kind=5 đã cấu hình** (dashboard match tên standard event qua `resolveStandardName()`) → gửi `eventId: event.cid` (cid thật của conversion đó).
- **Không khớp conversion nào** (event chưa cấu hình/chưa whitelist) → vẫn gửi, dùng `eventId: UNDECLARED_EVENT_ID` thay vì bỏ qua.

Cả hai trường hợp đều **gửi beacon thật**, chỉ khác giá trị `eventId`. Đây là khác biệt lớn nhất so với template V1 cũ (lúc đó event bị bỏ qua hẳn nếu chưa cấu hình conversion).

`kind=4` (`EventKind.WEB_ELEMENT`) là một kind **khác**, hoàn toàn độc lập — webElement click-detection (Event Builder: rule theo id/class/nội dung nút bấm trong Zalo Ads Manager), tracker tự gắn listener ở `document` dựa trên `/ptrck/events?pixelId=...&url=...`, không liên quan gì đến việc `track()` có được gọi hay không.

> ⚠️ **Cảnh báo trùng event — đọc kỹ trước khi cấu hình:** nếu dùng tag Track event của template này cho một hành động (vd. click nút "Mua hàng"), **tuyệt đối không** cấu hình thêm Event Builder webElement rule (id/class/text) trong Zalo Ads Manager cho **cùng** hành động đó. Hai cơ chế này độc lập và cộng dồn — bật cả hai thì cùng một lượt mua hàng bị ghi nhận **hai lần**. Chọn một cơ chế duy nhất cho mỗi event.

Đường dẫn cấu hình conversion (chỉ cần nếu bạn KHÔNG dùng GTM template mà dùng Event Builder thuần): **Zalo Ads Manager → Thư viện chuyển đổi → Tạo conversion** → liên kết với Pixel → thêm sự kiện.

### `eventTrigger` = `"GTM"` — đánh dấu nguồn gửi

Tag Track event của template này **tự động** gắn `_eventTrigger: 'GTM'` vào mọi lời gọi
`ztrq('track', ...)` nó thực hiện — không cần cấu hình gì thêm, không có field nào trên UI
cho việc này (chủ ý giấu đi, tránh người dùng xoá/sửa nhầm). Cần `adtima-ztracker` **v1.9.0
trở lên** — bản cũ hơn không nhận diện key này, nó sẽ bị lọt vào `stdParam` thay vì
`eventTrigger` thật.

`adtima-ztracker` (`handleStandardEvent()`, `src/index.ts`) nhận diện key dự trữ
`_eventTrigger` trong params, tách ra khỏi `stdParam`, forward thẳng vào field `eventTrigger`
của beacon `/ptrck/log` (contract AS-3732 §4). Nhờ vậy backend/analytics phân biệt được
conversion nào đến từ tag GTM này (`eventTrigger=GTM`) với conversion từ code JS/SDK gọi
`ztrq('track', ...)` trực tiếp (`eventTrigger` để trống như trước giờ — hành vi code thường
**không đổi gì cả**).

Pageview beacon (`/tracklp`) luôn gửi bất kể, mỗi lần script load.

---

## Kiểm tra tích hợp

Mở DevTools → tab **Network** → reload trang. Filter theo `dev-log.adtima.vn` (hoặc `adtimaserver.vn` khi đã lên production) và kiểm tra ba request theo thứ tự:

1. `GET /tracklp?type=pageview&pId=YOUR_PIXEL_ID` — tracker đã load, Pixel ID đã đăng ký
2. `GET /ptrck/events?pixelId=YOUR_PIXEL_ID&url=...` — đã fetch danh sách conversion
3. `GET /ptrck/log?pId=...&eId=...` — conversion beacon đã gửi (chỉ xuất hiện nếu có conversion được cấu hình)

**Nếu thiếu request 1:** `window._ztrk.pid` chưa được set — kiểm tra tag Initialize có đang fire trước các tag Zalo Pixel khác không.

**Nếu request 2 trả về `{"result":"fail","msg":"Item not found!"}`:** Pixel chưa có conversion nào được cấu hình trong Zalo Ads Manager, hoặc URL hiện tại không khớp với trang đích đã cấu hình.

---

## SPA / pageview

`ztracker.js` tự nhận diện React, Vue, Next.js, Nuxt, Remix, Angular, Gatsby (dò `#root`, `#app`, `#__next`, `#__nuxt`, `[ng-version]`, `#___gatsby`, hoặc global `__NEXT_DATA__`/`__NUXT__`) và **tự gửi pageview** mỗi khi `history.pushState`/`popstate`/`hashchange` đổi route. Với các framework trên, **không cần** tạo tag Pageview.

Chỉ cần tag **Zalo Pixel — Pageview (SPA)** (trigger GTM built-in **History Change**) nếu site dùng router tự viết tay, không thuộc danh sách trên. Muốn ép buộc thủ công: set `window._ztrk.spa = true` trước khi `ztracker.js` load.

## Traffic quét bot của Google (gtm-msr.appspot.com)

Google định kỳ tải lại container GTM đã publish từ `gtm-msr.appspot.com` để quét malware/nội dung độc hại — mọi tag kể cả Zalo Pixel sẽ fire **thật** trong lượt quét đó, tạo ra conversion giả (ví dụ một sự kiện `Contact` không ai thật sự bấm) trong Zalo Ads Manager. Đây là hành vi bình thường của **mọi** container GTM đã publish, không phải lỗi của template này.

**Cách lọc** (làm ở phía GTM, không cần sửa code): mở Trigger đang gắn cho tag Zalo Pixel → **Add Exception** → dùng biến built-in `{{Page Hostname}}` → điều kiện **does not equal** `gtm-msr.appspot.com`.

## Consent

Template khai báo consent type `ad_storage`. GTM sẽ chặn tag cho đến khi `ad_storage` được cấp nếu bạn đang dùng Google Consent Mode.

## Content Security Policy

Bản này trỏ CDN dev — chưa lên production `s.zzcdn.me`/`log.adtimaserver.vn`. Nếu website
có CSP, thêm vào `script-src`:

```
https://dev-adtima-static.zdn.vn
```

Và vào `connect-src`:

```
https://dev-log.adtima.vn
```

---

## Permissions

| Permission | Giá trị | Lý do |
|---|---|---|
| `inject_script` | `https://dev-adtima-static.zdn.vn/ztr/ztracker.js` | Tải tracker (dev CDN) |
| `access_globals` → `_ztrk` | read, write | Truyền Pixel ID trước khi script load |
| `access_globals` → `ztrq` | execute | Gọi tracker API sau khi load |
| `logging` | debug | Log lỗi ra console trong chế độ preview |
| `access_consent` | `ad_storage` | Tích hợp Consent Mode |

---

## Giấy phép

Apache 2.0 — xem [LICENSE](LICENSE).
