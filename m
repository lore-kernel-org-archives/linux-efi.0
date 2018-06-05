From: "Prakhya, Sai Praneeth" <sai.praneeth.prakhya@intel.com>
Subject: RE: [PATCH V5 3/3] efi: Use efi_rts_wq to invoke EFI Runtime
 Services
Date: Tue, 5 Jun 2018 19:29:13 +0000
Message-ID: <FFF73D592F13FD46B8700F0A279B802F3B812DFC@ORSMSX114.amr.corp.intel.com>
References: <1527560464-19466-1-git-send-email-sai.praneeth.prakhya@intel.com>
 <1527560464-19466-4-git-send-email-sai.praneeth.prakhya@intel.com>
 <CAKv+Gu_K3HsVoH0M7kFx12d8eGzdmAe-C06TnKek1xwsSFyStA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu_K3HsVoH0M7kFx12d8eGzdmAe-C06TnKek1xwsSFyStA@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-efi <linux-efi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Lee Chun-Yi <jlee@suse.com>, Borislav Petkov <bp@alien8.de>, "Luck, Tony" <tony.luck@intel.com>, Will Deacon <will.deacon@arm.com>, "Hansen, Dave" <dave.hansen@intel.com>, Mark Rutland <mark.rutland@arm.com>, Bhupesh Sharma <bhsharma@redhat.com>, Naresh Bhat <naresh.bhat@linaro.org>, "Neri, Ricardo" <ricardo.neri@intel.com>, Peter Zijlstra <peterz@infradead.org>, "Shankar, Ravi V" <ravi.v.shankar@intel.com>, Matt Fleming <matt@codeblueprint.co.uk>, "Williams, Dan J" <dan.j.williams@intel.com>, Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
List-Id: linux-efi@vger.kernel.org

PiA+ICsgICAgICAgY2FzZSBSRVNFVF9TWVNURU06DQo+ID4gKyAgICAgICAgICAgICAgIF9fZWZp
X2NhbGxfdmlydChyZXNldF9zeXN0ZW0sICooaW50ICopYXJnMSwNCj4gPiArICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICooZWZpX3N0YXR1c190ICopYXJnMiwNCj4gPiArICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICoodW5zaWduZWQgbG9uZyAqKWFyZzMsDQo+ID4gKyAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAoZWZpX2NoYXIxNl90ICopYXJnNCk7DQo+ID4gKyAg
ICAgICAgICAgICAgIGJyZWFrOw0KPiANCj4gSSBub3RpY2VkIHRoYXQgLXVuc3VycHJpc2luZ2x5
LSByZWJvb3Qgbm8gbG9uZ2VyIHdvcmtzIHdpdGggdGhlc2UgY2hhbmdlcy4NCj4gDQo+IEkgd2ls
bCBmaXggdXAgdGhlIHBhdGNoLCBhbmQgcmV2ZXJ0IHRoZSBlZmlfcmVzZXRfc3lzdGVtKCkgY2hh
bmdlLCBib3RoIGhlcmUgYW5kDQo+IGJlbG93Lg0KDQpDb3VsZCB5b3UgcGxlYXNlIGxldCBtZSBr
bm93IHdoYXQgdGhlIGJ1ZyBpcyBoZXJlPyBJIGFtIHVuYWJsZSB0byBzZWUgaXQgcmlnaHQgYXdh
eSA6KA0KSSBoYXZlIHRlc3RlZCByZWJvb3Qgb24gcWVtdSB4ODZfNjQgYnkgcGFzc2luZyAicmVi
b290PWVmaSIgYXMgY29tbWFuZCBsaW5lIGFyZyBhbmQgDQpzYXcgdGhhdCByZWJvb3QgaXMgd29y
a2luZyBmaW5lLg0KDQo+ID4gQEAgLTM0MCw3ICs0NDEsOCBAQCBzdGF0aWMgdm9pZCB2aXJ0X2Vm
aV9yZXNldF9zeXN0ZW0oaW50IHJlc2V0X3R5cGUsDQo+ID4gICAgICAgICAgICAgICAgICAgICAg
ICAgImNvdWxkIG5vdCBnZXQgZXhjbHVzaXZlIGFjY2VzcyB0byB0aGUgZmlybXdhcmVcbiIpOw0K
PiA+ICAgICAgICAgICAgICAgICByZXR1cm47DQo+ID4gICAgICAgICB9DQo+ID4gLSAgICAgICBf
X2VmaV9jYWxsX3ZpcnQocmVzZXRfc3lzdGVtLCByZXNldF90eXBlLCBzdGF0dXMsIGRhdGFfc2l6
ZSwgZGF0YSk7DQo+ID4gKyAgICAgICBlZmlfcXVldWVfd29yayhSRVNFVF9TWVNURU0sICZyZXNl
dF90eXBlLCAmc3RhdHVzLCAmZGF0YV9zaXplLCBkYXRhLA0KPiA+ICsgICAgICAgICAgICAgICAg
ICAgICAgTlVMTCk7DQo+ID4gICAgICAgICB1cCgmZWZpX3J1bnRpbWVfbG9jayk7DQo+ID4gIH0N
Cg0KUmVnYXJkcywNClNhaQ0K
