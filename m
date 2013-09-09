From: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 01/12] Add BSD-style securelevel support
Date: Mon, 9 Sep 2013 16:55:18 +0000
Message-ID: <1378745717.17982.6.camel@x230.lan>
References: <1378741786-18430-1-git-send-email-matthew.garrett@nebula.com>
	 <1378741786-18430-2-git-send-email-matthew.garrett@nebula.com>
	 <522DF6DC.1050303@zytor.com> <1378744207.17982.3.camel@x230.lan>
	 <522DFA93.50308@zytor.com> <1378745082.17982.4.camel@x230.lan>
	 <522DFCAC.40607@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <522DFCAC.40607-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Content-ID: <732A9583FBC1474EAC05180D77E76AB9-HX+pjaQZbrqcE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org" <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org" <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org" <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>, "linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

T24gTW9uLCAyMDEzLTA5LTA5IGF0IDA5OjUxIC0wNzAwLCBILiBQZXRlciBBbnZpbiB3cm90ZToN
Cj4gT24gMDkvMDkvMjAxMyAwOTo0NCBBTSwgTWF0dGhldyBHYXJyZXR0IHdyb3RlOg0KPiA+IE9u
IE1vbiwgMjAxMy0wOS0wOSBhdCAwOTo0MiAtMDcwMCwgSC4gUGV0ZXIgQW52aW4gd3JvdGU6DQo+
ID4gDQo+ID4+IE5laXRoZXIgb2YgdGhpcyB0ZW5kIHRvIGJlIHRydWUgbG9uZyB0aW1lLi4uIHdo
aWNoIGxlYWRzIG9uZSBiYWNrIHRvDQo+ID4+IGNhcGFiaWxpdGllcy4NCj4gPiANCj4gPiBXZSBj
YW4ndCB1c2UgY2FwYWJpbGl0aWVzLiBEb2luZyBzbyBicmVha3MgZXhpc3RpbmcgdXNlcnNwYWNl
Lg0KPiA+IA0KPiANCj4gQ2FwYWJpbGl0aWVzIGRvbid0IGhhdmUgdG8gbWVhbiAiUE9TSVggY2Fw
YWJpbGl0aWVzIi4uLiBhbHRob3VnaCB0aGUNCj4gUE9TSVggY2FwYWJpbGl0eSBzeXN0ZW0gaW4g
TGludXggcmVhbGx5IGlzIGEgbWFzc2l2ZSBmYWlsIHdoaWNoIGl0IHdvdWxkDQo+IGJlIG5pY2Ug
dG8gZmluZCBzb21lIGtpbmQgb2YgZml4IGZvci4NCg0KRGVzaWduaW5nIGEgd29ydGh3aGlsZSBj
YXBhYmlsaXRpZXMgaW50ZXJmYWNlIGNlcnRhaW5seSBzZWVtcyBsaWtlIGENCmdyZWF0IHRoaW5n
IGZvciBzb21lb25lIHRvIHNwZW5kIGEgZmV3IHllYXJzIG9uLCBidXQgSSdtIG5vdCBnb2luZyB0
byBiZQ0KaGFwcHkgaWYgaXQncyB0aGUgb25seSB3YXkgdG8gc29sdmUgdGhpcyBwcm9ibGVtLg0K
DQotLSANCk1hdHRoZXcgR2FycmV0dCA8bWF0dGhldy5nYXJyZXR0QG5lYnVsYS5jb20+DQo=
