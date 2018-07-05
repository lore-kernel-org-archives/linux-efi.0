From: "Prakhya, Sai Praneeth" <sai.praneeth.prakhya@intel.com>
Subject: RE: [PATCH 1/6] efi: Introduce efi_memmap_free() to free memory
 allocated by efi_memmap_alloc()
Date: Thu, 5 Jul 2018 18:30:33 +0000
Message-ID: <FFF73D592F13FD46B8700F0A279B802F4659B195@ORSMSX111.amr.corp.intel.com>
References: <1530582654-25662-1-git-send-email-sai.praneeth.prakhya@intel.com>
 <1530582654-25662-2-git-send-email-sai.praneeth.prakhya@intel.com>
 <CAKv+Gu8FjCojLTckLVcOq1z4e=pp4U8GQWVHpvHTewRgef6HDg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu8FjCojLTckLVcOq1z4e=pp4U8GQWVHpvHTewRgef6HDg@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-efi <linux-efi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Lee Chun-Yi <jlee@suse.com>, Dave Young <dyoung@redhat.com>, Borislav Petkov <bp@alien8.de>, Laszlo Ersek <lersek@redhat.com>, Jan Kiszka <jan.kiszka@siemens.com>, "Hansen, Dave" <dave.hansen@intel.com>, Bhupesh Sharma <bhsharma@redhat.com>, Nicolai Stange <nicstange@gmail.com>, Naresh Bhat <naresh.bhat@linaro.org>, "Neri, Ricardo" <ricardo.neri@intel.com>, Peter Zijlstra <peterz@infradead.org>, Taku Izumi <izumi.taku@jp.fujitsu.com>, "Shankar, Ravi V" <ravi.v.shankar@intel.com>, Matt Fleming <matt@codeblueprint.co.uk>, "Williams, Dan J" <dan.j.williams@intel.com>
List-Id: linux-efi@vger.kernel.org

PiA+IFNpZ25lZC1vZmYtYnk6IFNhaSBQcmFuZWV0aCBQcmFraHlhIDxzYWkucHJhbmVldGgucHJh
a2h5YUBpbnRlbC5jb20+DQo+ID4gU3VnZ2VzdGVkLWJ5OiBBcmQgQmllc2hldXZlbCA8YXJkLmJp
ZXNoZXV2ZWxAbGluYXJvLm9yZz4NCj4gPiBDYzogTGVlIENodW4tWWkgPGpsZWVAc3VzZS5jb20+
DQo+ID4gQ2M6IERhdmUgWW91bmcgPGR5b3VuZ0ByZWRoYXQuY29tPg0KPiA+IENjOiBCb3Jpc2xh
diBQZXRrb3YgPGJwQGFsaWVuOC5kZT4NCj4gPiBDYzogTGFzemxvIEVyc2VrIDxsZXJzZWtAcmVk
aGF0LmNvbT4NCj4gPiBDYzogSmFuIEtpc3prYSA8amFuLmtpc3prYUBzaWVtZW5zLmNvbT4NCj4g
PiBDYzogRGF2ZSBIYW5zZW4gPGRhdmUuaGFuc2VuQGludGVsLmNvbT4NCj4gPiBDYzogQmh1cGVz
aCBTaGFybWEgPGJoc2hhcm1hQHJlZGhhdC5jb20+DQo+ID4gQ2M6IE5pY29sYWkgU3RhbmdlIDxu
aWNzdGFuZ2VAZ21haWwuY29tPg0KPiA+IENjOiBOYXJlc2ggQmhhdCA8bmFyZXNoLmJoYXRAbGlu
YXJvLm9yZz4NCj4gPiBDYzogUmljYXJkbyBOZXJpIDxyaWNhcmRvLm5lcmlAaW50ZWwuY29tPg0K
PiA+IENjOiBQZXRlciBaaWpsc3RyYSA8cGV0ZXJ6QGluZnJhZGVhZC5vcmc+DQo+ID4gQ2M6IFRh
a3UgSXp1bWkgPGl6dW1pLnRha3VAanAuZnVqaXRzdS5jb20+DQo+ID4gQ2M6IFJhdmkgU2hhbmth
ciA8cmF2aS52LnNoYW5rYXJAaW50ZWwuY29tPg0KPiA+IENjOiBNYXR0IEZsZW1pbmcgPG1hdHRA
Y29kZWJsdWVwcmludC5jby51az4NCj4gPiBDYzogRGFuIFdpbGxpYW1zIDxkYW4uai53aWxsaWFt
c0BpbnRlbC5jb20+DQo+ID4gQ2M6IEFyZCBCaWVzaGV1dmVsIDxhcmQuYmllc2hldXZlbEBsaW5h
cm8ub3JnPg0KPiANCj4gRG8geW91IHJlYWxseSB0aGluayB5b3Ugc2hvdWxkIGNjIGFsbCB0aGVz
ZSBwZW9wbGU/DQo+IA0KDQpTb3JyeSEgSSBnZXQgdGhhdC4uDQoNCj4gPiAtLS0NCj4gPiAgZHJp
dmVycy9maXJtd2FyZS9lZmkvbWVtbWFwLmMgfCAyOCArKysrKysrKysrKysrKysrKysrKysrKysr
KysrDQo+ID4gIGluY2x1ZGUvbGludXgvZWZpLmggICAgICAgICAgIHwgIDggKysrKysrKysNCj4g
PiAgMiBmaWxlcyBjaGFuZ2VkLCAzNiBpbnNlcnRpb25zKCspDQo+ID4NCg0KW3NuaXBdDQoNCj4g
SSBhbSBub3cgdGhpbmtpbmcgd2Ugc2hvdWxkIHBlcmhhcHMgaGlkZSB0aGUgYWxsb2NhdGlvbiB0
eXBlIGZyb20gdGhlIGNhbGxlcnMNCj4gcmF0aGVyIHRoYW4gcGFzc2luZyBhcm91bmQgaW1wbGVt
ZW50YXRpb24gZGV0YWlscyBvZiB0aGUgYWxsb2NhdG9yLCBhbmQgaGF2ZQ0KPiBleHBsaWNpdCBh
bGxvYy9mcmVlIG9wZXJhdGlvbnMuDQo+IA0KPiBDb3VsZCB3ZSBpbnN0ZWFkIGhhdmUgYSBzaW5n
bGUgJ2VmaV9yZWFsbG9jX21lbW1hcCgpJyBmdW5jdGlvbiB0aGF0IHRha2VzIGNhcmUNCj4gb2Yg
YWxsIG9mIHRoaXM/DQoNClN1cmUhIEkgd2lsbCBnaXZlIGl0IGEgdHJ5Lg0KDQpSZWdhcmRzLA0K
U2FpDQo=
