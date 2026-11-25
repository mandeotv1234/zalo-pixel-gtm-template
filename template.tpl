___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "displayName": "Zalo Pixel",
  "description": "Tích hợp Zalo Pixel vào website thông qua Google Tag Manager. Hỗ trợ chế độ Initialize (tải tracker) và Track event (ghi nhận chuyển đổi) với 17 standard events.",
  "categories": ["ADVERTISING", "CONVERSIONS", "REMARKETING"],
  "id": "cvt_zalo_pixel_v1",
  "type": "TAG",
  "version": 1,
  "brand": {
    "displayName": "Zalo",
    "id": "brand_zalo_pixel"
  },
  "containerContexts": ["WEB"],
  "securityGroups": []
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "TEXT",
    "name": "pixelId",
    "displayName": "Pixel ID",
    "simpleValueType": true,
    "alwaysInSummary": true,
    "help": "Nhập Pixel ID của bạn. Khuyến nghị: tạo một GTM Constant Variable tên <strong>Zalo Pixel ID</strong>.<br><br>Lấy Pixel ID tại: <strong>Zalo Ads Manager → Conversion Library → Lấy mã Pixel</strong>.",
    "valueValidators": [
      {
        "type": "NON_EMPTY",
        "errorMessage": "Pixel ID không được để trống."
      }
    ]
  },
  {
    "type": "RADIO",
    "name": "action",
    "displayName": "Action",
    "simpleValueType": true,
    "alwaysInSummary": true,
    "radioItems": [
      {
        "value": "initialize",
        "displayValue": "Initialize",
        "help": "Tải ztracker.js. Gắn trigger: Initialization - All Pages."
      },
      {
        "value": "track",
        "displayValue": "Track event",
        "help": "Ghi nhận một sự kiện chuyển đổi."
      }
    ],
    "defaultValue": "initialize"
  },
  {
    "type": "RADIO",
    "name": "eventType",
    "displayName": "Event type",
    "simpleValueType": true,
    "radioItems": [
      {
        "value": "standard",
        "displayValue": "Standard event"
      },
      {
        "value": "custom",
        "displayValue": "Custom event"
      }
    ],
    "defaultValue": "standard",
    "enablingConditions": [
      {
        "paramName": "action",
        "paramValue": "track",
        "type": "EQUALS"
      }
    ]
  },
  {
    "type": "SELECT",
    "name": "standardEventName",
    "displayName": "Standard event",
    "macrosInSelect": false,
    "simpleValueType": true,
    "defaultValue": "ViewContent",
    "selectItems": [
      {
        "value": "AddPaymentInfo",
        "displayValue": "AddPaymentInfo"
      },
      {
        "value": "AddToCart",
        "displayValue": "AddToCart"
      },
      {
        "value": "AddToWishlist",
        "displayValue": "AddToWishlist"
      },
      {
        "value": "CompleteRegistration",
        "displayValue": "CompleteRegistration"
      },
      {
        "value": "Contact",
        "displayValue": "Contact"
      },
      {
        "value": "CustomizeProduct",
        "displayValue": "CustomizeProduct"
      },
      {
        "value": "Donate",
        "displayValue": "Donate"
      },
      {
        "value": "FindLocation",
        "displayValue": "FindLocation"
      },
      {
        "value": "InitiateCheckout",
        "displayValue": "InitiateCheckout"
      },
      {
        "value": "Lead",
        "displayValue": "Lead"
      },
      {
        "value": "Purchase",
        "displayValue": "Purchase"
      },
      {
        "value": "Schedule",
        "displayValue": "Schedule"
      },
      {
        "value": "Search",
        "displayValue": "Search"
      },
      {
        "value": "StartTrial",
        "displayValue": "StartTrial"
      },
      {
        "value": "SubmitApplication",
        "displayValue": "SubmitApplication"
      },
      {
        "value": "Subscribe",
        "displayValue": "Subscribe"
      },
      {
        "value": "ViewContent",
        "displayValue": "ViewContent"
      }
    ],
    "enablingConditions": [
      {
        "paramName": "eventType",
        "paramValue": "standard",
        "type": "EQUALS"
      }
    ]
  },
  {
    "type": "TEXT",
    "name": "customEventName",
    "displayName": "Custom event name",
    "simpleValueType": true,
    "enablingConditions": [
      {
        "paramName": "eventType",
        "paramValue": "custom",
        "type": "EQUALS"
      }
    ],
    "valueValidators": [
      {
        "type": "NON_EMPTY",
        "errorMessage": "Tên custom event không được để trống."
      }
    ]
  },
  {
    "type": "SIMPLE_TABLE",
    "name": "additionalParams",
    "displayName": "Additional parameters",
    "help": "Tham số mở rộng key/value. Không truyền PII.",
    "simpleTableColumns": [
      {
        "defaultValue": "",
        "displayName": "key",
        "name": "key",
        "type": "TEXT"
      },
      {
        "defaultValue": "",
        "displayName": "value",
        "name": "value",
        "type": "TEXT"
      }
    ],
    "enablingConditions": [
      {
        "paramName": "action",
        "paramValue": "track",
        "type": "EQUALS"
      }
    ]
  },
  {
    "type": "GROUP",
    "name": "purchaseGroup",
    "displayName": "Purchase parameters",
    "groupStyle": "ZIPPY_OPEN",
    "enablingConditions": [
      {
        "paramName": "standardEventName",
        "paramValue": "Purchase",
        "type": "EQUALS"
      }
    ],
    "subParams": [
      {
        "type": "TEXT",
        "name": "purchaseValue",
        "displayName": "value",
        "simpleValueType": true,
        "help": "Giá trị giao dịch. Kiểu Number."
      },
      {
        "type": "TEXT",
        "name": "purchaseCurrency",
        "displayName": "currency",
        "simpleValueType": true,
        "help": "Mã tiền tệ, ví dụ: VND, USD."
      },
      {
        "type": "TEXT",
        "name": "purchaseQuantity",
        "displayName": "quantity",
        "simpleValueType": true,
        "help": "Số lượng. Kiểu Number."
      },
      {
        "type": "TEXT",
        "name": "purchaseContentId",
        "displayName": "content_id",
        "simpleValueType": true,
        "help": "ID sản phẩm."
      },
      {
        "type": "TEXT",
        "name": "purchaseContentType",
        "displayName": "content_type",
        "simpleValueType": true,
        "help": "Gán biến dataLayer, hoặc gõ tay 'product' / 'product_group'."
      }
    ]
  },
  {
    "type": "GROUP",
    "name": "addToCartGroup",
    "displayName": "AddToCart parameters",
    "groupStyle": "ZIPPY_OPEN",
    "enablingConditions": [
      {
        "paramName": "standardEventName",
        "paramValue": "AddToCart",
        "type": "EQUALS"
      }
    ],
    "subParams": [
      {
        "type": "TEXT",
        "name": "addToCartContentId",
        "displayName": "content_id",
        "simpleValueType": true,
        "help": "ID sản phẩm."
      },
      {
        "type": "TEXT",
        "name": "addToCartContentType",
        "displayName": "content_type",
        "simpleValueType": true,
        "help": "Gán biến dataLayer, hoặc gõ tay 'product' / 'product_group'."
      },
      {
        "type": "TEXT",
        "name": "addToCartQuantity",
        "displayName": "quantity",
        "simpleValueType": true,
        "help": "Số lượng. Kiểu Number."
      },
      {
        "type": "TEXT",
        "name": "addToCartCurrency",
        "displayName": "currency",
        "simpleValueType": true,
        "help": "Mã tiền tệ, ví dụ: VND, USD."
      },
      {
        "type": "TEXT",
        "name": "addToCartValue",
        "displayName": "value",
        "simpleValueType": true,
        "help": "Giá trị giao dịch. Kiểu Number."
      }
    ]
  },
  {
    "type": "GROUP",
    "name": "initiateCheckoutGroup",
    "displayName": "InitiateCheckout parameters",
    "groupStyle": "ZIPPY_OPEN",
    "enablingConditions": [
      {
        "paramName": "standardEventName",
        "paramValue": "InitiateCheckout",
        "type": "EQUALS"
      }
    ],
    "subParams": [
      {
        "type": "TEXT",
        "name": "initiateCheckoutContentId",
        "displayName": "content_id",
        "simpleValueType": true,
        "help": "ID sản phẩm."
      },
      {
        "type": "TEXT",
        "name": "initiateCheckoutValue",
        "displayName": "value",
        "simpleValueType": true,
        "help": "Giá trị giao dịch. Kiểu Number."
      },
      {
        "type": "TEXT",
        "name": "initiateCheckoutCurrency",
        "displayName": "currency",
        "simpleValueType": true,
        "help": "Mã tiền tệ, ví dụ: VND, USD."
      }
    ]
  },
  {
    "type": "GROUP",
    "name": "addPaymentInfoGroup",
    "displayName": "AddPaymentInfo parameters",
    "groupStyle": "ZIPPY_OPEN",
    "enablingConditions": [
      {
        "paramName": "standardEventName",
        "paramValue": "AddPaymentInfo",
        "type": "EQUALS"
      }
    ],
    "subParams": [
      {
        "type": "TEXT",
        "name": "addPaymentInfoValue",
        "displayName": "value",
        "simpleValueType": true,
        "help": "Giá trị giao dịch. Kiểu Number."
      },
      {
        "type": "TEXT",
        "name": "addPaymentInfoCurrency",
        "displayName": "currency",
        "simpleValueType": true,
        "help": "Mã tiền tệ, ví dụ: VND, USD."
      },
      {
        "type": "TEXT",
        "name": "addPaymentInfoContentId",
        "displayName": "content_id",
        "simpleValueType": true,
        "help": "ID sản phẩm."
      }
    ]
  },
  {
    "type": "GROUP",
    "name": "addToWishlistGroup",
    "displayName": "AddToWishlist parameters",
    "groupStyle": "ZIPPY_OPEN",
    "enablingConditions": [
      {
        "paramName": "standardEventName",
        "paramValue": "AddToWishlist",
        "type": "EQUALS"
      }
    ],
    "subParams": [
      {
        "type": "TEXT",
        "name": "addToWishlistContentId",
        "displayName": "content_id",
        "simpleValueType": true,
        "help": "ID sản phẩm."
      },
      {
        "type": "TEXT",
        "name": "addToWishlistContents",
        "displayName": "contents",
        "simpleValueType": true,
        "help": "Danh sách mã trang hoặc mã sản phẩm, phân cách bằng dấu phẩy. Gán biến dataLayer hoặc gõ tay, vd. '401,402'."
      }
    ]
  },
  {
    "type": "GROUP",
    "name": "viewContentGroup",
    "displayName": "ViewContent parameters",
    "groupStyle": "ZIPPY_OPEN",
    "enablingConditions": [
      {
        "paramName": "standardEventName",
        "paramValue": "ViewContent",
        "type": "EQUALS"
      }
    ],
    "subParams": [
      {
        "type": "TEXT",
        "name": "viewContentContentId",
        "displayName": "content_id",
        "simpleValueType": true,
        "help": "ID sản phẩm."
      },
      {
        "type": "TEXT",
        "name": "viewContentContentType",
        "displayName": "content_type",
        "simpleValueType": true,
        "help": "Gán biến dataLayer, hoặc gõ tay 'product' / 'product_group'."
      }
    ]
  },
  {
    "type": "GROUP",
    "name": "leadGroup",
    "displayName": "Lead parameters",
    "groupStyle": "ZIPPY_OPEN",
    "enablingConditions": [
      {
        "paramName": "standardEventName",
        "paramValue": "Lead",
        "type": "EQUALS"
      }
    ],
    "subParams": [
      {
        "type": "TEXT",
        "name": "leadValue",
        "displayName": "value",
        "simpleValueType": true,
        "help": "Giá trị giao dịch. Kiểu Number."
      },
      {
        "type": "TEXT",
        "name": "leadCurrency",
        "displayName": "currency",
        "simpleValueType": true,
        "help": "Mã tiền tệ, ví dụ: VND, USD."
      }
    ]
  },
  {
    "type": "GROUP",
    "name": "searchGroup",
    "displayName": "Search parameters",
    "groupStyle": "ZIPPY_OPEN",
    "enablingConditions": [
      {
        "paramName": "standardEventName",
        "paramValue": "Search",
        "type": "EQUALS"
      }
    ],
    "subParams": [
      {
        "type": "TEXT",
        "name": "searchQuery",
        "displayName": "query",
        "simpleValueType": true,
        "help": "Từ khóa tìm kiếm."
      }
    ]
  },
  {
    "type": "GROUP",
    "name": "customEventGroup",
    "displayName": "Custom event parameters",
    "groupStyle": "ZIPPY_OPEN",
    "enablingConditions": [
      {
        "paramName": "eventType",
        "paramValue": "custom",
        "type": "EQUALS"
      }
    ],
    "subParams": [
      {
        "type": "TEXT",
        "name": "customEventValue",
        "displayName": "value",
        "simpleValueType": true,
        "help": "Giá trị giao dịch. Kiểu Number."
      },
      {
        "type": "TEXT",
        "name": "customEventCurrency",
        "displayName": "currency",
        "simpleValueType": true,
        "help": "Mã tiền tệ, ví dụ: VND, USD."
      },
      {
        "type": "TEXT",
        "name": "customEventContentId",
        "displayName": "content_id",
        "simpleValueType": true,
        "help": "ID sản phẩm / nội dung."
      },
      {
        "type": "TEXT",
        "name": "customEventContentName",
        "displayName": "content_name",
        "simpleValueType": true,
        "help": "Tên sản phẩm. Không chứa PII."
      },
      {
        "type": "TEXT",
        "name": "customEventContentType",
        "displayName": "content_type",
        "simpleValueType": true,
        "help": "Gán biến dataLayer (vd. {{DLV - zp_content_type}}), hoặc gõ tay 'product' / 'product_group'."
      },
      {
        "type": "TEXT",
        "name": "customEventQuantity",
        "displayName": "quantity",
        "simpleValueType": true,
        "help": "Số lượng. Kiểu Number."
      },
      {
        "type": "TEXT",
        "name": "customEventContents",
        "displayName": "contents",
        "simpleValueType": true,
        "help": "Danh sách mã trang hoặc mã sản phẩm, phân cách bằng dấu phẩy. Gán biến dataLayer (vd. {{DLV - zp_contents}}) hoặc gõ tay, vd. '401,402'."
      }
    ]
  }
]

