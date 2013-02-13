From: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] x86: Lock down MSR writing in secure boot
Date: Wed, 13 Feb 2013 17:56:19 +0000
Message-ID: <1360778179.18083.42.camel@x230.lan>
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
	  <511BCB6E.8080102@zytor.com> <1360776399.18083.39.camel@x230.lan>
	 <511BD291.1040003@schaufler-ca.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <511BD291.1040003-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>
Content-Language: en-US
Content-ID: <8CF6D62F07333E4CA65E009AE2BDD1E6-HX+pjaQZbrqcE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-security-module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

T24gV2VkLCAyMDEzLTAyLTEzIGF0IDA5OjUxIC0wODAwLCBDYXNleSBTY2hhdWZsZXIgd3JvdGU6
DQo+IE9uIDIvMTMvMjAxMyA5OjI2IEFNLCBNYXR0aGV3IEdhcnJldHQgd3JvdGU6DQo+ID4gQWRt
aXQgdGhhdCBDQVBfU1lTX1JBV0lPIGlzIGZ1Y2tlZCB1cCBiZXlvbmQgcmVzY3VlLiBBZGQgYSBu
ZXcNCj4gPiBjYXBhYmlsaXR5IHdpdGggd2VsbC1kZWZpbmVkIHNlbWFudGljcy4NCj4gDQo+IFlv
dSBjYW4ndCBhZGQgYSBuZXcgY2FwYWJpbGl0eSB3aGVyZSB0aGVyZSBpcyBhbiBleGlzdGluZyBj
YXBhYmlsaXR5DQo+IHRoYXQgY2FuIGJlIHJlbW90ZWx5IGFyZ3VlZCB0byBiZSBhcHByb3ByaWF0
ZS4NCg0KQ0FQX1NZU19SQVdJTyBjYW4ndCBiZSBhcmd1ZWQgdG8gYmUgYXBwcm9wcmlhdGUuIEl0
IGNvdmVycyBhIHJhbmdlIG9mDQpmdW5jdGlvbmFsaXR5IHRoYXQgZG9lc24ndCBwZXJtaXQgdGhl
IHJ1bm5pbmcga2VybmVsIHRvIGJlIG1vZGlmaWVkIGFuZA0Kd2hpY2ggaXMgcmVxdWlyZWQgdG8g
cHJvdmlkZSBhIGZ1bmN0aW9uYWwgTGludXggc3lzdGVtLiBVc2luZyBpdCB3b3VsZA0KcmVxdWly
ZSByZWRlZmluaW5nIGl0cyBleGlzdGluZyB1c2FnZSwgd2hpY2ggd291bGQgYnJlYWsgZXhpc3Rp
bmcNCnVzZXJzcGFjZS4NCg0KLS0gDQpNYXR0aGV3IEdhcnJldHQgfCBtamc1OUBzcmNmLnVjYW0u
b3JnDQo=
