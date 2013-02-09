From: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] x86: Lock down MSR writing in secure boot
Date: Sat, 9 Feb 2013 15:11:53 +0000
Message-ID: <1360422712.18083.24.camel@x230.lan>
References: <dee64752-850c-4d78-b703-f47a985bc13e@email.android.com>
	 <CAGXu5jLAufTRm=sDST0br_WEkn4o0Hpjv2jDP2Na=cCvuM+MGg@mail.gmail.com>
	 <1360355671.18083.18.camel@x230.lan>
	 <CAGXu5jKo2PfMBO4A0ZgQcrPuj8OHNaff+CjAesOAWkZc0vB9+Q@mail.gmail.com>
	 <51157C9C.6030501@zytor.com> <20130208230655.GB28990@pd.tnic>
	 <1360366012.18083.21.camel@x230.lan> <5115A4CC.3080102@zytor.com>
	 <1360373383.18083.23.camel@x230.lan>
	 <CAGXu5j+xvJ3L5ejxtZ-Jw3F6rV7OsrE0_HZCGu_er0rH2_PwKA@mail.gmail.com>
	 <20130209092925.GA17728@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130209092925.GA17728-fF5Pk5pvG8Y@public.gmane.org>
Content-Language: en-US
Content-ID: <D5B35CDC68C90D4D84608D359B8A9F59-HX+pjaQZbrqcE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-security-module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

T24gU2F0LCAyMDEzLTAyLTA5IGF0IDEwOjI5ICswMTAwLCBCb3Jpc2xhdiBQZXRrb3Ygd3JvdGU6
DQo+IE9uIEZyaSwgRmViIDA4LCAyMDEzIGF0IDEwOjQ1OjM1UE0gLTA4MDAsIEtlZXMgQ29vayB3
cm90ZToNCj4gPiBBbHNvLCBfcmVhZGluZ18gTVNScyBmcm9tIHVzZXJzcGFjZSBhcmd1YWJseSBo
YXMgdXRpbGl0eSB0aGF0IGRvZXNuJ3QNCj4gPiBjb21wcm9taXNlIHJpbmctMC4NCj4gDQo+IEFu
ZCB0byBjb21lIGJhY2sgdG8gdGhlIG9yaWdpbmFsIHF1ZXN0aW9uOiB3aGF0IGlzIHRoYXQgdXRp
bGl0eSwgd2hvDQo+IHdvdWxkIG5lZWQgaXQgb24gYSBzZWN1cmUgYm9vdCBzeXN0ZW0gYW5kIHdo
eT8NCg0KVGhpbmdzIGxpa2UgVHVyYm9zdGF0IGFyZSB1c2VmdWwsIGFsdGhvdWdoIHBlcmhhcHMg
dGhhdCBpbmZvcm1hdGlvbg0Kc2hvdWxkIGJlIGV4cG9zZWQgaW4gYSBiZXR0ZXIgd2F5Lg0K
