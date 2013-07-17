From: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RESEND][v3.8] [v3.9] [v3.10] [Regression]  efi: be more
 paranoid about available space when creating variables
Date: Wed, 17 Jul 2013 20:42:02 +0000
Message-ID: <1374093721.2670.0.camel@x230>
References: <51E6FFD2.7010505@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51E6FFD2.7010505-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Content-Language: en-US
Content-ID: <0C5B31AD18C0504DB65B54FF0B70B3E8-HX+pjaQZbrqcE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Joseph Salisbury <joseph.salisbury-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Brad Figg <brad.figg-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

T24gV2VkLCAyMDEzLTA3LTE3IGF0IDE2OjM0IC0wNDAwLCBKb3NlcGggU2FsaXNidXJ5IHdyb3Rl
Og0KPiBIaSBNYXR0aGV3LA0KPiANCj4gQSBidWcgd2FzIG9wZW5lZCB0aGF0IHJlcG9ydHMgYSBy
ZWdyZXNzaW9uIHRoYXQgcHJldmVudHMgYSBzeXN0ZW0gZnJvbQ0KPiBib290aW5nWzBdLiAgQWZ0
ZXIgYSBrZXJuZWwgYmlzZWN0LCBpdCB3YXMgZm91bmQgdGhhdCByZXZlcnRpbmcgdGhlDQo+IGZv
bGxvd2luZyBjb21taXQgcmVzb2x2ZWQgdGhpcyBidWc6DQoNClRoaXMgc2hvdWxkIGJlIGZpeGVk
IGJ5IGY4Yjg0MDQzMzdkZTRlMjQ2NmUyZTExMzllYTY4YjFmODI5NTk3NGYNCg0KLS0gDQpNYXR0
aGV3IEdhcnJldHQgfCBtamc1OUBzcmNmLnVjYW0ub3JnDQo=
