From: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Subject: Re: Trusted kernel patchset for Secure Boot lockdown
Date: Fri, 14 Mar 2014 15:58:02 +0000
Message-ID: <1394812682.26846.5.camel@x230.mview.int.nebula.com>
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
	 <CAGXu5jLZcWh5WD0L8s3Q-GXdXCMnA57qtjfdFfQbv0fxYcuCTQ@mail.gmail.com>
	 <1394811997.26846.2.camel@x230.mview.int.nebula.com>
	 <CAGXu5j+3vVKhFPOsArYddA+QqhvVUunj8eYOF799rDv=3MGtyg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAGXu5j+3vVKhFPOsArYddA+QqhvVUunj8eYOF799rDv=3MGtyg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Content-ID: <810F24FF5F986543B694F546A00A701C-HX+pjaQZbrqcE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org" <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org" <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>, "linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org" <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>, "gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org" <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org" <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

T24gRnJpLCAyMDE0LTAzLTE0IGF0IDA4OjU0IC0wNzAwLCBLZWVzIENvb2sgd3JvdGU6DQoNCj4g
QWxsIHRoZSBtb3JlIHJlYXNvbiB0byBpZ25vcmUgY29tbWFuZCBsaW5lIGF0IHRoaXMgcG9pbnQu
IEZvciBDaHJvbWUNCj4gT1MsIGl0J3MgcGFydCBvZiBvdXIgYm9vdCBzdGF0ZSwgc28gd2UgZG9u
J3QgY2FyZSBhYm91dCBpdC4gRm9yDQo+IGdlbmVyaWMgU2VjdXJlIEJvb3QsIHdlIGNhbiBhZGQg
Y2hlY2tzIGZvciBkYW5nZXJvdXMgc3R1ZmYgYXMgd2UgZ28NCj4gZm9yd2FyZC4gVGhhdCdzIHdo
eSBJIGxpa2UgdGhpcyBpbnRlcmZhY2UgLS0gd2UgY2FuIGFkZCB0byBpdCBhcyB3ZQ0KPiBpZGVu
dGlmeSBiYWQgc3R1ZmYsIGFuZCBpdCBzdGF5IHNlcGFyYXRlIGZyb20gb3RoZXIgc2VtYW50aWNz
Lg0KDQpTdXJlLCBpdCdzIGp1c3QgYW5vdGhlciByZWFzb24gbm90IHRvIHdhbnQgdG8gdXNlIGEg
Y2FwYWJpbGl0eS1iYXNlZA0KaW50ZXJmYWNlIC0gbm90IGFsbCB0aGUgcG9saWN5IHdlIHdhbnQg
dG8gaW1wb3NlIGlzIHJlbGF0ZWQgdG8NCnByb2Nlc3Nlcywgc28gY2FwYWJpbGl0aWVzIHJlYWxs
eSBkb24ndCBtYWtlIHNlbnNlLiBUaGUgY3VycmVudCBwYXRjaHNldA0KYWRkcyBhIHJlc3RyaWN0
aW9uIHRvIHRoZSBhY3BpX3JzZHAgYXJndW1lbnQsIGFuZCBJJ3ZlIG5vIG9iamVjdGlvbiB0bw0K
YWRkaW5nIG9uZSB0byBsaW1pdCB0aGUgdXNlIG9mIG1lbT0uDQoNCi0tIA0KTWF0dGhldyBHYXJy
ZXR0IDxtYXR0aGV3LmdhcnJldHRAbmVidWxhLmNvbT4NCg==
