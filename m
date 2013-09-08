From: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V3 08/11] kexec: Disable at runtime if the kernel
 enforces module loading restrictions
Date: Sun, 8 Sep 2013 17:27:32 +0000
Message-ID: <1378661252.2300.26.camel@x230>
References: <1378252218-18798-1-git-send-email-matthew.garrett@nebula.com>
	 <1378252218-18798-9-git-send-email-matthew.garrett@nebula.com>
	 <20130908064027.GA3587@kroah.com> <1378622648.2300.4.camel@x230>
	 <20130908072408.GA5092@kroah.com>
	 <CAGXu5jLwCt6RtQC+kxcUC69tMydx8DO2QWDv3jK6_mOyT_iNbA@mail.gmail.com>
	 <1378660284.2429.11.camel@dabdike.int.hansenpartnership.com>
	 <1378660541.2300.19.camel@x230>
	 <1378660975.2429.14.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1378660975.2429.14.camel-sFMDBYUN5F8GjUHQrlYNx2Wm91YjaHnnhRte9Li2A+AAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Content-ID: <2085C08576D76846B95261618AF3E0BC-HX+pjaQZbrqcE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

DQo+IEl0J3MgYW4gYXJndW1lbnQgdGhhdCBDQVBfU1lTX0JPT1QgaXMgdG9vIHBvd2VyZnVsIHll
cywgYnV0IGlmIHlvdQ0KPiByZWNhbGwsIEkgc2FpZCBJIGtlZXAgdGhhdCBvbmUuICBJbiB0aGUg
cmF0aGVyIGxhbWUgYW5hbG9neSwgd2hhdCBJIGRvDQo+IGJ5IGdpdmluZyBhd2F5IENBUF9TWVNf
TU9EVUxFIGFuZCBlbmZvcmNpbmcgbW9kdWxlIHNpZ25pbmcgd2hpbGUga2VlcGluZw0KPiBDQVBf
U1lTX0JPT1QgaXMgYWxsb3cgcGVvcGxlIGludG8gbXkgY29uc2VydmF0b3J5IHRvIHBsYXkgd2l0
aCB0aGUNCj4gcGxhbnRzIGJ1dCBub3QgaW50byBteSBob3VzZSB0byBzdGVhbCB0aGUgc2lsdmVy
IC4uLiBzYXlpbmcgQ0FQX1NZU19CT09UDQo+IGlzIHRvbyBwb3dlcmZ1bCBkb2Vzbid0IGFmZmVj
dCB0aGF0IHVzZSBjYXNlIGJlY2F1c2UgSSBoYXZlbid0IGdpdmVuDQo+IGF3YXkgQ0FQX1NZU19C
T09ULg0KDQpPaywgc29ycnksIEkgaGFkIHlvdXIgbWVhbmluZyBpbnZlcnRlZC4gWWVzLCBwZXJt
aXR0aW5nIHRoZSBsb2FkaW5nIG9mDQpzaWduZWQgbW9kdWxlcyB3aGlsZSBwcmV2ZW50aW5nIHRo
ZSB1c2Ugb2Yga2V4ZWMgaXMgYSBjb21wbGV0ZWx5DQpyZWFzb25hYmxlIGNvbmZpZ3VyYXRpb24g
LSBzbyByZWFzb25hYmxlIHRoYXQgaXQncyB3aGF0IHRoaXMgcGF0Y2gNCmNhdXNlcyB0aGUga2Vy
bmVsIHRvIGRvIGF1dG9tYXRpY2FsbHkuIA0KDQotLSANCk1hdHRoZXcgR2FycmV0dCA8bWF0dGhl
dy5nYXJyZXR0QG5lYnVsYS5jb20+DQo=
