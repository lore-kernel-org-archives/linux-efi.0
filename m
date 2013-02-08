From: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] x86: Lock down MSR writing in secure boot
Date: Fri, 8 Feb 2013 20:34:31 +0000
Message-ID: <1360355671.18083.18.camel@x230.lan>
References: <20130208191213.GA25081@www.outflux.net>
	 <00780235-deac-4f80-b936-867834e05661@email.android.com>
	 <CAGXu5jJnLY6Qp3J6HBpVg-AdUGdKYm-e4wErZO3=NuRo04ajvg@mail.gmail.com>
	 <5115553A.5000708@zytor.com>
	 <CAGXu5j+_mGzR+72YqORhErMUY1aF1H2urczZ8SwuJHZK-oZL6g@mail.gmail.com>
	 <dee64752-850c-4d78-b703-f47a985bc13e@email.android.com>
	 <CAGXu5jLAufTRm=sDST0br_WEkn4o0Hpjv2jDP2Na=cCvuM+MGg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAGXu5jLAufTRm=sDST0br_WEkn4o0Hpjv2jDP2Na=cCvuM+MGg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Content-ID: <DA29DA631E563D46A770BFA754550B0D-HX+pjaQZbrqcE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-security-module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

T24gRnJpLCAyMDEzLTAyLTA4IGF0IDEyOjI4IC0wODAwLCBLZWVzIENvb2sgd3JvdGU6DQoNCj4g
TWF5YmUgYSBjYXBhYmlsaXR5IGlzbid0IHRoZSByaWdodCB3YXkgdG8gZ28sIEknbSBub3Qgc3Vy
ZS4gSSdsbCBsZWF2ZQ0KPiB0aGF0IHRvIE1hdHRoZXcuIFdoYXRldmVyIHRoZSBmbGFnLCBpdCBz
aG91bGQgYmUgYW4gaW1tdXRhYmxlIHN0YXRlIG9mDQo+IHRoZSBib290LiBUaG91Z2gsIGl0IHBy
b2JhYmx5IG1ha2VzIHNlbnNlIGFzIGEgY2FwIGp1c3Qgc28gdGhhdA0KPiBub24tc2VjdXJlLWJv
b3Qgc3lzdGVtcyBjYW4gc3RpbGwgcmVtb3ZlIGl0IGZyb20gY29udGFpbmVycywgZXRjLg0KDQpU
aGVyZSB3YXMgaW50ZXJlc3QgaW4gZW5zdXJpbmcgdGhhdCB0aGlzIHdhc24ndCBzb21ldGhpbmcg
c3BlY2lhbC1jYXNlZA0KdG8gVUVGSSBTZWN1cmUgQm9vdCwgc28gdXNpbmcgYSBjYXBhYmlsaXR5
IHNlZW1lZCBsaWtlIHRoZSBtb3N0DQpzdHJhaWdodGZvcndhcmQgd2F5IC0gaXQncyBmdW5kYW1l
bnRhbGx5IGEgcmVzdHJpY3Rpb24gb24gd2hhdCBhbg0Kb3RoZXJ3aXNlIHByaXZpbGVnZWQgdXNl
ciBpcyBhYmxlIHRvIGRvLCBzbyBpdCBzZWVtZWQgbGlrZSBpdCBmaXQgdGhlDQptb2RlbC4gQnV0
IEknbSBub3Qgd2VkIHRvIGl0IGluIHRoZSBzbGlnaHRlc3QsIGFuZCBpbiBmYWN0IGl0IGNhdXNl
cw0KcHJvYmxlbXMgZm9yIHNvbWUgdXNlcnNwYWNlIChhbnl0aGluZyB0aGF0IGRyb3BzIGFsbCBj
YXBhYmlsaXRpZXMNCnN1ZGRlbmx5IGZpbmRzIGl0c2VsZiB1bmFibGUgdG8gZG8gc29tZXRoaW5n
IHRoYXQgaXQgZXhwZWN0cyB0byBiZSBhYmxlDQp0byBkbyksIHNvIGlmIGFueW9uZSBoYXMgYW55
IHN1Z2dlc3Rpb25zIGZvciBhIGJldHRlciBhcHByb2FjaOKApg0K
