From: David Laight <David.Laight@ACULAB.COM>
Subject: RE: [PATCH v2] efi: take size of partition entry from GPT header
Date: Fri, 14 Sep 2018 09:01:48 +0000
Message-ID: <2db38b2d1af34ab9b653c665d08872f1@AcuMS.aculab.com>
References: <20180911161527.GA30689@vnote>
 <20180912083844.iegei2kobcz4b7ag@ws.net.home>
 <6d349d22d37041c1a2942d8ed4c76b69@AcuMS.aculab.com>
 <CAJC2YLaug4=7otnRC7x+UdDp=5ErgJFHFL_7mjRO7sdM2CrUfQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAJC2YLaug4=7otnRC7x+UdDp=5ErgJFHFL_7mjRO7sdM2CrUfQ@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: 'Eugene Korenevsky' <ekorenevsky@gmail.com>
Cc: "kzak@redhat.com" <kzak@redhat.com>, Davidlohr Bueso <dave@stgolabs.net>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

RnJvbTogRXVnZW5lIEtvcmVuZXZza3kNCj4gU2VudDogMTMgU2VwdGVtYmVyIDIwMTggMjA6NDgN
Cj4gDQo+ID4gSSBzdXNwZWN0IHlvdSBhbHNvIG5lZWQgYSBzYW5pdHkgY2hlY2sgdGhhdCB0aGUg
dmFsdWUgaXNuJ3QgdG9vIHNtYWxsDQo+ID4gb3Igc3R1cGlkbHkgbGFyZ2UuDQo+IA0KPiBXaGF0
IHdvdWxkIGJlIHRoZSBjcml0ZXJpb24gZm9yIHRvbyBsYXJnZSBlbnRyaWVzPw0KDQpBbnl0aGlu
ZyBsYXJnZXIgdGhhbiB0aGUgbWF4aW11bSBzaXplIG9mIHRoZSBmdWxsIEdQVCB0YWJsZQ0Kd291
bGQgYmUgYSBzdGFydC4NCkV2ZW4gc29tZXRoaW5nIGxpa2UgNjRrIHdvdWxkIHN0b3AgbGF0ZXIg
Y2FsY3VsYXRpb25zIGdvaW5nIHdyb25nLg0KSSBwcmVzdW1lIHRoZXJlIGlzIGEgY2hlY2sgZWxz
ZXdoZXJlIHRoYXQgdGhlIEdQVCB0YWJsZSBlbnRyaWVzDQphcmUgYWxsIGluc2lkZSB0aGUgZGlz
ayBhcmVhIHRoYXQgd2FzIHJlYWQ/DQoNCglEYXZpZA0KDQotDQpSZWdpc3RlcmVkIEFkZHJlc3Mg
TGFrZXNpZGUsIEJyYW1sZXkgUm9hZCwgTW91bnQgRmFybSwgTWlsdG9uIEtleW5lcywgTUsxIDFQ
VCwgVUsNClJlZ2lzdHJhdGlvbiBObzogMTM5NzM4NiAoV2FsZXMpDQo=
