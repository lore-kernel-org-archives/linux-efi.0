From: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] Remove warning in efi_enter_virtual_mode
Date: Thu, 18 Apr 2013 19:58:03 +0000
Message-ID: <1366315083.13667.19.camel@x230.lan>
References: <1366127886-31460-1-git-send-email-bryan.odonoghue.lkml@nexus-software.ie>
	 <516EAC4A.6040202@console-pimps.org> <516F1B90.9040508@nexus-software.ie>
	 <516FD24A.3070502@console-pimps.org> <20130418163325.GA6884@leaf>
	 <5170216C.9020300@zytor.com> <20130418164457.GB6884@leaf>
	 <51704FA8.7060801@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51704FA8.7060801-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Content-Language: en-US
Content-ID: <E4A3B1B37188294BA13C5A563951A0B7-HX+pjaQZbrqcE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Bryan O'Donoghue <bryan.odonoghue.lkml-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Darren Hart <darren.hart-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

T24gVGh1LCAyMDEzLTA0LTE4IGF0IDIwOjU1ICswMTAwLCBNYXR0IEZsZW1pbmcgd3JvdGU6DQoN
Cj4gSWYgdGhlcmUgYXJlIG1hY2hpbmVzIG91dCB0aGVyZSB0aGF0IHdvdWxkIHJlcXVpcmUgdXMg
dG8gd3JpdGUgc3VwcG9ydCwNCj4gaXQncyBwcm9iYWJseSB3b3J0aCBkb2luZyBub3cgaW5zdGVh
ZCBvZiBwdW50aW5nLiBCdXQgaXQgc291bmRzIGxpa2UNCj4gdGhlcmUgYXJlbid0IGFueS4NCg0K
SSB3b3VsZCBleHBlY3QgdGhhdCBpZiB0aGVyZSBhcmUgYW55IDMyLWJpdCBVRUZJIHN5c3RlbXMg
dGhhdCBzaGlwIHdpdGgNCkJHUlQgc3VwcG9ydCAoYW5kIERhcnJlbiBtYWtlcyBpdCBzb3VuZCBs
aWtlIHRoYXQncyBhIHBvc3NpYmlsaXR5KSwNCnRoZXJlJ3MgYSByZWFsaXN0aWMgY2hhbmNlIG9m
IHRoZSBCR1JUIGVuZGluZyB1cCBhbGxvY2F0ZWQgYWJvdmUgdGhlDQpoaWdobWVtIGJhcnJpZXIu
DQoNCi0tIA0KTWF0dGhldyBHYXJyZXR0IHwgbWpnNTlAc3JjZi51Y2FtLm9yZw0K
