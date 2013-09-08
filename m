From: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V3 08/11] kexec: Disable at runtime if the kernel
 enforces module loading restrictions
Date: Sun, 8 Sep 2013 16:24:47 +0000
Message-ID: <1378657487.2300.10.camel@x230>
References: <1378252218-18798-1-git-send-email-matthew.garrett@nebula.com>
	 <1378252218-18798-9-git-send-email-matthew.garrett@nebula.com>
	 <20130908064027.GA3587@kroah.com> <1378622648.2300.4.camel@x230>
	 <20130908072408.GA5092@kroah.com>
	 <CAGXu5jLwCt6RtQC+kxcUC69tMydx8DO2QWDv3jK6_mOyT_iNbA@mail.gmail.com>
	 <20130908161859.GA18946@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130908161859.GA18946-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Content-ID: <D150D3EC24417E46BFA92298CEB99488-HX+pjaQZbrqcE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

T24gU3VuLCAyMDEzLTA5LTA4IGF0IDA5OjE4IC0wNzAwLCBHcmVnIEtIIHdyb3RlOg0KDQo+IEkg
d2FudCBib3RoLCBidXQgSSBkb24ndCBuZWVkIHNpZ25lZCBrZXhlYyBzdXBwb3J0IGJlY2F1c2Ug
SSB3YW50IHRvIHVzZQ0KPiBrZXhlYyBmb3IgYSBwcm9ncmFtIHRoYXQgSSAia25vdyIgaXMgY29y
cmVjdCBiZWNhdXNlIEkgdmFsaWRhdGVkIHRoZQ0KPiBkaXNrIGltYWdlIGl0IHdhcyBvbiBiZWZv
cmUgSSBtb3VudGVkIGl0LiAgV2UgYWxyZWFkeSBoYXZlIG90aGVyIHdheXMgdG8NCj4gInZlcmlm
eSIgdGhpbmdzIHdpdGhvdXQgaGF2aW5nIHRvIGFkZCBpbmRpdmlkdWFsIHZlcmlmaWNhdGlvbiBv
Zg0KPiBzcGVjaWZpYyBwaWVjZXMuDQoNClRoZSBrZXJuZWwgaGFzIG5vIHdheSB0byBrbm93IHRo
YXQgeW91ciBrZXhlYyBwYXlsb2FkIGlzIGNvbWluZyBmcm9tIGENCnZlcmlmaWVkIGltYWdlLiBJ
dCdsbCBqdXN0IGFzIGhhcHBpbHkgdGFrZSBzb21ldGhpbmcgZnJvbSBhbiB1bnZlcmlmaWVkDQpp
bWFnZS4gSWYgeW91J3ZlIGVuc3VyZWQgdGhhdCB0aGVyZSdzIG5vIHdheSBhbiBhdHRhY2tlciBj
YW4gY2FsbA0Ka2V4ZWNfbG9hZCgpIG9uIGFuIHVudmVyaWZpZWQgaW1hZ2UsIHRoZW4geW91IGRv
bid0IG5lZWQgc2lnbmVkIG1vZHVsZXMuDQoNCi0tIA0KTWF0dGhldyBHYXJyZXR0IDxtYXR0aGV3
LmdhcnJldHRAbmVidWxhLmNvbT4NCg==
