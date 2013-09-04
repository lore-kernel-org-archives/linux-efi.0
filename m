From: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V3 02/11] PCI: Lock down BAR access when module security
 is enabled
Date: Wed, 4 Sep 2013 19:01:54 +0000
Message-ID: <1378321314.13193.7.camel@x230>
References: <1378252218-18798-1-git-send-email-matthew.garrett@nebula.com>
	 <1378252218-18798-3-git-send-email-matthew.garrett@nebula.com>
	 <1378313861.4210.39.camel@i7.infradead.org> <1378314286.13193.5.camel@x230>
	 <1378321109.2627.9.camel@shinybook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1378321109.2627.9.camel-Fexsq3y4057IgHVZqg5X0TlWvGAXklZc@public.gmane.org>
Content-Language: en-US
Content-ID: <481BA1B98576C84B98CA7978BF68F865-HX+pjaQZbrqcE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org" <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

T24gV2VkLCAyMDEzLTA5LTA0IGF0IDE5OjU4ICswMTAwLCBEYXZpZCBXb29kaG91c2Ugd3JvdGU6
DQo+IE9uIFdlZCwgMjAxMy0wOS0wNCBhdCAxNzowNCArMDAwMCwgTWF0dGhldyBHYXJyZXR0IHdy
b3RlOg0KDQo+ID4gSG93IGRvZXMgdmlydCBwYXNzdGhyb3VnaCB3b3JrIGluIHRoaXMgY2FzZT8g
VGhlIGN1cnJlbnQgc2l0dWF0aW9uDQo+ID4gYXBwZWFycyB0byBiZSB0aGF0IHFlbXUganVzdCBw
YXNzZXMgdGhlIEJBUnMgdGhyb3VnaCB0byB0aGUgZ3Vlc3QsIGFuZA0KPiA+IGl0J3MgdGhlIGd1
ZXN0IHRoYXQgc2V0cyB0aGluZ3MgdXAuIFdlJ2QgbmVlZCB0byBiZSBhYmxlIHRvIGVuc3VyZSB0
aGF0DQo+ID4gdGhlcmUncyBubyB3YXkgdGhlIGd1ZXN0IGRyaXZlciBjYW4gY2F1c2UgRE1BIGlu
dG8gdGhlIGhvc3Qga2VybmVsLg0KPiANCj4gV2Ugc2V0IHVwIHRoZSBJT01NVSBwYWdlIHRhYmxl
cyBzbyB0aGF0IHRoZSB2aXJ0dWFsIGJ1cyBhZGRyZXNzZXMgc2Vlbg0KPiBieSB0aGUgUENJIGRl
dmljZSBhcmUgMToxIG1hcHBlZCB0byB0aGUgZ3Vlc3QgInBoeXNpY2FsIiBhZGRyZXNzIHNwYWNl
Lg0KPiANCj4gVGhhdCBpcywgd2hhdCB0aGUgUENJIGRldmljZSBzZWVzIGFzIGEgInBoeXNpY2Fs
IiBhZGRyZXNzIGlzIGVxdWl2YWxlbnQNCj4gdG8gd2hhdCB0aGUgZ3Vlc3Qgc2VlcyBhcyBhICJw
aHlzaWNhbCIgYWRkcmVzcyBzcGFjZS4gSXQgY2FuIGFjY2Vzcw0KPiBtZW1vcnkgd2hpY2ggYmVs
b25ncyB0byB0aGF0IGd1ZXN0LCBhbmQgbm90aGluZyBlbHNlLiBTbyB0aGF0IHNob3VsZCBiZQ0K
PiBmaW5lLg0KDQpCdXQgcHJlc3VtYWJseSB0aGUgZ3Vlc3QncyB2aWV3IG9mIFJBTSBpcyB3aGF0
IGdldHMgd3JpdHRlbiB0byB0aGUgQkFScz8NCkkgZ3Vlc3MgaWYgd2Uga25vdyBpdCdzIGNvbnN0
cmFpbmVkIHRoZW4gdGhlcmUncyBubyBuZWVkIHRvIHJlc3RyaWN0IHRoZQ0KYWRkcmVzc2VzIHRo
YXQgY2FuIGJlIHNldCAtIHdlIGtub3cgdGhhdCB0aGV5J2xsIGJlIHVuYWJsZSB0byBvdmVybGFw
DQp0aGUgaG9zdCBSQU0uDQoNCi0tIA0KTWF0dGhldyBHYXJyZXR0IDxtYXR0aGV3LmdhcnJldHRA
bmVidWxhLmNvbT4NCg==
