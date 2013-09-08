From: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V3 08/11] kexec: Disable at runtime if the kernel
 enforces module loading restrictions
Date: Sun, 8 Sep 2013 16:59:40 +0000
Message-ID: <1378659580.2300.15.camel@x230>
References: <1378252218-18798-1-git-send-email-matthew.garrett@nebula.com>
	 <1378252218-18798-9-git-send-email-matthew.garrett@nebula.com>
	 <20130908064027.GA3587@kroah.com> <1378622648.2300.4.camel@x230>
	 <20130908072408.GA5092@kroah.com>
	 <CAGXu5jLwCt6RtQC+kxcUC69tMydx8DO2QWDv3jK6_mOyT_iNbA@mail.gmail.com>
	 <20130908161859.GA18946@kroah.com> <1378657487.2300.10.camel@x230>
	 <20130908163926.GA19665@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130908163926.GA19665-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Content-ID: <EA8EF98376F32C48B29FAF8AB34D7607-HX+pjaQZbrqcE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

T24gU3VuLCAyMDEzLTA5LTA4IGF0IDA5OjM5IC0wNzAwLCBHcmVnIEtIIHdyb3RlOg0KDQo+IEJ1
dCBJIHdhbnQsIGZvciBvdGhlciByZWFzb25zIChpLmUuIHNhZmV0eSBpbiBsYXllcnMpLCBzaWdu
ZWQga2VybmVsDQo+IG1vZHVsZXMuICBJIGFsc28gbWlnaHQgYWN0dWFsbHkgd2FudCBzb21lIGRl
YnVnZnMgZmlsZXMgaW4gc29tZSByYW5kb20NCj4gZHJpdmVyIChsaWtlIHRoaXMgc2VyaWVzIHJl
bW92ZXMpLg0KDQpZb3Ugd2FudCBhIGNvbmZpZ3VyYXRpb24gdGhhdCBtYWtlcyBubyBzZW5zZS4g
VGhlcmUncyBubyByZWFzb24gdGhhdCB0aGUNCmtlcm5lbCBzaG91bGQgbWFrZSB0aGF0IGVhc3ku
DQoNCj4gSGVjaywgbG9vayBhdCBSZWQgSGF0LiAgVGhleSBoYXZlIGJlZW4gc2hpcHBpbmcgc2ln
bmVkIGtlcm5lbCBtb2R1bGVzDQo+IGZvciBfeWVhcnNfIGFuZCB5ZXQgdGhleSBkbyBub3QgZGlz
YWJsZSBrZXhlYy4gIEhhdmUgdGhleSBiZWVuICJkb2luZyBpdA0KPiB3cm9uZyIgYWxsIG9mIHRo
aXMgdGltZT8gICBQZXJoYXBzIHBlb3BsZSB3YW50IHNpZ25lZCBtb2R1bGVzIGp1c3QgZm9yDQo+
IHN1cHBvcnQgcmVhc29ucywgbm90ICJzZWN1cml0eSIgcmVhc29ucy4NCg0KVGhlbiB0aGV5IGRv
IHdoYXQgUmVkIEhhdCBkb2VzIGFuZCBkb24ndCBzZXQgQ09ORklHX1NJR19FTkZPUkNFLg0KDQo+
IERvbid0IHRha2UgYXdheSB0aG9zZSBvcHRpb25zLg0KDQpXaGVyZSdzIHRoZSBvcHRpb24gdG8g
bGV0IG1lIGxldCB1bnByaXZpbGVnZWQgdXNlcnMgc2V0IHJhbmRvbSBNU1JzPw0KV2hlcmUncyB0
aGUgb3B0aW9uIHRvIGxldCByb290IGRpc2FibGUgU1RSSUNUX0RFVk1FTSBhdCBydW50aW1lPyBX
ZQ0KZG9uJ3Qgb2ZmZXIgdGhlc2Ugb3B0aW9ucyBiZWNhdXNlICp0aGV5IG1ha2Ugbm8gc2Vuc2Uq
LiBMb2NraW5nIHlvdXINCmRvb3Igd2hpbGUgbGVhdmluZyB5b3VyIHdpbmRvdyBvcGVuIG1heSBt
YWtlIHlvdSBmZWVsIGJldHRlciwgYnV0IGl0DQpkb2Vzbid0IGltcHJvdmUgdGhlIHNlY3VyaXR5
IG9mIHlvdXIgaG91c2UuDQoNCi0tIA0KTWF0dGhldyBHYXJyZXR0IDxtYXR0aGV3LmdhcnJldHRA
bmVidWxhLmNvbT4NCg==
