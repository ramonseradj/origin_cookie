___INFO___

{
  "type": "MACRO",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "Origin Cookie Extractor",
  "description": "",
  "containerContexts": [
    "SERVER"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "TEXT",
    "name": "cookiename",
    "displayName": "Cookie name",
    "simpleValueType": true
  },
  {
    "type": "TEXT",
    "name": "object_property",
    "displayName": "Key",
    "simpleValueType": true,
    "help": "You can use dot notation for getting a nested property. For example `data.user.email`",
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ]
  },
  {
    "type": "CHECKBOX",
    "name": "base64decode",
    "checkboxText": "Check if cookie value is base64 encoded.",
    "simpleValueType": true
  }
]


___SANDBOXED_JS_FOR_SERVER___

const JSON = require('JSON');
const logToConsole = require('logToConsole');
const getCookieValues = require('getCookieValues');
const fromBase64 = require('fromBase64');

let cookie = getCookieValues(data.cookiename)[0];

if (data.base64decode) {
  cookie = fromBase64(cookie);
}

const parsedOBj = JSON.parse(cookie);
const property = data.object_property;

if (typeof parsedOBj[property] == "object" ) {
  return parsedOBj[property][0];
} else {
  return parsedOBj[property];
}


___SERVER_PERMISSIONS___

[
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

Created on 30/09/2021, 18:10:20


