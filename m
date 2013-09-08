From: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V3 08/11] kexec: Disable at runtime if the kernel
 enforces module loading restrictions
Date: Sun, 8 Sep 2013 17:15:42 +0000
Message-ID: <1378660541.2300.19.camel@x230>
References: <1378252218-18798-1-git-send-email-matthew.garrett@nebula.com>
	 <1378252218-18798-9-git-send-email-matthew.garrett@nebula.com>
	 <20130908064027.GA3587@kroah.com> <1378622648.2300.4.camel@x230>
	 <20130908072408.GA5092@kroah.com>
	 <CAGXu5jLwCt6RtQC+kxcUC69tMydx8DO2QWDv3jK6_mOyT_iNbA@mail.gmail.com>
	 <1378660284.2429.11.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1378660284.2429.11.camel-sFMDBYUN5F8GjUHQrlYNx2Wm91YjaHnnhRte9Li2A+AAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Content-ID: <254C8BA269DE7E40A11C6FC7D4CBEE43-HX+pjaQZbrqcE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

T24gU3VuLCAyMDEzLTA5LTA4IGF0IDEwOjExIC0wNzAwLCBKYW1lcyBCb3R0b21sZXkgd3JvdGU6
DQoNCj4gVGhhdCdzIG5vdCB0cnVlIGlmIHlvdSBsb29rIGF0IHRoZSB1c2UgY2FzZXMuICBEaXN0
cm9zIHVzZSBzaWduZWQNCj4gbW9kdWxlcyB0byB0YWludCB0aGUga2VybmVsOiAgaW5zZXJ0IGFu
IHVuc2lnbmVkIG9uZSBhbmQgdGhlIGtlcm5lbA0KPiB0YWludHM7IGluc2VydCBhIHByb3Blcmx5
IHNpZ25lZCBvbmUgYW5kIGl0IGRvZXNuJ3QuICBUaGV5IHVzZSBpdCBmb3INCj4gc3VwcG9ydCB0
byB0ZWxsIGlmIHlvdSd2ZSBiZWVuIGFkaGVyaW5nIHRvIHlvdXIgY29udHJhY3QuICBUaGF0IHVz
ZSBjYXNlDQo+IGhhcyBub3RoaW5nIHRvIGRvIHdpdGggc2VjdXJpdHkuDQoNClRoYXQgdXNlIGNh
c2UgaGFzIG5vdGhpbmcgdG8gZG8gd2l0aCB0aGlzIHBhdGNoLCBlaXRoZXIuIEl0J3MgY29tcGxl
dGVseQ0KdW5hZmZlY3RlZC4gVGhpcyBvbmx5IHRyaWdnZXJzIGlmIHRoZSBrZXJuZWwgaXMgY29u
ZmlndXJlZCB0byByZWZ1c2UgdGhlDQpsb2FkaW5nIG9mIHVuc2lnbmVkIG1vZHVsZXMuDQoNCj4g
VGhlIGFuYWxvZ3kgaXMgcnViYmlzaC4gIEkgY2FuIGdpdmUgYXdheSBDQVBfU1lTX01PRFVMRSBh
bmQgZW5mb3JjZSB3aGF0DQo+IG1vZHVsZXMgdGhvc2UgSSd2ZSBnaXZlbiB0aGUgcGVybWlzc2lv
biB0byBjYW4gaW5zZXJ0IGJ5IHNpZ25pbmcgdGhlbS4NCj4gSSBrZWVwIENBUF9TWVNfQk9PVCwg
c28gdGhleSBjYW4ndCB1c2Uga2V4ZWMgdG8gc3VidmVydCB0aGlzLg0KDQpZZWFoLCB0aGF0J3Mg
YSBnb29kIGFyZ3VtZW50IGZvciB3aHkgY2FwYWJpbGl0aWVzIGFyZSBtb3N0bHkgcG9pbnRsZXNz
Lg0KSWYgSSBoYXZlIENBUF9TWVNfQk9PVCBJIGNhbiBnaXZlIG15c2VsZiBhbnkgb3RoZXIgY2Fw
YWJpbGl0aWVzLiBXaHkNCmJvdGhlcj8NCg0KLS0gDQpNYXR0aGV3IEdhcnJldHQgPG1hdHRoZXcu
Z2FycmV0dEBuZWJ1bGEuY29tPg0K