___SANDBOXED_JS_FOR_WEB_TEMPLATE___

const callInWindow = require('callInWindow');
const injectScript = require('injectScript');
const makeTableMap = require('makeTableMap');
const makeNumber   = require('makeNumber');
const setInWindow  = require('setInWindow');
const log          = require('logToConsole');

// Dev CDN (ztracker build mới nhất, logApi = dev-log.adtima.vn) — chưa lên production
// s.zzcdn.me. Đổi lại sang production khi publish template lên Gallery.
const TRACKER_BASE = 'https://dev-adtima-static.zdn.vn/ztr/ztracker.js';
const pixelId = data.pixelId;

const fail = function(msg) {
  log('[Zalo Pixel] ' + msg);
  data.gtmOnFailure();
};

if (!pixelId) return fail('Pixel ID is required.');

const cacheToken = TRACKER_BASE + '#' + pixelId;
setInWindow('_ztrk', {pid: pixelId, queue: []}, false);

if (data.action === 'initialize') {
  injectScript(TRACKER_BASE, data.gtmOnSuccess, data.gtmOnFailure, cacheToken);

} else {
  // ── Track event ───────────────────────────────────────────────────────────
  const eventName = data.eventType === 'standard'
    ? data.standardEventName
    : data.customEventName;

  if (!eventName) return fail('Event name is required.');

  // Each event group prefixes its subParams with the event camelCase key.
  // Only the active group's fields have values; inactive groups return undefined.
  const evtKey = data.eventType === 'standard'
    ? eventName.charAt(0).toLowerCase() + eventName.slice(1)
    : 'customEvent';

  const value         = data[evtKey + 'Value'];
  const currency      = data[evtKey + 'Currency'];
  const contentId     = data[evtKey + 'ContentId'];
  const contentName   = data[evtKey + 'ContentName'];
  const contentType   = data[evtKey + 'ContentType'];
  const contentCategory = data[evtKey + 'ContentCategory'];
  const price         = data[evtKey + 'Price'];
  const quantity      = data[evtKey + 'Quantity'];
  const contents      = data[evtKey + 'Contents'];
  const query         = data[evtKey + 'Query'];

  const additionalParams = data.additionalParams;

  // Không hard-fail khi thiếu query (Search)/currency+value (Purchase) nữa — field nào
  // trống thì chỉ đơn giản không có mặt trong params, tag vẫn fire bình thường. SUGGESTED_PARAMS
  // của zalo-ads-v2 chỉ là gợi ý hiển thị, không phải điều kiện bắt buộc trong code.

  // ── Build payload ─────────────────────────────────────────────────────────
  const params = {};

  if (contentId)       params.content_id       = contentId;
  if (contentName)     params.content_name     = contentName;
  if (contentType)     params.content_type     = contentType;
  if (contentCategory) params.content_category = contentCategory;
  if (currency)        params.currency         = currency;
  if (value !== undefined && value !== '')
    params.value    = makeNumber(value);
  if (price !== undefined && price !== '')
    params.price    = makeNumber(price);
  if (quantity !== undefined && quantity !== '')
    params.quantity = makeNumber(quantity);
  if (query)           params.query            = query;

  // contents: chuỗi mã trang/mã sản phẩm phân cách dấu phẩy (vd. '401,402') — đúng theo
  // tài liệu zalo-ads-v2 ("Danh sách mã trang hoặc mã sản phẩm, phân cách bằng dấu phẩy",
  // sự kiện dùng: AddToWishlist). Không phải mảng — field TEXT nhận thẳng string, không
  // cần map/transform gì cả.
  if (contents) params.contents = contents;

  if (additionalParams && additionalParams.length) {
    const extra = makeTableMap(additionalParams, 'key', 'value');
    for (const k in extra) {
      if (!params.hasOwnProperty(k)) params[k] = extra[k];
    }
  }

  // _eventTrigger is a reserved key adtima-ztracker (v1.9.0+) recognizes on track() — it
  // strips this out before building stdParam and forwards it as the real eventTrigger field
  // on /ptrck/log, so the backend can tell GTM-originated conversions apart from plain
  // website/SDK track() calls (which never set this, so their eventTrigger stays empty, same
  // as before). Set last, after additionalParams, so a stray "Additional parameter" row
  // named _eventTrigger can never override it.
  params._eventTrigger = 'GTM';

  injectScript(TRACKER_BASE, function() {
    callInWindow('ztrq', 'track', eventName, params);
    data.gtmOnSuccess();
  }, data.gtmOnFailure, cacheToken);
}

