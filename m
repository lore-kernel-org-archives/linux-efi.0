From: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Subject: Re: [RFC PATCH v3 10/20] Add support to access boot related data in
 the clear
Date: Fri, 11 Nov 2016 16:17:36 +0000
Message-ID: <1478880929.20881.148.camel@hpe.com>
References: <20161110003426.3280.2999.stgit@tlendack-t1.amdoffice.net>
         <20161110003631.3280.73292.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20161110003631.3280.73292.stgit@tlendack-t1.amdoffice.net>
Content-Language: en-US
Content-ID: <BEE02238B3BD834EA32E172A2B7D775A@NAMPRD84.PROD.OUTLOOK.COM>
Sender: linux-doc-owner@vger.kernel.org
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "kasan-dev@googlegroups.com" <kasan-dev@googlegroups.com>, "x86@kernel.org" <x86@kernel.org>, "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Cc: "matt@codeblueprint.co.uk" <matt@codeblueprint.co.uk>, "corbet@lwn.net" <corbet@lwn.net>, "tglx@linutronix.de" <tglx@linutronix.de>, "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>, "joro@8bytes.org" <joro@8bytes.org>, "dvyukov@google.com" <dvyukov@google.com>, "aryabinin@virtuozzo.com" <aryabinin@virtuozzo.com>, "riel@redhat.com" <riel@redhat.com>, "lwoodman@redhat.com" <lwoodman@redhat.com>, "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>, "luto@kernel.org" <luto@kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, "bp@alien8.de" <bp@alien8.de>, "glider@google.com" <glider@google.com>, "rkrcmar@redhat.com" <rkrcmar@redhat.com>, "arnd@arndb.de" <arnd@arndb.de>
List-Id: linux-efi@vger.kernel.org

T24gV2VkLCAyMDE2LTExLTA5IGF0IDE4OjM2IC0wNjAwLCBUb20gTGVuZGFja3kgd3JvdGU6DQo+
IEJvb3QgZGF0YSAoc3VjaCBhcyBFRkkgcmVsYXRlZCBkYXRhKSBpcyBub3QgZW5jcnlwdGVkIHdo
ZW4gdGhlIHN5c3RlbQ0KPiBpcyBib290ZWQgYW5kIG5lZWRzIHRvIGJlIGFjY2Vzc2VkIHVuZW5j
cnlwdGVkLsKgwqBBZGQgc3VwcG9ydCB0byBhcHBseQ0KPiB0aGUgcHJvcGVyIGF0dHJpYnV0ZXMg
dG8gdGhlIEVGSSBwYWdlIHRhYmxlcyBhbmQgdG8gdGhlDQo+IGVhcmx5X21lbXJlbWFwIGFuZCBt
ZW1yZW1hcCBBUElzIHRvIGlkZW50aWZ5IHRoZSB0eXBlIG9mIGRhdGEgYmVpbmcNCj4gYWNjZXNz
ZWQgc28gdGhhdCB0aGUgcHJvcGVyIGVuY3J5cHRpb24gYXR0cmlidXRlIGNhbiBiZSBhcHBsaWVk
Lg0KwqA6DQo+ICtzdGF0aWMgYm9vbCBtZW1yZW1hcF9hcHBseV9lbmNyeXB0aW9uKHJlc291cmNl
X3NpemVfdCBwaHlzX2FkZHIsDQo+ICsJCQkJwqDCoMKgwqDCoMKgdW5zaWduZWQgbG9uZyBzaXpl
KQ0KPiArew0KPiArCS8qIFNNRSBpcyBub3QgYWN0aXZlLCBqdXN0IHJldHVybiB0cnVlICovDQo+
ICsJaWYgKCFzbWVfbWVfbWFzaykNCj4gKwkJcmV0dXJuIHRydWU7DQo+ICsNCj4gKwkvKiBDaGVj
ayBpZiB0aGUgYWRkcmVzcyBpcyBwYXJ0IG9mIHRoZSBzZXR1cCBkYXRhICovDQo+ICsJaWYgKG1l
bXJlbWFwX3NldHVwX2RhdGEocGh5c19hZGRyLCBzaXplKSkNCj4gKwkJcmV0dXJuIGZhbHNlOw0K
PiArDQo+ICsJLyogQ2hlY2sgaWYgdGhlIGFkZHJlc3MgaXMgcGFydCBvZiBFRkkgYm9vdC9ydW50
aW1lIGRhdGEgKi8NCj4gKwlzd2l0Y2ggKGVmaV9tZW1fdHlwZShwaHlzX2FkZHIpKSB7DQo+ICsJ
Y2FzZSBFRklfQk9PVF9TRVJWSUNFU19EQVRBOg0KPiArCWNhc2UgRUZJX1JVTlRJTUVfU0VSVklD
RVNfREFUQToNCj4gKwkJcmV0dXJuIGZhbHNlOw0KPiArCX0NCj4gKw0KPiArCS8qIENoZWNrIGlm
IHRoZSBhZGRyZXNzIGlzIG91dHNpZGUga2VybmVsIHVzYWJsZSBhcmVhICovDQo+ICsJc3dpdGNo
IChlODIwX2dldF9lbnRyeV90eXBlKHBoeXNfYWRkciwgcGh5c19hZGRyICsgc2l6ZSAtDQo+IDEp
KSB7DQo+ICsJY2FzZSBFODIwX1JFU0VSVkVEOg0KPiArCWNhc2UgRTgyMF9BQ1BJOg0KPiArCWNh
c2UgRTgyMF9OVlM6DQo+ICsJY2FzZSBFODIwX1VOVVNBQkxFOg0KPiArCQlyZXR1cm4gZmFsc2U7
DQo+ICsJfQ0KPiArDQo+ICsJcmV0dXJuIHRydWU7DQo+ICt9DQoNCkFyZSB5b3Ugc3VwcG9ydGlu
ZyBlbmNyeXB0aW9uIGZvciBFODIwX1BNRU0gcmFuZ2VzPyDCoElmIHNvLCB0aGlzDQplbmNyeXB0
aW9uIHdpbGwgcGVyc2lzdCBhY3Jvc3MgYSByZWJvb3QgYW5kIGRvZXMgbm90IG5lZWQgdG8gYmUN
CmVuY3J5cHRlZCBhZ2FpbiwgcmlnaHQ/IMKgQWxzbywgaG93IGRvIHlvdSBrZWVwIGEgc2FtZSBr
ZXkgYWNyb3NzIGENCnJlYm9vdD8NCg0KVGhhbmtzLA0KLVRvc2hp
