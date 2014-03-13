From: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Subject: Re: Trusted kernel patchset for Secure Boot lockdown
Date: Thu, 13 Mar 2014 21:31:55 +0000
Message-ID: <1394746314.27846.4.camel@x230>
References: <1393445473-15068-1-git-send-email-matthew.garrett@nebula.com>
	 <CA+5PVA4RSh3hzJxEjpzHPj8w3uPoEzfg7ySWjB=6RUhAKJTudQ@mail.gmail.com>
	 <alpine.LRH.2.02.1402281402090.26521@tundra.namei.org>
	 <1394686919.25122.2.camel@x230>
	 <CAGXu5jJ_8w7PscwTQG5iVRJ4k4nzvN8oqzAPgV+NExAr9v17EQ@mail.gmail.com>
	 <alpine.LRH.2.02.1403132031460.11638@tundra.namei.org>
	 <1394726363.25122.16.camel@x230>
	 <20140313212647.7412aadf@alan.etchedpixels.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140313212647.7412aadf-mUKnrFFms3BCCTY1wZZT65JpZx93mCW/@public.gmane.org>
Content-Language: en-US
Content-ID: <A008819D12EFFC40A5D6F44E7611F4DD-HX+pjaQZbrqcE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org" <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org" <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>, "keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org" <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org" <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org" <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

T24gVGh1LCAyMDE0LTAzLTEzIGF0IDIxOjI2ICswMDAwLCBPbmUgVGhvdXNhbmQgR25vbWVzIHdy
b3RlOg0KPiA+IE9uIHRoZSBvdGhlciBoYW5kLCBkaXNhYmxpbmcgQ0FQX1NZU19SQVdJTyAqZGVm
aW5pdGVseSogYnJlYWtzIGV4cGVjdGVkDQo+ID4gZnVuY3Rpb25hbGl0eSAtIGZpcm13YXJlIGxv
YWRpbmcgYW5kIHRoZSBmaWJtYXAgaW9jdGwgYXJlIHByb2JhYmx5IHRoZQ0KPiA+IG1vc3Qgb2J2
aW91cy4gQW5kIGNoYW5naW5nIHRoZSB1c2Ugb2YgQ0FQX1NZU19SQVdJTyBwb3RlbnRpYWxseSBi
cmVha3MNCj4gPiB1c2Vyc3BhY2UgZXhwZWN0YXRpb25zLCBzbyB3ZSdyZSBraW5kIG9mIHN0dWNr
IHRoZXJlLg0KPiANCj4gQWN0dWFsbHkgSSBrbm93IGhvdyB0byBkZXNjcmliZSB0aGUgcHJvYmxl
bSBiZXR0ZXIuDQo+IA0KPiBXaGl0ZWxpc3QgdiBCbGFja2xpc3QuDQo+IA0KPiBHb2luZyBhcm91
bmQgYWRkaW5nIGV4dHJhIGNhc2VzIGZvciBDQVBfU1lTX1JBV0lPIGlzIGEgZmFpbHMgaW5zZWN1
cmUNCj4gbW9kZWwuIEdvaW5nIGFyb3VuZCBhZGRpbmcgQ0FQX1NZU19SQVdJTyB8fCBDQVBfU1lT
X1JBV0lPX1NFQyBpcyBhICdmYWlscw0KPiBzZWN1cmUnIGNhc2UuDQoNCldlJ3ZlIGFscmVhZHkg
YmVlbiB0aHJvdWdoIHRoaXMuIFdlIGNhbid0IGFkZCBuZXcgY2FwYWJpbGl0aWVzLiBJdA0KYnJl
YWtzIGV4aXN0aW5nIHVzZXJzcGFjZS4NCg0KLS0gDQpNYXR0aGV3IEdhcnJldHQgPG1hdHRoZXcu
Z2FycmV0dEBuZWJ1bGEuY29tPg0K