___WEB_PERMISSIONS___

[
  {
    "instance": {
      "key": {"publicId": "access_globals", "versionId": "1"},
      "param": [
        {
          "key": "keys",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  {"type": 1, "string": "key"},
                  {"type": 1, "string": "read"},
                  {"type": 1, "string": "write"},
                  {"type": 1, "string": "execute"}
                ],
                "mapValue": [
                  {"type": 1, "string": "ztrq"},
                  {"type": 8, "boolean": false},
                  {"type": 8, "boolean": false},
                  {"type": 8, "boolean": true}
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {"type": 1, "string": "key"},
                  {"type": 1, "string": "read"},
                  {"type": 1, "string": "write"},
                  {"type": 1, "string": "execute"}
                ],
                "mapValue": [
                  {"type": 1, "string": "_ztrk"},
                  {"type": 8, "boolean": true},
                  {"type": 8, "boolean": true},
                  {"type": 8, "boolean": false}
                ]
              }
            ]
          }
        }
      ]
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {"publicId": "inject_script", "versionId": "1"},
      "param": [
        {
          "key": "urls",
          "value": {
            "type": 2,
            "listItem": [
              {"type": 1, "string": "https://dev-adtima-static.zdn.vn/ztr/ztracker.js"}
            ]
          }
        }
      ]
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {"publicId": "logging", "versionId": "1"},
      "param": [
        {
          "key": "environments",
          "value": {"type": 1, "string": "debug"}
        }
      ]
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {"publicId": "access_consent", "versionId": "1"},
      "param": [
        {
          "key": "consentTypes",
          "value": {
            "type": 2,
            "listItem": [
              {"type": 1, "string": "ad_storage"}
            ]
          }
        }
      ]
    },
    "isRequired": false
  }
]


