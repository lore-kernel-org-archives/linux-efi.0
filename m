From: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 06/14] rtc-efi: register rtc-efi device when EFI
 enabled
Date: Fri, 20 Dec 2013 15:14:23 +0000
Message-ID: <1387552463.17961.2.camel@x230>
References: <1387439515-8926-1-git-send-email-jlee@suse.com>
	 <1387439515-8926-7-git-send-email-jlee@suse.com>
	 <20131219140918.GF3145@console-pimps.org>
	 <1387513491.3539.4345.camel@linux-s257.site> <52B3C7F8.3040901@zytor.com>
	 <20131220103755.GA14784@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131220103755.GA14784-fF5Pk5pvG8Y@public.gmane.org>
Content-Language: en-US
Content-ID: <92B7898EFB5493428003ABBCD41DE64A-HX+pjaQZbrqcE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org" <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: "samer.el-haj-mahmoud-VXdhtT5mjnY@public.gmane.org" <samer.el-haj-mahmoud-VXdhtT5mjnY@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "jlee-IBi9RG/b67k@public.gmane.org" <jlee-IBi9RG/b67k@public.gmane.org>, "tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org" <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "a.zummo-BfzFCNDTiLLj+vYz1yj4TQ@public.gmane.org" <a.zummo-BfzFCNDTiLLj+vYz1yj4TQ@public.gmane.org>, "Elliott-VXdhtT5mjnY@public.gmane.org" <Elliott-VXdhtT5mjnY@public.gmane.org>, "werner-IBi9RG/b67k@public.gmane.org" <werner-IBi9RG/b67k@public.gmane.org>, "rtc-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org" <rtc-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, "mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "oneukum-l3A5Bk7waGM@public.gmane.org" <oneukum-l3A5Bk7waGM@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "trenn-l3A5Bk7waGM@public.gmane.org" <trenn-l3A5Bk7waGM@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "JBeulich-IBi9RG/b67k@public.gmane.org" <JBeulich-IBi9RG/b67k@public.gmane.org>, "linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org" <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

T24gRnJpLCAyMDEzLTEyLTIwIGF0IDExOjM3ICswMTAwLCBCb3Jpc2xhdiBQZXRrb3Ygd3JvdGU6
DQo+IE9uIFRodSwgRGVjIDE5LCAyMDEzIGF0IDA4OjMwOjQ4UE0gLTA4MDAsIEguIFBldGVyIEFu
dmluIHdyb3RlOg0KPiA+IE9uIDEyLzE5LzIwMTMgMDg6MjQgUE0sIGpvZXlsaSB3cm90ZToNCj4g
PiA+IEkgYWdyZWVkLCBidXQgdXNlcnNwYWNlIGFwcGxpY2F0aW9uIHNob3VsZCBub3QgYmUgdG9v
IG9mdGVuIHRvIGFjY2Vzcw0KPiA+ID4gUlRDLiBNYXliZSBvbmx5IHdoZW4gc3lzdGVtIGJvb3Qg
YW5kIHNldCB0aW1lem9uZS4NCj4gPg0KPiA+IFRoaXMgaXMsIHF1aXRlIGZyYW5rbHksIGFuIGlk
aW90aWMgYXJndW1lbnQuDQo+IA0KPiBUQkgsIEkndmUgYmVlbiBzdHJ1Z2dsaW5nIHdpdGggdGhl
IHF1ZXN0aW9uIHRvbyAtIGFuZCBpdCBtaWdodCBldmVuIGJlIGENCj4gc3R1cGlkIHF1ZXN0aW9u
IC0gYnV0IHdoYXQgaXMgdGhhdCBhYnNvbHV0ZSBuZWVkIHRvIGJlIGFibGUgdG8gZ2V0IHRoZQ0K
PiBUWiBpbiB1c2Vyc3BhY2U/IFdoeSBzaG91bGQgSSBjYXJlPw0KPiANCj4gQ2FuIHdlIGdldCBz
b21lIHVzZSBjYXNlcyBmb3Igc3R1cGlkIHBlb3BsZSBsaWtlIG1lIHBsZWFzZT8NCg0KRHVhbC1i
b290IGVudmlyb25tZW50cyB3aWxsIHRlbmQgdG8gaGF2ZSB0aGUgUlRDIGluIGxvY2FsIHRpbWUs
IG5vdCBVVEMuDQpUaGF0IG1lYW5zIHRoYXQgdXNlcnNwYWNlIGhhcyB0byByZXByb2dyYW0gdGhl
IGNsb2NrIG92ZXIgZGF5bGlnaHQNCnNhdmluZ3MgY2hhbmdlcywgYW5kIHRvIGRvIHRoYXQgaXQg
bXVzdCBrbm93IHdoZXRoZXIgYW5vdGhlciBPUyBoYXMNCmFscmVhZHkgZG9uZSBzby4NCg0KLS0g
DQpNYXR0aGV3IEdhcnJldHQgPG1hdHRoZXcuZ2FycmV0dEBuZWJ1bGEuY29tPg0K
