From: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Subject: Re: Trusted kernel patchset for Secure Boot lockdown
Date: Fri, 14 Mar 2014 22:04:39 +0000
Message-ID: <1394834679.1286.16.camel@x230>
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
	 <1394825094.1286.1.camel@x230>
	 <20140314215854.50ec186a@alan.etchedpixels.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140314215854.50ec186a-mUKnrFFms3BCCTY1wZZT65JpZx93mCW/@public.gmane.org>
Content-Language: en-US
Content-ID: <4B9940B633CC2049901F7815B7789244-HX+pjaQZbrqcE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org" <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org" <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>, "keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org" <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org" <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org" <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

T24gRnJpLCAyMDE0LTAzLTE0IGF0IDIxOjU4ICswMDAwLCBPbmUgVGhvdXNhbmQgR25vbWVzIHdy
b3RlOg0KPiBPbiBGcmksIDE0IE1hciAyMDE0IDE5OjI0OjU1ICswMDAwDQo+IE1hdHRoZXcgR2Fy
cmV0dCA8bWF0dGhldy5nYXJyZXR0QG5lYnVsYS5jb20+IHdyb3RlOg0KPiA+IEFzIGFuIGV4YW1w
bGUsIGltYWdpbmUgYSBwbGF0Zm9ybSB3aXRoIHRoZSBib290bG9hZGVyIGFuZCBrZXJuZWwgb24N
Cj4gPiByZWFkLW9ubHkgbWVkaWEuIFRoZSBwbGF0Zm9ybSBjYW4gYXNzZXJ0IHRoYXQgdGhlIGtl
cm5lbCBpcyB0cnVzdGVkIGV2ZW4NCj4gPiBpZiB0aGVyZSdzIG5vIG1lYXN1cmVtZW50IG9mIHRo
ZSBrZXJuZWwuDQo+IA0KPiBPbmx5IGlmIHlvdSBoYXZlIGEgc2VjdXJlIHNpZ25lZCBwYXRoIHRo
cm91Z2ggdGhlIGNvbnRyb2xsZXIgZmlybXdhcmUgYW5kDQo+IHBoeXNpY2FsIHNlY3VyaXR5IG9m
IHRoZSBoYXJkd2FyZS4gSWYgbm90IEkgY2FuIHJlcHJvZ3JhbSB5b3VyIEJJT1MsIHlvdXINCj4g
R1BVIGZpcm13YXJlLCB5b3VyIFVTQiBzdGljayBvciB5b3VyIENELVJPTSBjb250cm9sbGVyIHRv
IGxpZS4NCg0KU3VyZSwgYW5kIHRoZW4gdGhlIHRydXN0IHRoYXQgdGhlIGZpcm13YXJlIHBsYWNl
ZCBpbiB0aGUga2VybmVsIHdvdWxkIGJlDQptaXNwbGFjZWQuIFlvdSBjYW4gc3VidmVydCBTZWN1
cmUgQm9vdCB3aXRoIGFuIFNQSSBmbGFzaGVyLCBqdXN0IGFzIHlvdQ0KY2FuIHN1YnZlcnQgc2Vs
aW51eCB3aXRoIGEgZmlyZXdpcmUgZG9uZ2xlLiBUaG9zZSBhdHRhY2tzIGFyZSBvdXRzaWRlDQp0
aGUgdGhyZWF0IG1vZGVsLiBJZiB5b3UncmUgaW4gYSBzaXR1YXRpb24gd2hlcmUgeW91IGhhdmUg
dG8gY2FyZSBhYm91dA0KdGhyZWF0cyBvdXRzaWRlIHRoYXQgdGhyZWF0IG1vZGVsIHRoZW4geW91
IG5lZWQgdG8gY2hvb3NlIGEgbW9yZQ0KYXBwcm9wcmlhdGUgc29sdXRpb24uDQotLSANCk1hdHRo
ZXcgR2FycmV0dCA8bWF0dGhldy5nYXJyZXR0QG5lYnVsYS5jb20+DQo=