___TESTS___

scenarios:
- name: Initialize - injects script URL
  code: |-
    mockData.action = 'initialize';
    var capturedUrl;
    mock('injectScript', function(url, onSuccess) { capturedUrl = url; onSuccess(); });
    runCode(mockData);
    assertThat(capturedUrl).isEqualTo('https://dev-adtima-static.zdn.vn/ztr/ztracker.js');
    assertApi('gtmOnSuccess').wasCalled();

- name: Track - ViewContent fires with just the reserved _eventTrigger marker
  code: |-
    mockData.action = 'track';
    mockData.eventType = 'standard';
    mockData.standardEventName = 'ViewContent';
    runCode(mockData);
    assertApi('callInWindow').wasCalledWith('ztrq', 'track', 'ViewContent', { _eventTrigger: 'GTM' });
    assertApi('gtmOnSuccess').wasCalled();

- name: Track - custom event fires with correct name
  code: |-
    mockData.action = 'track';
    mockData.eventType = 'custom';
    mockData.customEventName = 'BookDemo';
    runCode(mockData);
    assertApi('callInWindow').wasCalledWith('ztrq', 'track', 'BookDemo', { _eventTrigger: 'GTM' });
    assertApi('gtmOnSuccess').wasCalled();

- name: Track - custom event forwards content_id and content_type
  code: |-
    mockData.action = 'track';
    mockData.eventType = 'custom';
    mockData.customEventName = 'AddToCart';
    mockData.customEventContentId = 'sp001';
    mockData.customEventContentType = 'product';
    runCode(mockData);
    assertApi('callInWindow').wasCalledWith('ztrq', 'track', 'AddToCart', {
      content_id: 'sp001',
      content_type: 'product',
      _eventTrigger: 'GTM'
    });
    assertApi('gtmOnSuccess').wasCalled();

