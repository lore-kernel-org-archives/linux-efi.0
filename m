From: Matthew Garrett <matthew.garrett@nebula.com>
Subject: Re: [PATCH] x86: Lock down MSR writing in secure boot
Date: Wed, 13 Feb 2013 17:26:39 +0000
Message-ID: <1360776399.18083.39.camel@x230.lan>
References: <dee64752-850c-4d78-b703-f47a985bc13e@email.android.com>
	     <CAGXu5jLAufTRm=sDST0br_WEkn4o0Hpjv2jDP2Na=cCvuM+MGg@mail.gmail.com>
	     <1360355671.18083.18.camel@x230.lan>
	     <CAGXu5jKo2PfMBO4A0ZgQcrPuj8OHNaff+CjAesOAWkZc0vB9+Q@mail.gmail.com>
	     <51157C9C.6030501@zytor.com> <20130208230655.GB28990@pd.tnic>
	     <1360366012.18083.21.camel@x230.lan> <5115A4CC.3080102@zytor.com>
	     <1360373383.18083.23.camel@x230.lan>
	     <CAGXu5j+xvJ3L5ejxtZ-Jw3F6rV7OsrE0_HZCGu_er0rH2_PwKA@mail.gmail.com>
	     <20130209092925.GA17728@pd.tnic> <1360422712.18083.24.camel@x230.lan>
	    <511AE2CC.5040705@zytor.com> <1360733962.18083.30.camel@x230.lan>
	   <511B2EB9.5070406@zytor.com> <1360736860.18083.33.camel@x230.lan>
	  <511B33BC.9080307@zytor.com> <1360737709.18083.36.camel@x230.lan>
	 <511BCB6E.8080102@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <511BCB6E.8080102@zytor.com>
Content-Language: en-US
Content-ID: <218534E4FFAC3A4E931CB5AB88AF53CA@namprd05.prod.outlook.com>
Sender: linux-security-module-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@alien8.de>, Kees Cook <keescook@chromium.org>, LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "x86@kernel.org" <x86@kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

T24gV2VkLCAyMDEzLTAyLTEzIGF0IDA5OjIwIC0wODAwLCBILiBQZXRlciBBbnZpbiB3cm90ZToN
Cg0KPiBQcm9ibGVtOg0KPiANCj4gU29tZW9uZSBhZGRzIFNZU19DQVBfUkFXSU8gdG8gc29tZSBw
bGFjZXMgaXQgZGVmaW5pdGVseSBkb2VzIG5vdA0KPiBiZWxvbmcuDQo+IA0KPiBTb2x1dGlvbjoN
Cj4gDQo+IEJyZWFrIGFsbCB0aGUgKmFwcHJvcHJpYXRlKiAoYXMgZGVmaW5lZCl1c2VzIG9mIFNZ
U19DQVBfUkFXSU8/DQoNClByb2JsZW06DQoNCkNBUF9TWVNfUkFXSU8gaGFzIGJlZW4gdXNlZCBp
biBhIGJ1bmNoIG9mIGFyZ3VhYmx5IGluYXBwcm9wcmlhdGUgcGxhY2VzLg0KUmVtb3ZpbmcgQ0FQ
X1NZU19SQVdJTyBmcm9tIHRoZSBzZXQgb2YgcG9zc2libGUgY2FwYWJpbGl0aWVzIG9uIGEgc3lz
dGVtDQp3aWxsIHByZXZlbnQgdXNlcnNwYWNlIGZyb20gZG9pbmcgdGhpbmdzIHRoYXQgdXNlcnNw
YWNlIHNob3VsZCBiZQ0KcGVybWl0dGVkIHRvIGRvLiBSZW1vdmluZyBDQVBfU1lTX1JBV0lPIGZy
b20gdGhlIHBsYWNlcyB0aGF0IGl0DQpjdXJyZW50bHkgZXhpc3RzIHdpbGwgYWxsb3cgdXNlcnNw
YWNlIHRvIGRvIHRvbyBtdWNoLiBSZXBsYWNpbmcNCkNBUF9TWVNfUkFXSU8gd2l0aCBDQVBfU1lT
X0FETUlOIHdpbGwgcHJldmVudCB1c2Vyc3BhY2UgZnJvbSBkb2luZw0KdGhpbmdzIHRoYXQgaXQg
Y2FuIGN1cnJlbnRseSBkby4NCg0KU29sdXRpb246DQoNCkFkbWl0IHRoYXQgQ0FQX1NZU19SQVdJ
TyBpcyBmdWNrZWQgdXAgYmV5b25kIHJlc2N1ZS4gQWRkIGEgbmV3DQpjYXBhYmlsaXR5IHdpdGgg
d2VsbC1kZWZpbmVkIHNlbWFudGljcy4NCg==

