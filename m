From: Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org>
Subject: RE: [RFC][PATCH 3/7] efivars: New efivar_entry API
Date: Fri, 8 Feb 2013 23:22:35 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D414A885F3@USINDEM103.corp.hds.com>
References: <1360357158-8168-1-git-send-email-matt@console-pimps.org>
	 <1360357158-8168-4-git-send-email-matt@console-pimps.org>
	 <A5ED84D3BB3A384992CBB9C77DEDA4D414A88489@USINDEM103.corp.hds.com>
	 <1360362300.7515.307.camel@mfleming-mobl1.ger.corp.intel.com>
	 <A5ED84D3BB3A384992CBB9C77DEDA4D414A8853D@USINDEM103.corp.hds.com>
 <1360364195.7515.314.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1360364195.7515.314.camel-ZqTwcBeJ+wsBof6jY8KHXm7IUlhRatedral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

PiANCj4gSXQncyBwcm9iYWJseSBzdGlsbCBwb3NzaWJsZSB0byBoYXZlIGEgQ1BVIGNyZWF0aW5n
IGFuIEVGSSB2YXJpYWJsZSB2aWEgdGhlIHN5c2ZzIGZpbGVzIHdoaWxlIGFub3RoZXIgQ1BVIGlz
IGluIHRoZSBwc3RvcmUgd3JpdGUgcGF0aCwgYnV0IEknbQ0KPiBub3QgY29udmluY2VkIG1ha2lu
ZyB0aGUgcXVlcnlfdmFyaWFibGVfaW5mbygpIGFuZCBzZXRfdmFyaWFibGUoKSBhdG9taWMgaXMg
c29tZXRoaW5nIHRoYXQgd2UgbmVlZCB0byB3b3JyeSBhYm91dC4NCg0KDQpXaGVuIEkgdGFsa2Vk
IGFib3V0IHF1ZXJ5X3ZhcmlhYmxlX2luZm8oKSB3aXRoIFRvbnksIA0KTWF0dGhldyBjb21tZW50
ZWQgYXMgZm9sbG93cy4NCg0KaHR0cDovL21hcmMuaW5mby8/bD1saW51eC1rZXJuZWwmbT0xMzQz
MDUzMjU4MDE3ODkmdz0yDQoNCjxzbmlwPg0KUnVubmluZyBvdXQgb2Ygc3BhY2UgaW4gRUZJIGlz
bid0IGEgd2VsbC10ZXN0ZWQgc2NlbmFyaW8sIGFuZCBJIHdvdWxkbid0IA0KZXhwZWN0IGFsbCBm
aXJtd2FyZSB0byBoYW5kbGUgaXQgZ3JhY2VmdWxseS4gVGhpcyBpcyBtYWRlIHdvcnNlIGJ5IEVG
SSAxIA0Kbm90IHByb3ZpZGluZyBhbnkgaW5mb3JtYXRpb24gYWJvdXQgYXZhaWxhYmxlIHN0b3Jh
Z2UuDQo8c25pcD4NCg0KSSdtIGp1c3QgY29uY2VybmVkIHRoYXQgc2V0X3ZhcmlhYmxlKCkgbWF5
IHJ1biBpbiB0aGUgIG91dCBvZiBzcGFjZSBzaXR1YXRpb24gDQppZiBxdWVyeV92YXJpYWJsZV9p
bmZvKCkgYW5kIHNldF92YXJpYWJsZSgpIGFyZSBub3QgYXRvbWljLg0KDQpTZWlqaQ0KDQoNCj4g
DQo+IC0tDQo+IE1hdHQgRmxlbWluZywgSW50ZWwgT3BlbiBTb3VyY2UgVGVjaG5vbG9neSBDZW50
ZXINCg0K
