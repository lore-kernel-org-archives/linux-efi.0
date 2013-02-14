From: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] x86: Lock down MSR writing in secure boot
Date: Thu, 14 Feb 2013 01:04:33 +0000
Message-ID: <1360803872.18083.46.camel@x230.lan>
References: <dee64752-850c-4d78-b703-f47a985bc13e@email.android.com>
	      <CAGXu5jLAufTRm=sDST0br_WEkn4o0Hpjv2jDP2Na=cCvuM+MGg@mail.gmail.com>
	      <1360355671.18083.18.camel@x230.lan>
	      <CAGXu5jKo2PfMBO4A0ZgQcrPuj8OHNaff+CjAesOAWkZc0vB9+Q@mail.gmail.com>
	      <51157C9C.6030501@zytor.com> <20130208230655.GB28990@pd.tnic>
	      <1360366012.18083.21.camel@x230.lan> <5115A4CC.3080102@zytor.com>
	      <1360373383.18083.23.camel@x230.lan>
	      <CAGXu5j+xvJ3L5ejxtZ-Jw3F6rV7OsrE0_HZCGu_er0rH2_PwKA@mail.gmail.com>
	      <20130209092925.GA17728@pd.tnic> <1360422712.18083.24.camel@x230.lan>
	     <511AE2CC.5040705@zytor.com> <1360733962.18083.30.camel@x230.lan>
	    <511B2EB9.5070406@zytor.com> <1360736860.18083.33.camel@x230.lan>
	   <511B33BC.9080307@zytor.com> <1360737709.18083.36.camel@x230.lan>
	  <511BCB6E.8080102@zytor.com> <1360776399.18083.39.camel@x230.lan>
	 <511BD291.1040003@schaufler-ca.com> <511C1325.5060601@zytor.com>
	 <511C1A94.8020804@schaufler-ca.com> <511C2F0C.3060803@zytor.com >
	 <511C3389.5090604@schaufler-ca.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <511C3389.5090604-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>
Content-Language: en-US
Content-ID: <A46818A85CABCD43B44270B294F6561C-HX+pjaQZbrqcE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-security-module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

T24gV2VkLCAyMDEzLTAyLTEzIGF0IDE2OjQ0IC0wODAwLCBDYXNleSBTY2hhdWZsZXIgd3JvdGU6
DQoNCj4gSWYgeW91IHdhbnQgdGhhdCBzb3J0IG9mIGdyYW51bGFyaXR5IHRocm93IHlvdXJzZWxm
IG9uIHRoZSBTRUxpbnV4DQo+IGJhbmR3YWdvbi4gRmluZSBncmFpbmVkIGNhcGFiaWxpdGllcyBh
cmUgaW5zYW5lIGFuZCB1bm1hbmFnZWFibGUNCj4gYW5kIHdpbGwgb25seSBsZWFkIHRvIHRlYXJz
LiBTZWN1cml0eSBpcyBkZXNwaXNlZCBiZWNhdXNlIG9mIHRoZQ0KPiBub3Rpb24gdGhhdCBtYWtp
bmcgc3lzdGVtcyBpbXBvc3NpYmxlIHRvIHVzZSBpcyBhIGdvb2QgdGhpbmcuDQoNClNFTGludXgg
aXMgY29tcGxldGVseSB1bnVzYWJsZSBmb3IgdGhpcyBzcGVjaWZpYyBjYXNlLg0KDQotLSANCk1h
dHRoZXcgR2FycmV0dCB8IG1qZzU5QHNyY2YudWNhbS5vcmcNCg==
