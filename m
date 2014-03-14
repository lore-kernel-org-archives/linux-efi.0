From: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Subject: Re: Trusted kernel patchset for Secure Boot lockdown
Date: Fri, 14 Mar 2014 19:24:55 +0000
Message-ID: <1394825094.1286.1.camel@x230>
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
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1394820664.26846.18.camel-OCPKQ0O/skbnpfJQjCtNlyaZ0x2G8ZQoAL8bYrjMMd8@public.gmane.org>
Content-Language: en-US
Content-ID: <2290C0ED0C7929498E01598672FDE139-HX+pjaQZbrqcE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org" <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org" <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>, "keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org" <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org" <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org" <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

T24gRnJpLCAyMDE0LTAzLTE0IGF0IDE0OjExIC0wNDAwLCBNYXR0aGV3IEdhcnJldHQgd3JvdGU6
DQoNCj4gVGhlIGZhY3QgdGhhdCB5b3Uga2VlcCBzYXlpbmcgbWVhc3VyZWQgcmVhbGx5IGRvZXMg
bWFrZSBtZSBzdXNwZWN0IHRoYXQNCj4geW91IG1pc3VuZGVyc3RhbmQgdGhlIHByb2JsZW0uIFRo
ZXJlJ3Mgbm8gbWVhc3VyZW1lbnQgaW52b2x2ZWQsIHRoZXJlJ3MNCj4gc2ltcGx5IGFuIGFzc2Vy
dGlvbiB0aGF0IHRoZSBmaXJtd2FyZSAod2hpY2ggeW91J3JlIGZvcmNlZCB0byB0cnVzdCkNCj4g
Y2hvc2UsIHZpYSBzb21lIHBvbGljeSB5b3UgbWF5IGJlIHVuYXdhcmUgb2YsIHRvIHRydXN0IHRo
ZSBib290ZWQNCj4ga2VybmVsLg0KDQpBcyBhbiBleGFtcGxlLCBpbWFnaW5lIGEgcGxhdGZvcm0g
d2l0aCB0aGUgYm9vdGxvYWRlciBhbmQga2VybmVsIG9uDQpyZWFkLW9ubHkgbWVkaWEuIFRoZSBw
bGF0Zm9ybSBjYW4gYXNzZXJ0IHRoYXQgdGhlIGtlcm5lbCBpcyB0cnVzdGVkIGV2ZW4NCmlmIHRo
ZXJlJ3Mgbm8gbWVhc3VyZW1lbnQgb2YgdGhlIGtlcm5lbC4NCg0KLS0gDQpNYXR0aGV3IEdhcnJl
dHQgPG1hdHRoZXcuZ2FycmV0dEBuZWJ1bGEuY29tPg0K
