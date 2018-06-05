From: "Prakhya, Sai Praneeth" <sai.praneeth.prakhya@intel.com>
Subject: RE: [PATCH V5 3/3] efi: Use efi_rts_wq to invoke EFI Runtime
 Services
Date: Tue, 5 Jun 2018 20:15:20 +0000
Message-ID: <FFF73D592F13FD46B8700F0A279B802F3B818BE7@ORSMSX114.amr.corp.intel.com>
References: <1527560464-19466-1-git-send-email-sai.praneeth.prakhya@intel.com>
 <1527560464-19466-4-git-send-email-sai.praneeth.prakhya@intel.com>
 <CAKv+Gu_K3HsVoH0M7kFx12d8eGzdmAe-C06TnKek1xwsSFyStA@mail.gmail.com>
 <FFF73D592F13FD46B8700F0A279B802F3B812DFC@ORSMSX114.amr.corp.intel.com>
 <CAKv+Gu_Y3Lt1FpymS00AMD4ZJ3AFSV1m7ggxuRFCa4PROeX8XA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu_Y3Lt1FpymS00AMD4ZJ3AFSV1m7ggxuRFCa4PROeX8XA@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-efi <linux-efi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Lee Chun-Yi <jlee@suse.com>, Borislav Petkov <bp@alien8.de>, "Luck, Tony" <tony.luck@intel.com>, Will Deacon <will.deacon@arm.com>, "Hansen, Dave" <dave.hansen@intel.com>, Mark Rutland <mark.rutland@arm.com>, Bhupesh Sharma <bhsharma@redhat.com>, Naresh Bhat <naresh.bhat@linaro.org>, "Neri, Ricardo" <ricardo.neri@intel.com>, Peter Zijlstra <peterz@infradead.org>, "Shankar, Ravi V" <ravi.v.shankar@intel.com>, Matt Fleming <matt@codeblueprint.co.uk>, "Williams, Dan J" <dan.j.williams@intel.com>, Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
List-Id: linux-efi@vger.kernel.org

PiA+PiBJIG5vdGljZWQgdGhhdCAtdW5zdXJwcmlzaW5nbHktIHJlYm9vdCBubyBsb25nZXIgd29y
a3Mgd2l0aCB0aGVzZSBjaGFuZ2VzLg0KPiA+Pg0KPiA+PiBJIHdpbGwgZml4IHVwIHRoZSBwYXRj
aCwgYW5kIHJldmVydCB0aGUgZWZpX3Jlc2V0X3N5c3RlbSgpIGNoYW5nZSwNCj4gPj4gYm90aCBo
ZXJlIGFuZCBiZWxvdy4NCj4gPg0KPiA+IENvdWxkIHlvdSBwbGVhc2UgbGV0IG1lIGtub3cgd2hh
dCB0aGUgYnVnIGlzIGhlcmU/IEkgYW0gdW5hYmxlIHRvIHNlZQ0KPiA+IGl0IHJpZ2h0IGF3YXkg
OiggSSBoYXZlIHRlc3RlZCByZWJvb3Qgb24gcWVtdSB4ODZfNjQgYnkgcGFzc2luZw0KPiA+ICJy
ZWJvb3Q9ZWZpIiBhcyBjb21tYW5kIGxpbmUgYXJnIGFuZCBzYXcgdGhhdCByZWJvb3QgaXMgd29y
a2luZyBmaW5lLg0KPiA+DQo+IA0KPiBNeSBhcm02NCBoYW5ncyBhdCByZWJvb3Qgb3IgcG93ZXIg
b2ZmLCB1bmxlc3MgaSByZXZlcnQgdGhlIFJlc2V0U3lzdGVtKCkgcGFydC4NCj4NCg0KVGhhdCdz
IGludGVyZXN0aW5nLiBOb3Qgc3VyZSBob3cgdGhlIGJlaGF2aW9yIGNvdWxkIGJlIGRpZmZlcmVu
dCBiZXR3ZWVuIHg4NiBhbmQgYXJtNjQuDQpNYXliZSB3b3J0aCBkZWJ1Z2dpbmcgZnVydGhlcj8N
CkFzIHlvdSBzYWlkLCByZXZlcnRpbmcgUmVzZXRTeXN0ZW0oKSBwYXJ0IG1ha2VzIHRoaW5ncyB3
b3JrLCB3ZSBjYW5ub3Qgc3VzcGVjdCBhIA0KYnVnZ3kgZWZpX3Jlc2V0X3N5c3RlbSgpIChJIGNh
bWUgYWNyb3NzIGJ1Z2d5IGVmaV9yZXNldF9zeXN0ZW0oKSBpbXBsZW1lbnRhdGlvbnMgDQpvbiBz
b21lIHg4NiBzeXN0ZW1zKS4NCg0KPiBCdXQgZ2l2ZW4gdGhhdCBpdCBpcyBib3RoIHJpc2t5IChy
ZWx5aW5nIG9uIGEga3RocmVhZCBydW5uaW5nIGEgd29ya3F1ZXVlIGluIHRoZQ0KPiBzaHV0ZG93
biBwYXRoKSBhbmQgdW5uZWNlc3NhcnkgKFJlc2V0U3lzdGVtKCkgaXMgbm90IHN1cHBvc2VkIHRv
IHJldHVybiwgYW5kIGlzDQo+IG9ubHkgY2FsbGVkIGJ5IHRoZSBrZXJuZWwgd2hlbiB0aGUgd2hv
bGUgc3lzdGVtIGhhcyBhbHJlYWR5IGJlZW4gdG9ybiBkb3duKSwgSQ0KPiB0aGluayB0aGUgbWFp
biByZWFzb24gaXMgc2ltcGx5IHRoYXQgdGhlcmUgaXMgbm8gcmVhc29uIHRvIGFkZCBpdC4NCg0K
TWFrZXMgc2Vuc2UuDQpJIHRoaW5rLCBiZWZvcmUgY2FsbGluZyBmaXJtd2FyZSBSZXNldFN5c3Rl
bSgpIGtlcm5lbCBoYXMgYWxyZWFkeSBzaHV0IGRvd24gYWxsIG90aGVyIHBhcnRzIA0KYW5kIGhl
bmNlIGFzIHRoZSBjb250cm9sIHdpbGwgbm90IHRyYW5zZmVyIGJhY2sgdG8ga2VybmVsIChvdGhl
ciB0aGFuIFJlc2V0U3lzdGVtKCkgZmFpbHVyZSksIA0Kd2UgY291bGQgc2FmZWx5IGFzc3VtZSB0
aGF0IG5vIGtlcm5lbCBjb2RlIHdvdWxkIGFjY2VzcyB1c2VyIHNwYWNlIHdoaWxlIGluIA0KZWZp
X3Jlc2V0X3N5c3RlbSgpIGFuZCBoZW5jZSB3ZSBkb24ndCBuZWVkIHRvIHRha2UgdGhlIHdvcmsg
cXVldWUgcGF0aC4NCg0KUmVnYXJkcywNClNhaQ0K
