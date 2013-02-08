From: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] x86: Lock down MSR writing in secure boot
Date: Fri, 8 Feb 2013 19:27:09 +0000
Message-ID: <1360351629.18083.15.camel@x230.lan>
References: <20130208191213.GA25081@www.outflux.net>
	 <1360351047.18083.14.camel@x230.lan>
	 <CAGXu5j+aXxQb_Jyn6G+JUdjNOF2EGo9pTw8dBYuZUTb+S1vWow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAGXu5j+aXxQb_Jyn6G+JUdjNOF2EGo9pTw8dBYuZUTb+S1vWow-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Content-ID: <1D2B3823B22DE547BEB4061801F001D6-HX+pjaQZbrqcE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

T24gRnJpLCAyMDEzLTAyLTA4IGF0IDExOjIxIC0wODAwLCBLZWVzIENvb2sgd3JvdGU6DQo+IE9u
IEZyaSwgRmViIDgsIDIwMTMgYXQgMTE6MTcgQU0sIE1hdHRoZXcgR2FycmV0dA0KPiA8bWF0dGhl
dy5nYXJyZXR0QG5lYnVsYS5jb20+IHdyb3RlOg0KPiA+IE9uIEZyaSwgMjAxMy0wMi0wOCBhdCAx
MToxMiAtMDgwMCwgS2VlcyBDb29rIHdyb3RlOg0KPiA+PiBXcml0aW5nIHRvIE1TUnMgc2hvdWxk
IG5vdCBiZSBhbGxvd2VkIHVubGVzcyBDQVBfQ09NUFJPTUlTRV9LRVJORUwgaXMNCj4gPj4gc2V0
IHNpbmNlIGl0IGNvdWxkIGxlYWQgdG8gZXhlY3V0aW9uIG9mIGFyYml0cmFyeSBjb2RlIGluIGtl
cm5lbCBtb2RlLg0KPiA+DQo+ID4gV2lsbGluZyB0byBidXkgdGhpcywgYnV0IGRvIHlvdSBoYXZl
IGEgZGVzY3JpcHRpb24gb2Ygb25lIHBvdGVudGlhbA0KPiA+IGFwcHJvYWNoPyBXZSBzaG91bGQg
cHJvYmFibHkgYWxzbyBmaWd1cmUgb3V0IHdoYXQncyB3cml0aW5nIHRvIE1TUnMgYXQNCj4gPiB0
aGUgbW9tZW50IChhbnl0aGluZyBvdGhlciB0aGFuIGVuZXJneV9wZXJmX2JpYXM/KSBhbmQgZGVj
aWRlIHdoYXQgdGhlDQo+ID4gYmVzdCB0aGluZyB0byBkbyB0aGVyZSBpcy4NCj4gDQo+IFllcywg
Y2hhbmdlIHRoZSBTWVNFTlRFUiBlbnRyeSBwb2ludCB0byB3aGVyZS1ldmVyIHlvdSBsaWtlLiBU
aGVyZSBhcmUNCj4gZXhhbXBsZXMgYWxyZWFkeSB3cml0dGVuOg0KPiBodHRwOi8vZ3JzZWN1cml0
eS5uZXQvfnNwZW5kZXIvbXNyMzIuYw0KDQpDb29sLiBZdXAsIHRoaXMgc291bmRzIGxpa2UgYSBn
b29kIHBsYW4uDQo=
