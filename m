From: Seiji Aguchi <seiji.aguchi@hds.com>
Subject: RE: [PATCH v5 -next 1/2]efivars: Disable external interrupt while
 holding efivars->lock
Date: Mon, 11 Feb 2013 16:34:33 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D414A8FFF2@USINDEM103.corp.hds.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D414A541B5@USINDEM103.corp.hds.com>
 <1360440158.7515.321.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1360440158.7515.321.camel@mfleming-mobl1.ger.corp.intel.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@console-pimps.org>, "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "mikew@google.com" <mikew@google.com>, "cbouatmailru@gmail.com" <cbouatmailru@gmail.com>, "dzickus@redhat.com" <dzickus@redhat.com>, "dle-develop@lists.sourceforge.net" <dle-develop@lists.sourceforge.net>, Satoru Moriya <satoru.moriya@hds.com>
List-Id: linux-efi@vger.kernel.org

TWF0dCwNCg0KPiBBY2tlZC1ieTogTWF0dCBGbGVtaW5nIDxtYXR0LmZsZW1pbmdAaW50ZWwuY29t
Pg0KPiANCj4gVG9ueSwgYXJlIHlvdSBwaWNraW5nIHRoaXMgdXA/DQoNClRoYW5rIHlvdSBmb3Ig
cmV2aWV3aW5nIGFuZCBhY2tpbmcgbXkgcGF0Y2hzZXQuDQoNClRvbnksDQoNClRoaXMgcGF0Y2hz
ZXQgY2FuJ3QgYmUgYXBwbGllZCB0byBhIGxhdGVzdCBuZXh0IHRyZWUgZHVlIHRvIGZvbGxvd2lu
ZyBjb21taXRzLg0KSSB3aWxsIHBvc3QgdjYgc2hvcnRseSB0byBmaXQgdGhlIGxhdGVzdCBuZXh0
IHRyZWUuDQpUaGVuLCBwbGVhc2UgYXBwbHkgaXQuDQoNCmVmaTogTWFrZSAnZWZpX2VuYWJsZWQn
IGEgZnVuY3Rpb24gdG8gcXVlcnkgRUZJIGZhY2lsaXRpZXMNCmNvbW1pdCA4M2U2ODE4OTc0NWFk
OTMxYzJhZmQ0NWQ4ZWUzMzAzOTI5MjMzZTdmDQoNCmVmaXZhcmZzOiBEZWxldGUgZGVudHJ5IGZy
b20gZGNhY2hlIGluIGVmaXZhcmZzX2ZpbGVfd3JpdGUoKQ0KY29tbWl0ICA3OTFlYjU2NGQyMThk
YWJlMGY5YTIyMTI5MTZmZTU0MjQwYjk3YWZiDQoNClNlaWppDQo=