- name: Track - custom event contents bound to a variable forwards the raw string
  code: |-
    mockData.action = 'track';
    mockData.eventType = 'custom';
    mockData.customEventName = 'Purchase';
    mockData.customEventContents = '401,402';
    runCode(mockData);
    assertApi('callInWindow').wasCalledWith('ztrq', 'track', 'Purchase', {
      contents: '401,402',
      _eventTrigger: 'GTM'
    });
    assertApi('gtmOnSuccess').wasCalled();

- name: Track - custom event contents left blank (no variable bound) does not throw
  code: |-
    mockData.action = 'track';
    mockData.eventType = 'custom';
    mockData.customEventName = 'Contact';
    mockData.customEventContents = undefined;
    runCode(mockData);
    assertApi('callInWindow').wasCalledWith('ztrq', 'track', 'Contact', { _eventTrigger: 'GTM' });
    assertApi('gtmOnSuccess').wasCalled();

- name: Track - Search missing query still fires (no longer required)
  code: |-
    mockData.action = 'track';
    mockData.eventType = 'standard';
    mockData.standardEventName = 'Search';
    mockData.searchQuery = '';
    runCode(mockData);
    assertApi('callInWindow').wasCalledWith('ztrq', 'track', 'Search', { _eventTrigger: 'GTM' });
    assertApi('gtmOnSuccess').wasCalled();

