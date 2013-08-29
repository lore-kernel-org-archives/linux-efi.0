From: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 05/10] asus-wmi: Restrict debugfs interface when module
 loading is restricted
Date: Thu, 29 Aug 2013 18:49:13 +0000
Message-ID: <1377802153.27493.18.camel@x230>
References: <1376928619-3775-1-git-send-email-matthew.garrett@nebula.com>
	 <1376928619-3775-5-git-send-email-matthew.garrett@nebula.com>
	 <521F9162.9060405@zytor.com> <1377801331.27493.17.camel@x230>
	 <521F9708.6040902@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <521F9708.6040902-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Content-ID: <868D5DF701FCC142A37BC7CEB63BBC8F-HX+pjaQZbrqcE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org" <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

T24gVGh1LCAyMDEzLTA4LTI5IGF0IDExOjQ2IC0wNzAwLCBILiBQZXRlciBBbnZpbiB3cm90ZToN
Cj4gT24gMDgvMjkvMjAxMyAxMTozNSBBTSwgTWF0dGhldyBHYXJyZXR0IHdyb3RlOg0KPiA+IE9u
IFRodSwgMjAxMy0wOC0yOSBhdCAxMToyMiAtMDcwMCwgSC4gUGV0ZXIgQW52aW4gd3JvdGU6DQo+
ID4+IE9uIDA4LzE5LzIwMTMgMDk6MTAgQU0sIE1hdHRoZXcgR2FycmV0dCB3cm90ZToNCj4gPj4+
ICsJaWYgKCFjYXBhYmxlKENBUF9DT01QUk9NSVNFX0tFUk5FTCkpDQo+ID4+PiArCQlyZXR1cm4g
LUVQRVJNOw0KPiA+Pj4gKw0KPiA+Pg0KPiA+PiBTdGFsZSBiaXRzPw0KPiA+IA0KPiA+IFllYWgu
IERpZCBJIG1hbmFnZSB0byBzZW5kIG91dCB0aGUgb2xkIGNvcHkgb2YgdGhhdCBhZ2Fpbj8gSSdt
IHNvcnJ5LA0KPiA+IHNwZW5kaW5nIGEgZmV3IG1vbnRocyBjb25jZW50cmF0aW5nIG9uIGNsb3Vk
IHN0dWZmIHNlZW1zIHRvIGhhdmUNCj4gPiBlbnRpcmVseSBkZXN0cm95ZWQgbXkgYWJpbGl0eSB0
byBkZWFsIHdpdGggZ2l0IDooDQo+ID4gDQo+IA0KPiBObywgeW91IG1peGVkIGFuZCBtYXRjaGVk
IGluIGEgc2luZ2xlIHBhdGNoLi4uDQoNClJpZ2h0LCBidXQgSSdkIGZpeGVkIHRoYXQgaW4gVjIg
KHdoaWNoIEkgc2VlIEkgKmRpZCogc2VuZCBjb3JyZWN0bHksIGFuZA0KeW91J3JlIGp1c3QgcmVw
bHlpbmcgdG8gdGhlIG9sZCBvbmUgOikpDQoNCj4gSSBzdGlsbCBiZWxpZXZlIHRoYXQgQ0FQX1JB
V0lPIHNob3VsZCBiZSBmb3JiaWRkZW4gaW4gdGhpcyBjYXNlLg0KDQpTZWVtcyBmYWlyLg0KDQot
LSANCk1hdHRoZXcgR2FycmV0dCA8bWF0dGhldy5nYXJyZXR0QG5lYnVsYS5jb20+DQo=
