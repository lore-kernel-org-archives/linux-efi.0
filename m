From: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/2] efi: Distinguish between "remaining space" and
 actually used space
Date: Wed, 3 Apr 2013 17:20:30 +0000
Message-ID: <1365009630.19098.16.camel@x230>
References: <515150EC.7040203@redhat.com>
	  <1364829240-26475-1-git-send-email-matthew.garrett@nebula.com>
	  <1364829240-26475-2-git-send-email-matthew.garrett@nebula.com>
	  <515C2A86.6070606@console-pimps.org> <1364996911.19098.9.camel@x230>
	 <515C62E6.1070004@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <515C62E6.1070004-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Content-Language: en-US
Content-ID: <96B0B8E853769340B45CAFFFF359E053-HX+pjaQZbrqcE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org" <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>, "jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org" <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

T24gV2VkLCAyMDEzLTA0LTAzIGF0IDE4OjEyICswMTAwLCBNYXR0IEZsZW1pbmcgd3JvdGU6DQoN
Cj4gVGhlIHNvbHV0aW9uIHlvdSdyZSBwcm9wb3NpbmcgaGFzIHRoZSBzYW1lIGRvd25zaWRlcyBh
cyAzKSAtIHdlIHJpc2sNCj4gaGF2aW5nIHRvIHR3ZWFrIHRoaW5ncyBlaXRoZXIgd2F5LiBUaGUg
ZGlmZmVyZW5jZSBpcyB0aGF0IGluIHRoZSBjYXNlIG9mDQo+IDMpIHRoZSB0d2Vha2luZyBpcyBh
ZGRpbmcgZW50cmllcyB0byB0aGUgd2hpdGVsaXN0LCB3aGVyZWFzIHR3ZWFraW5nDQo+IHlvdXIg
c29sdXRpb24gaGFzIG1vcmUgY2hhbmNlIG9mIGludHJvZHVjaW5nIGZ1cnRoZXIgdW53YW50ZWQN
Cj4gcmVncmVzc2lvbnMgYmVjYXVzZSB5b3UnZCBiZSB0d2Vha2luZyBhbiBhbGdvcml0aG0sIGFu
IGFsZ29yaXRobSB0aGF0DQo+IHJlbGllcyBvbiB0aGUgaW50ZXJuYWwgaW1wbGVtZW50YXRpb24g
b2YgdGhlIHZhcmlhYmxlIHN0b3JhZ2UgY29kZS4NCg0KV2UgKnJpc2sqIGhhdmluZyB0byB0d2Vh
ayB0aGluZ3MsIGFuZCB3ZSBmYWlsIG9uIHRoZSBzaWRlIG9mIHNhZmV0eS4gDQoNCj4gPiBEZWFs
aW5nIHdpdGggZmlybXdhcmUgaXMgaGFyZC4gVGhpcyBmaXhlcyAoMSkgd2l0aG91dCBsZWF2aW5n
IHVzIHdpdGgNCj4gPiAoMiksIHdoaWNoIHNlZW1zIGxpa2UgYSBuZXQgd2luLg0KPiANCj4gSSdt
IG5vdCBjb252aW5jZWQgdGhhdCBpbXBsZW1lbnRpbmcgMykgd291bGQgaW5ldml0YWJseSBsZWFk
IHRvIDIpLA0KPiBwcm92aWRlZCB0aGF0IHdlIGFwcGx5IGEgYml0IG9mIGNvbW1vbiBzZW5zZSB3
aGVuIGFkZGluZyBlbnRyaWVzLiBJJ20NCj4gbm90IGFkdm9jYXRpbmcgc29tZSBraW5kIG9mIGZs
YWcgZGF5IHdoZXJlIHdlIGFkZCB1bXB0ZWVuIG1hY2hpbmVzIHRvDQo+IHRoZSB3aGl0ZWxpc3Qu
DQo+IA0KPiBGb3IgcmVmZXJlbmNlLCBJIGp1c3QgcHVzaGVkIHR3byBwYXRjaGVzIHRvIHRoZSAn
d2hpdGVsaXN0JyBicmFuY2ggYXQsDQo+IA0KPiAgIGdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9z
Y20vbGludXgva2VybmVsL2dpdC9tZmxlbWluZy9lZmkuZ2l0DQo+IA0KPiB3aGljaCBzaG91bGQg
aG9wZWZ1bGx5IGlsbHVzdHJhdGUgdGhlIGtpbmQgb2YgdGhpbmcgdGhhdCBJJ20gdGFsa2luZyBh
Ym91dC4NCg0KSSBkb24ndCB0aGluayB0aGF0IHdvcmtzLiBQZW9wbGUgYXJlIGNvbXBsYWluaW5n
IHRoYXQgd2UgYnJva2Ugc29tZQ0KVGhpbmtwYWRzIGFzIHdlbGwsIGJ1dCB3ZSBhbHNvIGhhdmUg
cmVwb3J0cyB0aGF0IFRoaW5rcGFkcyBjYW4gYmUNCmJyaWNrZWQgaWYgd2UgdXNlIHRvbyBtdWNo
IHNwYWNlLg0KDQotLSANCk1hdHRoZXcgR2FycmV0dCB8IG1qZzU5QHNyY2YudWNhbS5vcmcNCg==
