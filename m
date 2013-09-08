From: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V3 08/11] kexec: Disable at runtime if the kernel
 enforces module loading restrictions
Date: Sun, 8 Sep 2013 17:38:13 +0000
Message-ID: <1378661893.2300.28.camel@x230>
References: <1378252218-18798-1-git-send-email-matthew.garrett@nebula.com>
	 <1378252218-18798-9-git-send-email-matthew.garrett@nebula.com>
	 <20130908064027.GA3587@kroah.com> <1378622648.2300.4.camel@x230>
	 <20130908072408.GA5092@kroah.com>
	 <CAGXu5jLwCt6RtQC+kxcUC69tMydx8DO2QWDv3jK6_mOyT_iNbA@mail.gmail.com>
	 <1378660284.2429.11.camel@dabdike.int.hansenpartnership.com>
	 <1378660541.2300.19.camel@x230>
	 <1378660975.2429.14.camel@dabdike.int.hansenpartnership.com>
	 <1378661252.2300.26.camel@x230>
	 <1378661576.2429.16.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1378661576.2429.16.camel-sFMDBYUN5F8GjUHQrlYNx2Wm91YjaHnnhRte9Li2A+AAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Content-ID: <3CA20E5EE26CAF42914DA6338E9FE0F0-HX+pjaQZbrqcE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

T24gU3VuLCAyMDEzLTA5LTA4IGF0IDEwOjMyIC0wNzAwLCBKYW1lcyBCb3R0b21sZXkgd3JvdGU6
DQo+IE9uIFN1biwgMjAxMy0wOS0wOCBhdCAxNzoyNyArMDAwMCwgTWF0dGhldyBHYXJyZXR0IHdy
b3RlOg0KPiA+ID4gSXQncyBhbiBhcmd1bWVudCB0aGF0IENBUF9TWVNfQk9PVCBpcyB0b28gcG93
ZXJmdWwgeWVzLCBidXQgaWYgeW91DQo+ID4gPiByZWNhbGwsIEkgc2FpZCBJIGtlZXAgdGhhdCBv
bmUuICBJbiB0aGUgcmF0aGVyIGxhbWUgYW5hbG9neSwgd2hhdCBJIGRvDQo+ID4gPiBieSBnaXZp
bmcgYXdheSBDQVBfU1lTX01PRFVMRSBhbmQgZW5mb3JjaW5nIG1vZHVsZSBzaWduaW5nIHdoaWxl
IGtlZXBpbmcNCj4gPiA+IENBUF9TWVNfQk9PVCBpcyBhbGxvdyBwZW9wbGUgaW50byBteSBjb25z
ZXJ2YXRvcnkgdG8gcGxheSB3aXRoIHRoZQ0KPiA+ID4gcGxhbnRzIGJ1dCBub3QgaW50byBteSBo
b3VzZSB0byBzdGVhbCB0aGUgc2lsdmVyIC4uLiBzYXlpbmcgQ0FQX1NZU19CT09UDQo+ID4gPiBp
cyB0b28gcG93ZXJmdWwgZG9lc24ndCBhZmZlY3QgdGhhdCB1c2UgY2FzZSBiZWNhdXNlIEkgaGF2
ZW4ndCBnaXZlbg0KPiA+ID4gYXdheSBDQVBfU1lTX0JPT1QuDQo+ID4gDQo+ID4gT2ssIHNvcnJ5
LCBJIGhhZCB5b3VyIG1lYW5pbmcgaW52ZXJ0ZWQuIFllcywgcGVybWl0dGluZyB0aGUgbG9hZGlu
ZyBvZg0KPiA+IHNpZ25lZCBtb2R1bGVzIHdoaWxlIHByZXZlbnRpbmcgdGhlIHVzZSBvZiBrZXhl
YyBpcyBhIGNvbXBsZXRlbHkNCj4gPiByZWFzb25hYmxlIGNvbmZpZ3VyYXRpb24gLSBzbyByZWFz
b25hYmxlIHRoYXQgaXQncyB3aGF0IHRoaXMgcGF0Y2gNCj4gPiBjYXVzZXMgdGhlIGtlcm5lbCB0
byBkbyBhdXRvbWF0aWNhbGx5LiANCj4gDQo+IFdlbGwsIG5vLCBpdCBkb2Vzbid0IGJlY2F1c2Ug
d2l0aCB0aGlzIHBhdGNoLCAqSSogY2FuJ3QgdXNlIGtleGVjIC4uLg0KPiB5b3UndmUganVzdCBs
b2NrZWQgbWUgb3V0IG9mIG15IG93biBob3VzZS4NCg0KSG0uIE9rLCB0aGF0J3MgYSBtb3JlIGNv
bXBlbGxpbmcgYXJndW1lbnQgdGhhbiBHcmVnJ3MuIExldCBtZSB0aGluaw0KYWJvdXQgd2hldGhl
ciB0aGVyZSdzIGEgY29udmVuaWVudCB3YXkgb2Ygc3VwcG9ydGluZyB0aGlzLg0KDQotLSANCk1h
dHRoZXcgR2FycmV0dCA8bWF0dGhldy5nYXJyZXR0QG5lYnVsYS5jb20+DQo=
