From: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [regression, bisected] x86: efi: Pass boot services variable
 info to runtime code
Date: Fri, 24 May 2013 20:11:01 +0000
Message-ID: <1369426255.2217.9.camel@x230>
References: <20130522162747.GA20816@sgi.com>
	 <20130523115801.GJ14575@console-pimps.org> <20130523203234.GD20913@sgi.com>
	 <20130524074331.GL14575@console-pimps.org> <20130524200539.GA3322@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130524200539.GA3322-sJ/iWh9BUns@public.gmane.org>
Content-Language: en-US
Content-ID: <57B58A5C84456A4E8B5B8EA858867C69-HX+pjaQZbrqcE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Russ Anderson <rja-sJ/iWh9BUns@public.gmane.org>
Cc: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H. Peter Anvin" <hpa-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

T24gRnJpLCAyMDEzLTA1LTI0IGF0IDE1OjA1IC0wNTAwLCBSdXNzIEFuZGVyc29uIHdyb3RlOg0K
DQo+IE9uZSBvdGhlciBkYXRhIHBvaW50IGlzIGlmIHRoZSBxdWVyeV92YXJpYWJsZV9pbmZvIGNh
bGwgaXMgaGFja2VkIHRvDQo+IHJlbW92ZSBvbmUgb2YgdGhlIEVGSSBmbGFncyAoaWUgY29tbWVu
dCBvdXQgRUZJX1ZBUklBQkxFX0JPT1RTRVJWSUNFX0FDQ0VTUykNCj4gdGhlIGVmaV9jYWxsX3Bo
eXM0KCkgY2FsbCBmYWlscyB3aXRoIEVGSV9JTlZBTElEX1BBUkFNRVRFUiBhbmQNCj4gdGhlIHN5
c3RlbSBib290cy4gIE9mIGNvdXJzZSBpdCBkb2VzIG5vdCBjcmVhdGUgL3N5cy9maXJtd2FyZS9l
Zml2YXJzDQo+IGVudHJpZXMgYW5kIGNvbXBsYWlucyAiW0Zpcm13YXJlIEJ1Z106IGVmaTogSW5j
b25zaXN0ZW50IGluaXRpYWwgc2l6ZXMiLg0KPiBCdXQgYXQgbGVhc3QgaXQgYm9vdHMuDQoNCkVG
SV9WQVJJQUJMRV9SVU5USU1FX0FDQ0VTUyBpcyBvbmx5IGxlZ2FsIGlmDQpFRklfVkFSSUFCTEVf
Qk9PVFNFUlZJQ0VfQUNDRVNTIGlzIHNldCwgc28gaXQncyBjb3JyZWN0IHRvIHRocm93DQpFRklf
SU5WQUxJRF9QQVJBTUVURVIgdGhlcmUuDQoNCi0tIA0KTWF0dGhldyBHYXJyZXR0IHwgbWpnNTlA
c3JjZi51Y2FtLm9yZw0K
