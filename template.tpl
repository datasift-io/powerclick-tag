___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "TAG",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "PowerClick",
  "categories": [
    "ATTRIBUTION",
    "ANALYTICS"
  ],
  "brand": {
    "id": "brand_dummy",
    "displayName": "PowerClick"
  },
  "description": "Loads PowerClick click attribution for your account. Enter your PowerClick Account ID and fire on Initialization - All Pages. Consent is handled by PowerClick using Google Consent Mode.",
  "containerContexts": [
    "WEB"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "TEXT",
    "name": "accountId",
    "displayName": "Account ID",
    "simpleValueType": true,
    "help": "Your PowerClick Account ID, from your PowerClick onboarding.",
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      },
      {
        "type": "REGEX",
        "args": [
          "^[A-Za-z0-9_-]{1,100}$"
        ]
      }
    ]
  },
  {
    "type": "TEXT",
    "name": "scriptUrl",
    "displayName": "First-party script URL (optional)",
    "simpleValueType": true,
    "help": "Only with the PowerClick First-Party Proxy client in your server container: https://&lt;your server container domain&gt;&lt;its Script path&gt;, e.g. https://ss.example.com/c/l.js. Also add that domain under this template's Permissions → Injects scripts. Leave empty to load from js.powerclick.io.",
    "valueValidators": [
      {
        "type": "REGEX",
        "args": [
          "^(https://[A-Za-z0-9.-]+(:[0-9]+)?/[A-Za-z0-9._~/-]*)?$"
        ]
      }
    ]
  }
]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

// Deliberately nothing but the script load: all PowerClick logic lives in the hosted loader, so this
// template never needs an update (gallery updates need the tenant to accept them).
const injectScript = require('injectScript');
const encodeUriComponent = require('encodeUriComponent');

// First-party install: the tenant's sGTM proxy client serves the same loader from their own domain and knows
// the account itself, so the URL carries no id. Its domain must also be in this template's inject permission.
const url = data.scriptUrl || ('https://js.powerclick.io/pc.js?id=' + encodeUriComponent(data.accountId));
// cacheToken = url: firing on more than one trigger still loads the script once.
injectScript(url, data.gtmOnSuccess, data.gtmOnFailure, url);


___WEB_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "inject_script",
        "versionId": "1"
      },
      "param": [
        {
          "key": "urls",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 1,
                "string": "https://js.powerclick.io/*"
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
  }
]


___TESTS___

scenarios:
- name: Injects the loader for the account and reports success
  code: |-
    mock('injectScript', (url, onSuccess) => {
      assertThat(url).isEqualTo('https://js.powerclick.io/pc.js?id=acme');
      onSuccess();
    });
    runCode({accountId: 'acme'});
    assertApi('gtmOnSuccess').wasCalled();
- name: Loads from the first-party URL when set
  code: |-
    mock('injectScript', (url, onSuccess) => {
      assertThat(url).isEqualTo('https://ss.example.com/c/l.js');
      onSuccess();
    });
    runCode({accountId: 'acme', scriptUrl: 'https://ss.example.com/c/l.js'});
    assertApi('gtmOnSuccess').wasCalled();
