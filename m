From: "Prakhya, Sai Praneeth" <sai.praneeth.prakhya@intel.com>
Subject: RE: [PATCH V2 1/3] x86/efi: Call efi_delete_dummy_variable() during
 efi subsystem initialization
Date: Thu, 8 Mar 2018 18:06:45 +0000
Message-ID: <FFF73D592F13FD46B8700F0A279B802F2E581AD0@ORSMSX114.amr.corp.intel.com>
References: <1520292190-5027-1-git-send-email-sai.praneeth.prakhya@intel.com>
 <1520292190-5027-2-git-send-email-sai.praneeth.prakhya@intel.com>
 <CAKv+Gu_ZYGwgORet4ruL8=GUy75LMAuLeYD987FA3UVYuw8GMg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu_ZYGwgORet4ruL8=GUy75LMAuLeYD987FA3UVYuw8GMg@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Chun-Yi <jlee@suse.com>, Borislav Petkov <bp@alien8.de>, "Luck, Tony" <tony.luck@intel.com>, Will Deacon <will.deacon@arm.com>, "Hansen, Dave" <dave.hansen@intel.com>, Mark Rutland <mark.rutland@arm.com>, Bhupesh Sharma <bhsharma@redhat.com>, "Neri, Ricardo" <ricardo.neri@intel.com>, "Shankar, Ravi V" <ravi.v.shankar@intel.com>, Matt Fleming <matt@codeblueprint.co.uk>, "Zijlstra, Peter" <peter.zijlstra@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>
List-Id: linux-efi@vger.kernel.org

PiA+ICB2b2lkIF9faW5pdCBlZmlfZW50ZXJfdmlydHVhbF9tb2RlKHZvaWQpIGRpZmYgLS1naXQN
Cj4gPiBhL2RyaXZlcnMvZmlybXdhcmUvZWZpL2VmaS5jIGIvZHJpdmVycy9maXJtd2FyZS9lZmkv
ZWZpLmMgaW5kZXgNCj4gPiBjZDQyZjY2YTdjODUuLjgzOGI4ZWZlNjM5YyAxMDA2NDQNCj4gPiAt
LS0gYS9kcml2ZXJzL2Zpcm13YXJlL2VmaS9lZmkuYw0KPiA+ICsrKyBiL2RyaXZlcnMvZmlybXdh
cmUvZWZpL2VmaS5jDQo+ID4gQEAgLTMyOCw2ICszMjgsMTIgQEAgc3RhdGljIGludCBfX2luaXQg
ZWZpc3Vic3lzX2luaXQodm9pZCkNCj4gPiAgICAgICAgIGlmICghZWZpX2VuYWJsZWQoRUZJX0JP
T1QpKQ0KPiA+ICAgICAgICAgICAgICAgICByZXR1cm4gMDsNCj4gPg0KPiA+ICsgICAgICAgLyoN
Cj4gPiArICAgICAgICAqIENsZWFuIERVTU1ZIG9iamVjdCBjYWxscyBFRkkgUnVudGltZSBTZXJ2
aWNlLCBzZXRfdmFyaWFibGUoKSwgc28NCj4gPiArICAgICAgICAqIGl0IHNob3VsZCBiZSBpbnZv
a2VkIG9ubHkgYWZ0ZXIgZWZpX3J0c193b3JrcXVldWUgaXMgcmVhZHkuDQo+ID4gKyAgICAgICAg
Ki8NCj4gPiArICAgICAgIGVmaV9kZWxldGVfZHVtbXlfdmFyaWFibGUoKTsNCj4gPiArDQo+IA0K
PiBJcyB0aGVyZSBhbnkgd2F5IHRvIGtlZXAgdGhpcyBsb2NhbCB0byBhcmNoL3g4Nj8NCj4NCg0K
SSB0aGluaywgd2UgY2FuIGRlZmluaXRlbHkgZG8gdGhhdC4gSSB3aWxsIHJldGFrZSBhIGxvb2sg
YXQgdGhlIHBvc3NpYmlsaXRpZXMNCmFuZCB3aWxsIHVwZGF0ZSB0aGlzIHRocmVhZC4NCg0KPiA+
ICAgICAgICAgLyogV2UgcmVnaXN0ZXIgdGhlIGVmaSBkaXJlY3RvcnkgYXQgL3N5cy9maXJtd2Fy
ZS9lZmkgKi8NCj4gPiAgICAgICAgIGVmaV9rb2JqID0ga29iamVjdF9jcmVhdGVfYW5kX2FkZCgi
ZWZpIiwgZmlybXdhcmVfa29iaik7DQo+ID4gICAgICAgICBpZiAoIWVmaV9rb2JqKSB7DQo+ID4g
ZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvZWZpLmggYi9pbmNsdWRlL2xpbnV4L2VmaS5oIGlu
ZGV4DQo+ID4gZjUwODNhYTcyZWFlLi5jNGVmYjNlZjBkZmEgMTAwNjQ0DQo+ID4gLS0tIGEvaW5j
bHVkZS9saW51eC9lZmkuaA0KPiA+ICsrKyBiL2luY2x1ZGUvbGludXgvZWZpLmgNCj4gPiBAQCAt
OTkyLDYgKzk5Miw3IEBAIGV4dGVybiBlZmlfc3RhdHVzX3QgZWZpX3F1ZXJ5X3ZhcmlhYmxlX3N0
b3JlKHUzMg0KDQo=