- name: Track - Search with query succeeds
  code: |-
    mockData.action = 'track';
    mockData.eventType = 'standard';
    mockData.standardEventName = 'Search';
    mockData.searchQuery = 'giày thể thao';
    runCode(mockData);
    assertApi('gtmOnSuccess').wasCalled();

- name: Track - Purchase missing currency still fires (no longer required)
  code: |-
    mockData.action = 'track';
    mockData.eventType = 'standard';
    mockData.standardEventName = 'Purchase';
    mockData.purchaseCurrency = '';
    mockData.purchaseValue = 500000;
    runCode(mockData);
    assertApi('callInWindow').wasCalledWith('ztrq', 'track', 'Purchase', { value: 500000, _eventTrigger: 'GTM' });
    assertApi('gtmOnSuccess').wasCalled();

- name: Track - Purchase with currency and value succeeds
  code: |-
    mockData.action = 'track';
    mockData.eventType = 'standard';
    mockData.standardEventName = 'Purchase';
    mockData.purchaseCurrency = 'VND';
    mockData.purchaseValue = 500000;
    runCode(mockData);
    assertApi('gtmOnSuccess').wasCalled();

- name: Track - AddToWishlist contents forwards the comma-separated id string
  code: |-
    mockData.action = 'track';
    mockData.eventType = 'standard';
    mockData.standardEventName = 'AddToWishlist';
    mockData.addToWishlistContents = '401,402';
    runCode(mockData);
    assertApi('callInWindow').wasCalledWith('ztrq', 'track', 'AddToWishlist', {
      contents: '401,402',
      _eventTrigger: 'GTM'
    });
    assertApi('gtmOnSuccess').wasCalled();

