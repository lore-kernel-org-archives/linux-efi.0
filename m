From: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [regression, bisected] x86: efi: Pass boot services variable
 info to runtime code
Date: Thu, 30 May 2013 22:32:09 +0000
Message-ID: <1369953129.11620.15.camel@x230>
References: <20130523115801.GJ14575@console-pimps.org>
	 <20130523203234.GD20913@sgi.com> <20130524074331.GL14575@console-pimps.org>
	 <20130529210115.GC28027@sgi.com>
	 <alpine.LRH.2.00.1305300018180.1111@twin.jikos.cz>
	 <20130529224645.GA16582@sgi.com>
	 <alpine.LNX.2.00.1305300048520.30576@pobox.suse.cz>
	 <1369880172.17397.11.camel@linux-s257.site>
	 <20130530221737.GA11105@sgi.com> <1369952512.11620.14.camel@x230>
	 <20130530222836.GB11105@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130530222836.GB11105-sJ/iWh9BUns@public.gmane.org>
Content-Language: en-US
Content-ID: <19611AE13F041C49A746B8C0303F99BF-HX+pjaQZbrqcE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Russ Anderson <rja-sJ/iWh9BUns@public.gmane.org>
Cc: joeyli <jlee-IBi9RG/b67k@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H. Peter Anvin" <hpa-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

T24gVGh1LCAyMDEzLTA1LTMwIGF0IDE3OjI4IC0wNTAwLCBSdXNzIEFuZGVyc29uIHdyb3RlOg0K
PiBPbiBUaHUsIE1heSAzMCwgMjAxMyBhdCAxMDoyMTo1M1BNICswMDAwLCBNYXR0aGV3IEdhcnJl
dHQgd3JvdGU6DQo+ID4gT24gVGh1LCAyMDEzLTA1LTMwIGF0IDE3OjE3IC0wNTAwLCBSdXNzIEFu
ZGVyc29uIHdyb3RlOg0KPiA+IA0KPiA+ID4gVGhhdCdzIGEgZ3JlYXQgaWRlYS4gIFRoaXMgcGF0
Y2ggbW92ZXMgdGhlIFF1ZXJ5VmFyaWFibGVJbmZvKCkNCj4gPiA+IGNhbGwgZnJvbSBib290aW1l
IHRvIHJ1bnRpbWUsIGluIGVmaV9sYXRlX2luaXQoKS4gIFRoZSBhdHRhY2hlZA0KPiA+ID4gcGF0
Y2ggaXMgY29uc2lzdGVudCB3aXRoIHRoZSBVRUZJIHNwZWMgYW5kIGF2b2lkcyB0aGUgcHJvYmxl
bS4NCj4gPiANCj4gPiBObywgdGhhdCBkZWZlYXRzIHRoZSBlbnRpcmUgcG9pbnQgb2YgdGhlIG9y
aWdpbmFsIHBhdGNoLg0KPiANCj4gSG93IHNvPyAgSXQgaXMgc3RpbGwgY2FsbGluZyBRdWVyeVZh
cmlhYmxlSW5mbygpDQo+IGJlZm9yZSB0aGUgZGF0YSBpcyB1c2VkLg0KDQpXZSB3YW50IHRvIGtu
b3cgaG93IG11Y2ggc3BhY2UgaXMgdXNlZCBieSB2YXJpYWJsZXMgdGhhdCBhcmVuJ3QgdmlzaWJs
ZQ0KYXQgcnVudGltZS4NCg0KLS0gDQpNYXR0aGV3IEdhcnJldHQgfCBtamc1OUBzcmNmLnVjYW0u
b3JnDQo=
