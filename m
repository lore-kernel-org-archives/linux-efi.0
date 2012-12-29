From: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/3] rtc-efi: register rtc-efi device when EFI enabled
Date: Sat, 29 Dec 2012 04:37:29 +0000
Message-ID: <E99CBA9F97C3D149AA6B19ED2E277C9B01921744@BY2PRD0510MB365.namprd05.prod.outlook.com>
References: <1356712001-12198-1-git-send-email-jlee@suse.com>
	  <E99CBA9F97C3D149AA6B19ED2E277C9B019215CC@BY2PRD0510MB365.namprd05.prod.outlook.com>
	  <3fa7337e-6bbc-4462-9704-2d8ac20a9cf2@email.android.com>
	  <E99CBA9F97C3D149AA6B19ED2E277C9B019215FA@BY2PRD0510MB365.namprd05.prod.outlook.com>
	  <50DE03D8.9030902@zytor.com>
	  <E99CBA9F97C3D149AA6B19ED2E277C9B01921638@BY2PRD0510MB365.namprd05.prod.outlook.com>
	  <35da3df5-ecac-4b57-83a2-828326e5bfc3@email.android.com>
	 <E99CBA9F97C3D149AA6B19ED2E277C9B0192169D@BY2PRD0510MB365.namprd05.prod.outlook.com>
	 <50DE3C8F.4000405@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50DE3C8F.4000405-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Content-ID: <C4A7BF5DB02A514FA4C90B4E5679BD85-HX+pjaQZbrqcE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: "Lee, Chun-Yi" <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jan Beulich <JBeulich-IBi9RG/b67k@public.gmane.org>, Len Brown <lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Arjan van de Ven <arjan-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

T24gRnJpLCAyMDEyLTEyLTI4IGF0IDE2OjQyIC0wODAwLCBILiBQZXRlciBBbnZpbiB3cm90ZToN
Cj4gT24gMTIvMjgvMjAxMiAwMzozOSBQTSwgTWF0dGhldyBHYXJyZXR0IHdyb3RlOg0KPiA+IE9u
IEZyaSwgMjAxMi0xMi0yOCBhdCAxNTozMiAtMDgwMCwgSC4gUGV0ZXIgQW52aW4gd3JvdGU6DQo+
ID4+IE5vLCB0aGF0IGlzIGV4cGxpY2l0bHkgdGhlIG9yZGVyaW5nIHRoYXQgaXMgZXhjbHVkYWJs
ZS4NCj4gPiANCj4gPiBXaW5kb3dzIHVzZXMgdGhlIFVFRkkgdGltZSBmdW5jdGlvbnMuIFRoZSBm
YWN0IHRoYXQgdGhleSBmYWlsIGZvciB1cyBvbg0KPiA+IGEgYnVuY2ggb2Ygc3lzdGVtcyBpcyBq
dXN0IGFub3RoZXIgc3ltcHRvbSBvZiBvdXIgZ2VuZXJhbCBmYWlsdXJlIHRvDQo+ID4gYWNjdXJh
dGVseSBtaW1pYyBXaW5kb3dzIHdoZW4gbWFraW5nIHJ1bnRpbWUgY2FsbHMsIGFuZCB3ZSBzaG91
bGQganVzdA0KPiA+IG1ha2Ugc3VyZSB0aGF0IHRoYXQgZ2V0cyBmaXhlZCByYXRoZXIgdGhhbiBs
YXllcmluZyBtb3JlIHdvcmthcm91bmRzIG9uDQo+ID4gdG9wLiBJdCdzIGFuIGVtYmFycmFzc21l
bnQgdGhhdCB3ZSdyZSBzdGlsbCB1bmFibGUgdG8gZGVhbCB3aXRoDQo+ID4gcGxhdGZvcm1zIHRo
YXQgd29yayBmaW5lIHdpdGggYW5vdGhlciBPUy4gDQo+ID4gDQo+IA0KPiBBcmUgdGhleSB1c2lu
ZyB0aGVtIGluIHByZWZlcmVuY2UgdG8gQUNQST8gIFRoaXMgc2VlbXMgYSBiaXQgb2RkLCBzaW5j
ZQ0KPiBvbmUgY2FuIHByZXN1bWUgdGhhdCB0aGUgQUNQSSBmdW5jdGlvbnMgd2VyZSBhZGRlZCBh
dCBNaWNyb3NvZnQncyByZXF1ZXN0Li4uDQoNCkluIHByZWZlcmVuY2UgdG8gdGhlIEFDUEkgUlRD
LCBJIGhhdmVuJ3QgeWV0IGhhZCBhbiBBQ1BJIDUuMCBUQUQgZGV2aWNlDQp0byB0ZXN0IGluIGNv
bXBhcmlzb24uDQo=
