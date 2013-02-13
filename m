From: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] x86: Lock down MSR writing in secure boot
Date: Wed, 13 Feb 2013 06:41:54 +0000
Message-ID: <1360737709.18083.36.camel@x230.lan>
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
	 <511B33BC.9080307@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <511B33BC.9080307-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Content-ID: <C29551B43455304F91C8F513D9BA0249-HX+pjaQZbrqcE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-security-module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

T24gVHVlLCAyMDEzLTAyLTEyIGF0IDIyOjMzIC0wODAwLCBILiBQZXRlciBBbnZpbiB3cm90ZToN
Cg0KPiBUaGF0IGlzIGp1c3QgYmF0c2hpdCBjcmF6eS4gIElmIHlvdSBoYXZlIENBUF9TWVNfUkFX
SU8geW91IGNhbiBkbyBpb3BsKCkgDQo+IHdoaWNoIG1lYW5zIHlvdSBjYW4gcmVwcm9ncmFtIHlv
dXIgbm9ydGhicmlkZ2UsIGF0IHdoaWNoIHBvaW50IHlvdSBtb3N0IA0KPiBkZWZpbml0ZWx5ICpj
YW4qIG1vZGlmeSB0aGUgcnVubmluZyBrZXJuZWwuDQoNCldlbGwgcmlnaHQsIHRoYXQncyB0aGUg
cG9pbnQgb2YgdGhpcyBwYXRjaHNldCAtIGl0IGFkZHMgc29tZSBleHRyYQ0KcGVybWlzc2lvbiBj
aGVja3MgdG8gc29tZSBvZiB0aGUgZXhpc3RpbmcgQ0FQX1NZU19SQVdJTyBjaGVja3MuDQpDQVBf
U1lTX1JBV0lPIGhhc24ndCBtZWFudCAiSSBjYW4gcGVyZm9ybSBhcmJpdHJhcnkgcGlvIGFuZCBt
bWlvIiBmb3INCnllYXJzIC0gaXQgbWVhbnMgIkkgY2FuIGRvIHRoaW5ncyB0aGF0IG1pZ2h0IG1h
eWJlIGJyZWFrIHNvbWV0aGluZw0Kc29tZWhvdyIuIFNvIHN1cmUsIHJlbW92aW5nIENBUF9TWVNf
UkFXSU8gd291bGQgZ2l2ZSB1cyBiYXNpY2FsbHkgYWxsDQp0aGUgc2VjdXJpdHkgd2Ugd2FudCBp
biBhIHNlY3VyZSBib290IGVudmlyb25tZW50LCBidXQgaXQgd291bGQgYWxzbw0KYmxvY2sgdGhp
bmdzIHRoYXQgd2UgKndhbnQqIHRvIHdvcmsuDQo=
