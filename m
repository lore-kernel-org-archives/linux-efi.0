From: Matthew Garrett <matthew.garrett@nebula.com>
Subject: Re: [PATCH] x86: Lock down MSR writing in secure boot
Date: Fri, 8 Feb 2013 23:26:53 +0000
Message-ID: <1360366012.18083.21.camel@x230.lan>
References: <20130208191213.GA25081@www.outflux.net>
	 <00780235-deac-4f80-b936-867834e05661@email.android.com>
	 <CAGXu5jJnLY6Qp3J6HBpVg-AdUGdKYm-e4wErZO3=NuRo04ajvg@mail.gmail.com>
	 <5115553A.5000708@zytor.com>
	 <CAGXu5j+_mGzR+72YqORhErMUY1aF1H2urczZ8SwuJHZK-oZL6g@mail.gmail.com>
	 <dee64752-850c-4d78-b703-f47a985bc13e@email.android.com>
	 <CAGXu5jLAufTRm=sDST0br_WEkn4o0Hpjv2jDP2Na=cCvuM+MGg@mail.gmail.com>
	 <1360355671.18083.18.camel@x230.lan>
	 <CAGXu5jKo2PfMBO4A0ZgQcrPuj8OHNaff+CjAesOAWkZc0vB9+Q@mail.gmail.com>
	 <51157C9C.6030501@zytor.com> <20130208230655.GB28990@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20130208230655.GB28990@pd.tnic>
Content-Language: en-US
Content-ID: <4F44BB0DA4EB914D8ED1146AA9048BE8@namprd05.prod.outlook.com>
Sender: linux-security-module-owner@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>, LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "x86@kernel.org" <x86@kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

T24gU2F0LCAyMDEzLTAyLTA5IGF0IDAwOjA2ICswMTAwLCBCb3Jpc2xhdiBQZXRrb3Ygd3JvdGU6
DQo+IE9uIEZyaSwgRmViIDA4LCAyMDEzIGF0IDAyOjMwOjUyUE0gLTA4MDAsIEguIFBldGVyIEFu
dmluIHdyb3RlOg0KPiA+IEFsc28sIGtlZXAgaW4gbWluZCB0aGF0IHRoZXJlIGlzIGEgdmVyeSBz
aW1wbGUgd2F5IHRvIGRlbnkgTVNSIGFjY2Vzcw0KPiA+IGNvbXBsZXRlbHksIHdoaWNoIGlzIHRv
IG5vdCBpbmNsdWRlIHRoZSBkcml2ZXIgaW4geW91ciBrZXJuZWwgKGFuZCBub3QNCj4gPiBhbGxv
dyBtb2R1bGUgbG9hZGluZywgYnV0IGlmIHlvdSBjYW4gbG9hZCBtb2R1bGVzIHlvdSBjYW4ganVz
dCBsb2FkIGENCj4gPiBtb2R1bGUgdG8gbXVjayB3aXRoIHdoYXRldmVyIE1TUiB5b3Ugd2FudC4p
DQo+IA0KPiBJIHdhcyBjb250ZW1wbGF0aW5nIHRoYXQgdG9vLiBXaGF0IGlzIHRoZSB1c2UgY2Fz
ZSBvZiBoYXZpbmcNCj4gbXNyLmtvIGluIGEgc2VjdXJlIGJvb3QgZW52aXJvbm1lbnQ/IElzbid0
IHRoYXQgYW4gYWxsLW5vLXRvb2xzLA0KPiB5b3UtY2FuJ3QtZG8tc2gqdC1leGNlcHQtd2hhdC15
b3UncmUtZXhwbGljaXRseS1hbGxvd2VkLXRvIGVudmlyb25tZW50IHdoaWNoDQo+IHNpbXBseSBk
b2Vzbid0IG5lZWQgdG8gd3JpdGUgTVNScyBpbiB0aGUgZmlyc3QgcGxhY2U/DQoNCldlbGwsIHN1
cmUsIGRpc3RyaWJ1dGlvbnMgY291bGQgYnVpbGQgZXZlcnkga2VybmVsIHR3aWNlLiBUaGF0IHNl
ZW1zIGENCmxpdHRsZSBleGNlc3NpdmUsIHRob3VnaC4NCg==

