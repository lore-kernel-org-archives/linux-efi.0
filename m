From: "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v1 1/3] firmware loader: Introduce new API -
 request_firmware_abort()
Date: Wed, 29 Oct 2014 03:04:48 +0000
Message-ID: <F54AEECA5E2B9541821D670476DAE19C2B80DB80@PGSMSX102.gar.corp.intel.com>
References: <1414131502-13886-1-git-send-email-hock.leong.kweh@intel.com>
	<1414131502-13886-2-git-send-email-hock.leong.kweh@intel.com>
 <CACVXFVOu2MyeRyyQybdAUEmp02mGHP6-kmHZ8EBx4=uJiF51LQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CACVXFVOu2MyeRyyQybdAUEmp02mGHP6-kmHZ8EBx4=uJiF51LQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: "Fleming, Matt" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sam Protsenko <semen.protsenko-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Ong, Boon Leong" <boon.leong.ong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBNaW5nIExlaSBbbWFpbHRvOm1p
bmcubGVpQGNhbm9uaWNhbC5jb21dDQo+IFNlbnQ6IE1vbmRheSwgT2N0b2JlciAyNywgMjAxNCAx
MjowMCBBTQ0KPiANCj4gWW91IGNhbiBjYWxsIGZ3X2xvb2t1cF9idWYoKSBkaXJlY3RseSwgb3Ro
ZXJ3aXNlIGZlZWwgZnJlZSB0byBhZGQ6DQo+IA0KPiBBY2tlZC1ieTogTWluZyBMZWkgPG1pbmcu
bGVpQGNhbm9uaWNhbC5jb20+DQo+IA0KDQpIaSBNaW5nIExlaSwNCg0KVGhlIGZ3X2xvb2t1cF9i
dWYoKSBpcyBkZWZpbmVkIGluc2lkZSB0aGUgY29uZGl0aW9uYWwgcHJlcHJvY2Vzc29yIGRpcmVj
dGl2ZSBmb3IgQ09ORklHX1BNX1NMRUVQLg0KU2luY2UgdGhlIHJlcXVlc3RfZmlybXdhcmVfYWJv
cnQoKSBtYXkgbm90IG9ubHkgYmUgdXNlZCBpbiBQTV9TTEVFUCwgY291bGQgSSBtb3ZlIHRoZSBm
d19sb29rdXBfYnVmKCkNCm91dCBmcm9tIHRoZSBDT05GSUdfUE1fU0xFRVAgYmxvY2sgaWYgd2Ug
d2FudCB0byBjYWxsIGZ3X2xvb2t1cF9idWYoKSBpbnN0ZWFkIG9mIF9fZndfbG9va3VwX2J1Zigp
Pw0KDQpUaGFua3MuDQoNCg0KUmVnYXJkcywNCldpbHNvbg0K
