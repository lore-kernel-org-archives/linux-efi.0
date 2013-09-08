From: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V3 08/11] kexec: Disable at runtime if the kernel
 enforces module loading restrictions
Date: Sun, 8 Sep 2013 14:40:04 +0000
Message-ID: <1378651204.2300.7.camel@x230>
References: <1378252218-18798-1-git-send-email-matthew.garrett@nebula.com>
	 <1378252218-18798-9-git-send-email-matthew.garrett@nebula.com>
	 <20130908064027.GA3587@kroah.com> <1378622648.2300.4.camel@x230>
	 <20130908072408.GA5092@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130908072408.GA5092-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Content-ID: <C61926F65BC8554486FC9FB880DA7ED9-HX+pjaQZbrqcE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org" <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

T24gU3VuLCAyMDEzLTA5LTA4IGF0IDAwOjI0IC0wNzAwLCBHcmVnIEtIIHdyb3RlOg0KPiBPbiBT
dW4sIFNlcCAwOCwgMjAxMyBhdCAwNjo0NDowOEFNICswMDAwLCBNYXR0aGV3IEdhcnJldHQgd3Jv
dGU6DQoNCj4gPiBBdCB0aGUgbW9zdCB0cml2aWFsIGxldmVsLCBncmFiIHRoZSBhZGRyZXNzIG9m
IHNpZ19lbmZvcmNlIGZyb20NCj4gPiBrYWxsc3ltcywganVtcCB0byBhIGtlcm5lbCB0aGF0IGRv
ZXNuJ3QgZW5mb3JjZSBTVFJJQ1RfREVWTUVNLCBtb2RpZnkNCj4gPiBzaWdfZW5mb3JjZSwganVt
cCBiYWNrIHRvIHRoZSBvbGQga2VybmVsLg0KPiANCj4gV2hpY2ggcHJvdmVzIHdoYXQ/DQoNCnNp
Z19lbmZvcmNlIGNhbiBiZSBzZXQsIGJ1dCBvbmNlIGl0J3Mgc2V0IGNhbid0IGJlIHVuc2V0LiBX
aHkgZG8geW91DQp0aGluayB0aGF0IGlzPw0KDQotLSANCk1hdHRoZXcgR2FycmV0dCA8bWF0dGhl
dy5nYXJyZXR0QG5lYnVsYS5jb20+DQo=
