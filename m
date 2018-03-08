From: "Prakhya, Sai Praneeth" <sai.praneeth.prakhya@intel.com>
Subject: RE: [PATCH V2 2/3] efi: Introduce efi_rts_workqueue and some
 infrastructure to invoke all efi_runtime_services()
Date: Thu, 8 Mar 2018 18:09:56 +0000
Message-ID: <FFF73D592F13FD46B8700F0A279B802F2E581AE7@ORSMSX114.amr.corp.intel.com>
References: <1520292190-5027-1-git-send-email-sai.praneeth.prakhya@intel.com>
 <1520292190-5027-3-git-send-email-sai.praneeth.prakhya@intel.com>
 <CANiq72m6_WCXSrBPesgvO1rsF1_AT5Jod_rY-y1f4JjO-SMCDg@mail.gmail.com>
 <FFF73D592F13FD46B8700F0A279B802F2E5817F2@ORSMSX114.amr.corp.intel.com>
 <CANiq72krjVviT0mPqpK5jbLWEbDx_OhG6+eUmyT8thZPEjkJKg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CANiq72krjVviT0mPqpK5jbLWEbDx_OhG6+eUmyT8thZPEjkJKg@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "Lee@vger.kernel.org" <Lee@vger.kernel.org>, Chun-Yi <jlee@suse.com>, Borislav Petkov <bp@alien8.de>, "Luck, Tony" <tony.luck@intel.com>, Will Deacon <will.deacon@arm.com>, "Hansen, Dave" <dave.hansen@intel.com>, Mark Rutland <mark.rutland@arm.com>, Bhupesh Sharma <bhsharma@redhat.com>, "Neri, Ricardo" <ricardo.neri@intel.com>, "Shankar, Ravi V" <ravi.v.shankar@intel.com>, Matt Fleming <matt@codeblueprint.co.uk>, "Zijlstra, Peter" <peter.zijlstra@intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, "Williams, Dan J" <dan.j.williams@intel.com>
List-Id: linux-efi@vger.kernel.org

LyoNCj4gPj4gPiArICAgICAgICAqIFNpbmNlIHdlIHByb2Nlc3Mgb25seSBvbmUgZWZpX3J1bnRp
bWVfc2VydmljZSgpIGF0IGEgdGltZSwgYW4NCj4gPj4gPiArICAgICAgICAqIG9yZGVyZWQgd29y
a3F1ZXVlICh3aGljaCBjcmVhdGVzIG9ubHkgb25lIGV4ZWN1dGlvbiBjb250ZXh0KQ0KPiA+PiA+
ICsgICAgICAgICogc2hvdWxkIHN1ZmZpY2UgYWxsIG91ciBuZWVkcy4NCj4gPj4gPiArICAgICAg
ICAqLw0KPiA+PiA+ICsgICAgICAgZWZpX3J0c193cSA9IGFsbG9jX29yZGVyZWRfd29ya3F1ZXVl
KCJlZmlfcnRzX3dvcmtxdWV1ZSIsDQo+ID4+ID4gKyAwKTsNCj4gPj4NCj4gPj4gZWZpX3J0c193
cSBvciBlZmlfcnRzX3dvcmtxdWV1ZT8NCj4gPj4NCj4gPj4gPiArICAgICAgIGlmICghZWZpX3J0
c193cSkgew0KPiA+PiA+ICsgICAgICAgICAgICAgICBwcl9lcnIoIkZhaWxlZCB0byBjcmVhdGUg
ZWZpX3J0c193b3JrcXVldWUsIEVGSSBydW50aW1lIHNlcnZpY2VzICINCj4gPj4NCj4gPj4gU2Ft
ZSBoZXJlLg0KPiA+DQo+ID4gU3VyZSEgSSB3aWxsIG1ha2UgaXQgY29uc2lzdGVudCB3aXRoICJl
ZmlfcnRzX3dxIi4gSnVzdCB0cmllZCB0byBiZQ0KPiA+IG1vcmUgdmVyYm9zZSB3aXRoIG5hbWVz
IDopDQo+ID4NCj4gDQo+IEl0IGlzIG5vdCBhIGJpZyBkZWFsLCBidXQgdXNpbmcgdGhlIGV4YWN0
IHNhbWUgbmFtZSBpcyBiZXR0ZXIgZm9yIHRoZSBwdXJwb3NlcyBvZg0KPiBncmVwcGluZyBhbmQg
dGhpbmdzIGxpa2UgdGhhdCA6LSkNCg0KWWVzLCB0aGF0IG1ha2VzIHNlbnNlLg0KDQo+IEJ5IHRo
ZSB3YXksIGNoZWNrIHRoZSBjb21taXQgdGl0bGUvbWVzc2FnZSwgdGhlcmUgYXJlIHNvbWUgb3Ro
ZXJzIHRoZXJlIHRvby4NCg0KU3VyZSEgSSB3aWxsIG1ha2UgY2hhbmdlcyB0byBjb21taXQvdGl0
bGUgbWVzc2FnZXMgdG9vLg0KDQpSZWdhcmRzLA0KU2FpDQo=
