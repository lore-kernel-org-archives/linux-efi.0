From: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] x86: Lock down MSR writing in secure boot
Date: Fri, 8 Feb 2013 21:07:21 +0000
Message-ID: <1360357636.18083.19.camel@x230.lan>
References: <20130208191213.GA25081@www.outflux.net>
	 <00780235-deac-4f80-b936-867834e05661@email.android.com>
	 <CAGXu5jJnLY6Qp3J6HBpVg-AdUGdKYm-e4wErZO3=NuRo04ajvg@mail.gmail.com>
	 <5115553A.5000708@zytor.com>
	 <CAGXu5j+_mGzR+72YqORhErMUY1aF1H2urczZ8SwuJHZK-oZL6g@mail.gmail.com>
	 <dee64752-850c-4d78-b703-f47a985bc13e@email.android.com>
	 <CAGXu5jLAufTRm=sDST0br_WEkn4o0Hpjv2jDP2Na=cCvuM+MGg@mail.gmail.com>
	 <1360355671.18083.18.camel@x230.lan>
	 <CAGXu5jKo2PfMBO4A0ZgQcrPuj8OHNaff+CjAesOAWkZc0vB9+Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAGXu5jKo2PfMBO4A0ZgQcrPuj8OHNaff+CjAesOAWkZc0vB9+Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Content-ID: <03989305AE685A42AB6353079D5CF946-HX+pjaQZbrqcE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-security-module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

T24gRnJpLCAyMDEzLTAyLTA4IGF0IDEzOjAyIC0wODAwLCBLZWVzIENvb2sgd3JvdGU6DQoNCj4g
SSBkb24ndCBmaW5kIGl0IHVucmVhc29uYWJsZSB0byBkcm9wIGFsbCBjYXBzIGFuZCBsb3NlIGFj
Y2VzcyB0bw0KPiBzZW5zaXRpdmUgdGhpbmdzLiA6KSBUaGF0J3Mgc29ydCBvZiB0aGUgcG9pbnQs
IHJlYWxseS4gSSB0aGluayBhIGNhcA0KPiBpcyB0aGUgYmVzdCBtYXRjaC4gSXQgc2VlbXMgbGlr
ZSBpdCBzaG91bGQgZWl0aGVyIGJlIGEgY2FwIG9yIGENCj4gbmFtZXNwYWNlIGZsYWcsIGJ1dCB0
aGUgbGF0dGVyIHNlZW1zIG1lc3N5Lg0KDQpZZWFoLCBJIHRoaW5rIGl0J3MgYW4gZXhwZWN0ZWQg
b3V0Y29tZSwgYnV0IGl0IG1lYW5zIHRoYXQgaWYgKHNheSkgcWVtdQ0KZHJvcHMgcHJpdmlsZWdl
cywgcWVtdSBjYW4gbm8gbG9uZ2VyIGFjY2VzcyBQQ0kgcmVzb3VyY2VzIC0gZXZlbiBvbg0Kbm9u
LXNlY3VyZSBib290IHN5c3RlbXMuIFRoYXQgYnJlYWtzIGV4aXN0aW5nIHVzZXJzcGFjZS4NCg==
