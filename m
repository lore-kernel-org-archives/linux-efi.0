From: Matthew Garrett <matthew.garrett@nebula.com>
Subject: Re: Trusted kernel patchset for Secure Boot lockdown
Date: Fri, 14 Mar 2014 21:56:33 +0000
Message-ID: <1394834193.1286.11.camel@x230>
References: <1393445473-15068-1-git-send-email-matthew.garrett@nebula.com>
	 <CA+5PVA4RSh3hzJxEjpzHPj8w3uPoEzfg7ySWjB=6RUhAKJTudQ@mail.gmail.com>
	 <alpine.LRH.2.02.1402281402090.26521@tundra.namei.org>
	 <1394686919.25122.2.camel@x230>
	 <CAGXu5jJ_8w7PscwTQG5iVRJ4k4nzvN8oqzAPgV+NExAr9v17EQ@mail.gmail.com>
	 <alpine.LRH.2.02.1403132031460.11638@tundra.namei.org>
	 <1394726363.25122.16.camel@x230>
	 <20140313212450.67f1de8e@alan.etchedpixels.co.uk>
	 <1394746248.27846.3.camel@x230>
	 <20140313232140.03bdaac3@alan.etchedpixels.co.uk>
	 <1394762250.6416.24.camel@x230.lan>
	 <20140314122231.17b9ca8a@alan.etchedpixels.co.uk>
	 <1394801518.6416.38.camel@x230.lan>
	 <20140314170655.0ce398a3@alan.etchedpixels.co.uk>
	 <1394820664.26846.18.camel@x230.mview.int.nebula.com>
	 <20140314214806.54a3d031@alan.etchedpixels.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20140314214806.54a3d031@alan.etchedpixels.co.uk>
Content-Language: en-US
Content-ID: <87855910494A46449FF99E5F0F8AE21E@namprd05.prod.outlook.com>
Sender: linux-security-module-owner@vger.kernel.org
To: "gnomes@lxorguk.ukuu.org.uk" <gnomes@lxorguk.ukuu.org.uk>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "jmorris@namei.org" <jmorris@namei.org>, "keescook@chromium.org" <keescook@chromium.org>, "linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "hpa@zytor.com" <hpa@zytor.com>, "jwboyer@fedoraproject.org" <jwboyer@fedoraproject.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
List-Id: linux-efi@vger.kernel.org