- name: Track - always marks the submission as GTM-originated via _eventTrigger
  code: |-
    mockData.action = 'track';
    mockData.eventType = 'custom';
    mockData.customEventName = 'AnyEvent';
    mockData.additionalParams = [{ key: '_eventTrigger', value: 'not-gtm' }];
    runCode(mockData);
    // additionalParams can never override the reserved key — set last, wins regardless of order.
    assertApi('callInWindow').wasCalledWith('ztrq', 'track', 'AnyEvent', { _eventTrigger: 'GTM' });
    assertApi('gtmOnSuccess').wasCalled();

- name: Missing pixelId fails immediately
  code: |-
    mockData.pixelId = '';
    runCode(mockData);
    assertApi('gtmOnFailure').wasCalled();
    assertApi('injectScript').wasNotCalled();

setup: |-
  mock('setInWindow', function() {});
  mock('callInWindow', function() {});
  mock('injectScript', function(url, onSuccess) { onSuccess(); });
  mock('makeTableMap', function(arr, k, v) {
    if (!arr) return {};
    var r = {};
    for (var i = 0; i < arr.length; i++) r[arr[i][k]] = arr[i][v];
    return r;
  });
  mock('makeNumber', function(val) { return val * 1; });
  mock('logToConsole', function() {});
  var mockData = {
    pixelId: '7060000000000000001',
    action: 'initialize',
    eventType: 'standard',
    standardEventName: 'ViewContent',
    customEventName: '',
    contentId: '', contentName: '', contentType: '', contentCategory: '',
    eventId: '', additionalParams: [],
    purchaseCurrency: '', purchaseValue: '',
    searchQuery: '',
    addToWishlistContents: ''
  };


___NOTES___

# Zalo Pixel Custom Tag Template
Version: 2.0.0 (Pixel V2)
Repository: https://github.com/[org]/zalo-pixel-gtm-template

## V1 → V2 — những gì đã đổi

1. **`contents` đổi từ chuỗi phân cách phẩy sang mảng object.**
   V1 gửi `contents: 'sku-001,sku-002'`. Pixel V2 (adtima-ztracker, xác nhận
   qua test thực tế trên zaui-market + landing-page) nhận
   `contents: [{id, quantity}, ...]`. Mỗi bảng "contents — danh sách sản phẩm"
   giờ có thêm cột `quantity` (mặc định 1 nếu để trống).

