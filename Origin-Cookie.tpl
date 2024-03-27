___INFO___

{
  "type": "TAG",
  "id": "cvt_temp_public_id",
  "__wm": "VGVtcGxhdGUtQXV0aG9yX0Nvb2tpZU1vbnN0ZXItU2ltby1BaGF2YQ\u003d\u003d",
  "categories": [
    "UTILITY"
  ],
  "version": 1,
  "securityGroups": [],
  "displayName": "Origin Cookie",
  "brand": {
    "id": "github.com_gtm-templates-simo-ahava",
    "displayName": "Ramon\u0027s sGTM Templates"
  },
  "description": "",
  "containerContexts": [
    "SERVER"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "PARAM_TABLE",
    "name": "cookieContent",
    "displayName": "Cookie contents",
    "paramTableColumns": [
      {
        "param": {
          "type": "TEXT",
          "name": "name",
          "displayName": "name",
          "simpleValueType": true
        },
        "isUnique": true
      },
      {
        "param": {
          "type": "TEXT",
          "name": "value",
          "displayName": "value",
          "simpleValueType": true
        },
        "isUnique": false
      },
      {
        "param": {
          "type": "CHECKBOX",
          "name": "updateData",
          "checkboxText": "Update value when tag fires and new value is defined.",
          "simpleValueType": true
        },
        "isUnique": false
      }
    ]
  },
  {
    "type": "TEXT",
    "name": "cookieName",
    "displayName": "Cookie Name",
    "simpleValueType": true
  },
  {
    "type": "TEXT",
    "name": "cookieExpiration",
    "displayName": "Cookie Expiration. \"0\" equals Session-Cookie",
    "simpleValueType": true
  },
  {
    "type": "TEXT",
    "name": "cookieDomain",
    "displayName": "Cookie domain",
    "simpleValueType": true,
    "defaultValue": "auto"
  },
  {
    "type": "CHECKBOX",
    "name": "cookieEncodeValue",
    "checkboxText": "Encode Value",
    "simpleValueType": true
  },
  {
    "type": "CHECKBOX",
    "name": "cookieHttpOnly",
    "checkboxText": "HTTP only Cookie",
    "simpleValueType": true
  },
  {
    "type": "SELECT",
    "name": "cookieSameSite",
    "displayName": "",
    "macrosInSelect": true,
    "selectItems": [
      {
        "value": "lax",
        "displayValue": "lax"
      },
      {
        "value": "strict",
        "displayValue": "strict"
      },
      {
        "value": "none",
        "displayValue": "none"
      }
    ],
    "simpleValueType": true
  },
  {
    "type": "CHECKBOX",
    "name": "firstHitTs",
    "checkboxText": "Set first_hit_timestamp",
    "simpleValueType": true
  },
  {
    "type": "CHECKBOX",
    "name": "lastHitTs",
    "checkboxText": "Set lastest_hit_timestamp",
    "simpleValueType": true
  },
  {
    "type": "CHECKBOX",
    "name": "toBase64",
    "checkboxText": "base64 encode value",
    "simpleValueType": true
  }
]


___SANDBOXED_JS_FOR_SERVER___

// Load template APIs
const setCookie = require('setCookie');
const getCookieValues = require('getCookieValues');
const getEventData = require('getEventData');
const JSON = require('JSON');
const logToConsole = require('logToConsole');
const parseUrl = require('parseUrl');
const parsedUrl = parseUrl(getEventData('page_location'));
const fromBase64 = require('fromBase64');
const toBase64 = require('toBase64');
const generateRandom = require('generateRandom');

// Declare constants
const randomValue = generateRandom(10000000, 99999999);
const ts = getEventData('timestamp');
const id = randomValue + "." + getEventData('timestamp');
const cookie_data = data.cookieContent;
const ex_cookie = (getCookieValues(data.cookieName)[0]) ? getCookieValues(data.cookieName)[0] : undefined;

// Declare empty object to store cookie data
let cookieContents = {};

// Set new cookie if non.existent.
if (!ex_cookie) {
  logToConsole('Set new Cookie');
  cookieContents['session_id'] = id;
  cookie_data.forEach(row => {
    if (row.value) {
      cookieContents[row.name] = row.value;
    }
  });
  if (data.firstHitTs) {
    cookieContents['first_hit_timestamp'] = ts;
  }
  if (data.lastHitTs) {
    cookieContents['lastest_hit_timestamp'] = ts;
  }
// Update existing cookie.
} else {
  if (data.toBase64) {
    cookieContents = fromBase64(ex_cookie);
  } else {
    cookieContents = ex_cookie;
  }
  cookieContents = JSON.parse(cookieContents);
  if (data.lastHitTs) {
    cookieContents['lastest_hit_timestamp'] = ts;
  }
  cookie_data.forEach(row => {
    if (row.value && row.updateData) {
      cookieContents[row.name] = row.value;
    }
  });
}

// Log Object to Debug console.
logToConsole(cookieContents);

// Set cookie
let stringValue = JSON.stringify(cookieContents);
stringValue = (data.toBase64) ? toBase64(stringValue) : stringValue;
const name = data.cookieName;
const value = stringValue;
const options = {
  domain: data.cookieDomain,
  path: '/',
  secure: true,
  sameSite: data.cookieSameSite
};
if (data.cookieExpiration > 0) options['max-age'] = data.cookieExpiration;
if (data.cookieHttpOnly) options.HttpOnly = data.cookieHttpOnly;
setCookie(name, value, options, !data.cookieEncodeValue);

data.gtmOnSuccess();


___SERVER_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "set_cookies",
        "versionId": "1"
      },
      "param": [
        {
          "key": "allowedCookies",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "name"
                  },
                  {
                    "type": 1,
                    "string": "domain"
                  },
                  {
                    "type": 1,
                    "string": "path"
                  },
                  {
                    "type": 1,
                    "string": "secure"
                  },
                  {
                    "type": 1,
                    "string": "session"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "*"
                  },
                  {
                    "type": 1,
                    "string": "*"
                  },
                  {
                    "type": 1,
                    "string": "*"
                  },
                  {
                    "type": 1,
                    "string": "secure"
                  },
                  {
                    "type": 1,
                    "string": "any"
                  }
                ]
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "read_event_data",
        "versionId": "1"
      },
      "param": [
        {
          "key": "eventDataAccess",
          "value": {
            "type": 1,
            "string": "any"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "logging",
        "versionId": "1"
      },
      "param": [
        {
          "key": "environments",
          "value": {
            "type": 1,
            "string": "debug"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "get_cookies",
        "versionId": "1"
      },
      "param": [
        {
          "key": "cookieAccess",
          "value": {
            "type": 1,
            "string": "any"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  }
]


___TESTS___

scenarios: []


___NOTES___

Created on 26/03/2021, 10:04:45