T24gRnJpLCAyMDE0LTAzLTE0IGF0IDIxOjQ4ICswMDAwLCBPbmUgVGhvdXNhbmQgR25vbWVzIHdy
b3RlOg0KDQo+IEluIHlvdXIgcGFydGljdWxhcmx5IGltcGxlbWVudGF0aW9uIG1heWJlIHlvdSd2
ZSBnb3QgYSB3ZWFrIHNldHVwIHdoZXJlDQo+IHlvdSBkb24ndCBtZWFzdXJlIGRvd24gdG8geW91
ciBpbml0cmQuIFRoYXQncyBhICpmbGF3KiBpbiB5b3VyDQo+IGltcGxlbWVudGF0aW9uLiBEb24n
dCBpbmZsaWN0IHlvdXIgbGltaXRhdGlvbnMgb24gb3RoZXJzIG9yIG9uIHRoZQ0KPiBmdXR1cmUu
IEVGSSBpcyBvbmx5IG9uZSAoYW5kIG5vdCBhIHZlcnkgc3Ryb25nIG9uZSBhdCB0aGF0KSBpbXBs
ZW1lbnRhdGlvbg0KPiBvZiBhICdzZWN1cmUnIGJvb3QgY2hhaW4uIEEgbG90IG9mIG90aGVyIHN5
c3RlbXMgY2FuIG5vdCBvbmx5IHByb3BvZ2F0ZQ0KPiBtZWFzdXJlbWVudCBhbmQgc2VjdXJpdHkg
YXNzZXJ0aW9ucyBpbnRvIHRoZWlyIGluaXRyZCB0aGV5IGNhbiBwcm9wb2dhdGUNCj4gdGhlbSBp
bnRvIHRoZWlyIHJvb3RmcyAoeWVzIHVwZ3JhZGVzIGFyZSAuLiBleGNpdGluZywgYnV0IHRoZXNl
IGtpbmRzIG9mDQo+IHVzZXJzIHdpbGwgbGl2ZSB3aXRoIHRoYXQgcGFpbikuDQoNClNpZ25lZCB1
c2Vyc3BhY2UgaXMgbm90IGEgcmVxdWlyZW1lbnQsIGFuZCB0aGVyZWZvcmUgYW55IHNvbHV0aW9u
IHRoYXQNCnJlbGllcyBvbiBhIHNpZ25lZCBpbml0cmQgaXMgaW5hZGVxdWF0ZS4gVGhlcmUgYXJl
IHVzZSBjYXNlcyB0aGF0DQpyZXF1aXJlIHZlcmlmaWNhdGlvbiBvZiB0aGUgaW5pdHJkIGFuZCBv
dGhlciBsZXZlbHMuIFRoaXMgaXNuJ3Qgb25lIG9mDQp0aGVtLg0KDQo+IEV2ZW4gaW4gRUZJIHlv
dSBjYW4gbWFrZSB5b3VyIGtlcm5lbCBvciBsb2FkZXIgY2hlY2sgdGhlIGluaXRyZCBzaWduYXR1
cmUNCj4gYW5kIHRoZSByb290ZnMgc2lnbmF0dXJlIGlmIHlvdSB3YW50Lg0KDQpFeGNlcHQgdGhl
IGluaXRyYW1mcyBnZXRzIGJ1aWx0IGF0IGtlcm5lbCBpbnN0YWxsIHRpbWUuDQogDQo+ID4gVGhl
IGZhY3QgdGhhdCB5b3Uga2VlcCBzYXlpbmcgbWVhc3VyZWQgcmVhbGx5IGRvZXMgbWFrZSBtZSBz
dXNwZWN0IHRoYXQNCj4gPiB5b3UgbWlzdW5kZXJzdGFuZCB0aGUgcHJvYmxlbS4gVGhlcmUncyBu
byBtZWFzdXJlbWVudCBpbnZvbHZlZCwgdGhlcmUncw0KPiA+IHNpbXBseSBhbiBhc3NlcnRpb24g
dGhhdCB0aGUgZmlybXdhcmUgKHdoaWNoIHlvdSdyZSBmb3JjZWQgdG8gdHJ1c3QpDQo+ID4gY2hv
c2UsIHZpYSBzb21lIHBvbGljeSB5b3UgbWF5IGJlIHVuYXdhcmUgb2YsIHRvIHRydXN0IHRoZSBi
b290ZWQNCj4gPiBrZXJuZWwuDQo+IA0KPiBZb3UgYXJlIGN1cnJlbnRseSB1c2luZyBzb21lIG9m
IHRob3NlIGludGVyZmFjZXMgZm9yIG1lYXN1cmluZyB0byBwcm9kdWNlDQo+IGEgbm90aW9uYWxs
eSAndHJ1c3RlZCcgaW5pdGlhbCBsb2FkZWQgZW52aXJvbm1lbnQuDQo+IA0KPiBDb3JyZWN0IG1l
IGlmIEkgYW0gd3JvbmcgYnV0IHlvdXIgc3RhcnRpbmcgcG9pbnQgaXMgIkkgaGF2ZSBhIGNoYWlu
IG9mDQo+IG1lYXN1cmVtZW50IGFzIGZhciBhcyB0aGUga2VybmVsIEkgbG9hZCIuIFdpdGhvdXQg
dGhhdCBJIGNhbiBqdXN0IGdvIGludG8NCj4gZ3J1YiBhbmQgMHduIHlvdS4NCg0KSW4gbXkgdXNl
IGNhc2UuIEJ1dCBub3QgYWxsIGltcGxlbWVudGF0aW9ucyB3aWxsIGJlIG1lYXN1cmluZyB0aGlu
Z3MgLQ0KdGhleSBjYW4gYXNzZXJ0IHRoYXQgdGhlIGtlcm5lbCBpcyB0cnVzdHdvcnRoeSB0aHJv
dWdoIHNvbWUgb3RoZXINCm1lY2hhbmlzbS4gVGhpcyBnZW51aW5lbHkgaXMgYWJvdXQgdHJ1c3Qs
IG5vdCBtZWFzdXJlbWVudC4NCg0KLS0gDQpNYXR0aGV3IEdhcnJldHQgPG1hdHRoZXcuZ2FycmV0
dEBuZWJ1bGEuY29tPg0K
