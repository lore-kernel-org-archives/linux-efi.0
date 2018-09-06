From: Grant Likely <Grant.Likely@arm.com>
Subject: Re: [PATCH] efi_stub: update documentation on dtb= parameter
Date: Thu, 6 Sep 2018 17:52:06 +0000
Message-ID: <BFA61ADA-2AD9-4383-ADAA-9D660881865B@arm.com>
References: <20180905190750.4566-1-grant.likely@arm.com>,<20180906095111.1a74dfcd@lwn.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180906095111.1a74dfcd@lwn.net>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Jonathan Corbet <corbet@lwn.net>
Cc: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "olof@lixom.net" <olof@lixom.net>, "scott.branden@broadcom.com" <scott.branden@broadcom.com>, Catalin Marinas <Catalin.Marinas@arm.com>, Will Deacon <Will.Deacon@arm.com>, "arnd@arndb.de" <arnd@arndb.de>, "leif.lindholm@linaro.org" <leif.lindholm@linaro.org>, "agraf@suse.de" <agraf@suse.de>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, nd <nd@arm.com>
List-Id: linux-efi@vger.kernel.org

DQoNCj4gT24gNiBTZXAgMjAxOCwgYXQgMTY6NTEsIEpvbmF0aGFuIENvcmJldCA8Y29yYmV0QGx3
bi5uZXQ+IHdyb3RlOg0KPiANCj4gT24gV2VkLCAgNSBTZXAgMjAxOCAyMDowNzo1MCArMDEwMA0K
PiBHcmFudCBMaWtlbHkgPGdyYW50Lmxpa2VseUBhcm0uY29tPiB3cm90ZToNCj4gDQo+PiBUaGUg
ZHRiPSBwYXJhbWV0ZXIgaXMgbm8gbG9uZ2VyIHRoZSBwcmltYXJ5IG1lY2hhbmlzbSBmb3IgcHJv
dmlkaW5nIGENCj4+IGRldmljZXRyZWUgdG8gdGhlIGtlcm5lbC4gTm93IGVpdGhlciBmaXJtd2Fy
ZSBvciB0aGUgYm9vdCBzZWxlY3RvciAoZXguDQo+PiBHcnViKSBzaG91bGQgcHJvdmlkZSB0aGUg
ZGV2aWNldHJlZSBhbmQgZHRiPSBzaG91bGQgb25seSBiZSB1c2VkIGZvcg0KPj4gZGVidWcgb3Ig
d2hlbiB1c2luZyBmaXJtd2FyZSB0aGF0IGRvZXNuJ3QgdW5kZXJzdGFuZCBEVC4NCj4+IFVwZGF0
ZSB0aGUgRUZJIHN0dWIgZG9jdW1lbnRhdGlvbiB0byByZWZsZWN0IHRoZSBjdXJyZW50IHVzYWdl
Lg0KPiANCj4gU28gSSBoYXRlIHRvIGJlIG9ibm94aW91cywgYnV0Li4uDQo+IA0KPj4gSU1QT1JU
QU5UIE5PVElDRTogVGhlIGNvbnRlbnRzIG9mIHRoaXMgZW1haWwgYW5kIGFueSBhdHRhY2htZW50
cyBhcmUNCj4+IGNvbmZpZGVudGlhbCBhbmQgbWF5IGFsc28gYmUgcHJpdmlsZWdlZC4gSWYgeW91
IGFyZSBub3QgdGhlIGludGVuZGVkDQo+PiByZWNpcGllbnQsIHBsZWFzZSBub3RpZnkgdGhlIHNl
bmRlciBpbW1lZGlhdGVseSBhbmQgZG8gbm90IGRpc2Nsb3NlIHRoZQ0KPj4gY29udGVudHMgdG8g
YW55IG90aGVyIHBlcnNvbiwgdXNlIGl0IGZvciBhbnkgcHVycG9zZSwgb3Igc3RvcmUgb3IgY29w
eQ0KPj4gdGhlIGluZm9ybWF0aW9uIGluIGFueSBtZWRpdW0uIFRoYW5rIHlvdS4NCj4gDQo+IENh
biBJIGdldCBhIHZlcnNpb24gb2YgdGhlIHBhdGNoIHdpdGhvdXQgdGhpcyBsYW5ndWFnZT8gIFRo
ZW4gSSdsbCBiZSBnbGFkDQo+IHRvIGFwcGx5IGl0Lg0KDQpVZ2guIFdlbGwgdGhhdCB3YXMgZHVt
Yi4gVGhlcmUgaXMgYSBtYWdpYyB0cmljayBJIGhhdmUgdG8gcGVyZm9ybSB0byBnZXQgcmlkIG9m
IHRoZSBkaXNjbGFpbWVyLCBidXQgaXQgZGlkbuKAmXQgd29yayB0aGlzIHRpbWUuIEnigJlsbCBm
aXggYW5kIGdldCBhIG5ldyBvbmUgb3V0Lg0KDQpnLg0KDQo+IA0KPiBUaGFua3MsDQo+IA0KPiBq
b24NCg==