2. **`ztrq('track', eventName, params)` = `kind=5` (`EventKind.NEW_STANDARD`,
   contract AS-3732) và giờ LUÔN gửi beacon.** `handleStandardEvent()`
   (adtima-ztracker `src/index.ts:482-542`) luôn log `eventType: 5`: khớp
   conversion kind=5 đã cấu hình thì gửi `eventId` = cid thật; không khớp gì
   thì vẫn gửi, dùng `eventId: UNDECLARED_EVENT_ID`. Khác với giả định V1
   rằng event bị "nuốt" nếu chưa cấu hình conversion.
   → **Cảnh báo bắt buộc đọc**: `kind=4` (`EventKind.WEB_ELEMENT`, Event
   Builder webElement id/class/text) là một kind khác, độc lập hoàn toàn với
   kind=5. Nếu dùng tag Track event của template này cho một hành động,
   TUYỆT ĐỐI không cấu hình thêm Event Builder webElement rule trong Zalo
   Ads Manager cho CÙNG hành động đó — hai kind cộng dồn, bật cả hai =
   conversion bị đếm hai lần. Chọn một.

## Cấu trúc tag khuyến nghị

1. Tạo tag **Zalo Pixel – Initialize**
   - Action: Initialize
   - Trigger: Initialization - All Pages
   - Cấu hình consent trước khi tag chạy (ad_storage)

2. Tạo tag riêng cho mỗi event nghiệp vụ (hoặc 1 tag Track event dùng chung,
   event name lấy từ dataLayer variable — xem GTM-SETUP.md), ví dụ:
   - **Zalo Pixel – ViewContent**: trigger = All Pages (hoặc trang cụ thể)
   - **Zalo Pixel – Lead**: trigger = Form Submit
   - **Zalo Pixel – Purchase**: trigger = Order Confirmation Page

## Quản lý Pixel ID

Tạo một GTM Constant Variable tên "Zalo Pixel ID" chứa Pixel ID.
Truyền {{Zalo Pixel ID}} vào field Pixel ID của mọi tag.
Khi cần đổi môi trường staging/production, chỉ cần đổi một chỗ.

## CSP

Bản này trỏ CDN dev (`dev-adtima-static.zdn.vn`, logApi `dev-log.adtima.vn`) — chưa lên
production `s.zzcdn.me`/`log.adtimaserver.vn`. Nếu website có Content Security Policy,
thêm domain sau vào script-src:
  dev-adtima-static.zdn.vn
Và vào connect-src:
  dev-log.adtima.vn

## Traffic quét bot của Google (gtm-msr.appspot.com)

Google định kỳ tải lại container đã publish từ `gtm-msr.appspot.com` để quét
malware — mọi tag (kể cả Zalo Pixel) sẽ fire thật trong lượt quét này, tạo ra
conversion giả trong Zalo Ads Manager. Đây là hành vi bình thường của mọi GTM
container đã publish, không phải lỗi của template này.

**Cách lọc (ở tầng GTM, không cần sửa template):** vào Trigger của tag
Zalo Pixel → thêm **Trigger Exception** mới dùng biến built-in
`{{Page Hostname}}` → điều kiện "does not equal" `gtm-msr.appspot.com`.

## Tracker contract

Pixel ID is passed via window._ztrk.pid (set BEFORE injectScript).
ztracker.js reads _ztrk.pid in constructor → calls pageView → fetches /ptrck/events.
After script load: ztrq('track', eventName, params) via injectScript callback.

ztrq('track', eventName, params) → handleStandardEvent() → logs kind=5
(EventKind.NEW_STANDARD, contract AS-3732) ALWAYS — matched dashboard conversion
uses its real cid, unmatched falls back to UNDECLARED_EVENT_ID, but a beacon is
sent either way (Pixel V2).
kind=4 (EventKind.WEB_ELEMENT) is a separate, additive mechanism — ztracker.js's
own webElement click-detection via /ptrck/events (Event Builder rules) — not a
gate on track()/kind=5.
Pageview (/tracklp) fires automatically on every script load regardless.

Params: content_id, content_name, content_type, content_category,
        currency, value, price, quantity, query,
        contents (array of {id, quantity}), event_id
