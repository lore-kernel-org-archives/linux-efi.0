From: "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v6 0/2] Enable capsule loader interface for efi firmware
 updating
Date: Mon, 5 Oct 2015 15:33:56 +0000
Message-ID: <F54AEECA5E2B9541821D670476DAE19C4A864658@PGSMSX102.gar.corp.intel.com>
References: <1443733554-22743-1-git-send-email-hock.leong.kweh@intel.com>
 <20151002173704.GD16538@pd.tnic>
 <F54AEECA5E2B9541821D670476DAE19C4A8641E4@PGSMSX102.gar.corp.intel.com>
 <20151003090539.GC11942@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151003090539.GC11942-fF5Pk5pvG8Y@public.gmane.org>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "Ong, Boon Leong" <boon.leong.ong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sam Protsenko <semen.protsenko-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Fleming, Matt" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBCb3Jpc2xhdiBQZXRrb3YgW21h
aWx0bzpicEBhbGllbjguZGVdDQo+IFNlbnQ6IFNhdHVyZGF5LCBPY3RvYmVyIDAzLCAyMDE1IDU6
MDYgUE0NCj4gT24gU2F0LCBPY3QgMDMsIDIwMTUgYXQgMDM6MTg6NDFBTSArMDAwMCwgS3dlaCwg
SG9jayBMZW9uZyB3cm90ZToNCj4gPiA+IFdoYXQgZG9lcyB0aGUgZXJyb3IgY2FzZSBsb29rIGxp
a2U/IEEgc3RhbmRhcmQgZ2xpYmMgbWVzc2FnZSBhYm91dA0KPiA+ID4gd3JpdGUoMikgZmFpbGlu
Zz8NCj4gPiA+DQo+ID4NCj4gPiBBbnkgdXBsb2FkIGZhaWwgZXJyb3IgbGlrZSAtRU5PTUVNLCAt
RUlOVkFMLCAtRUlPIGFzIHdlbGwgYXMgZXJyb3INCj4gPiByZXR1cm5lZCBieSBlZmlfY2Fwc3Vs
ZV91cGRhdGUoKSBBUEkuDQo+IA0KPiBBbGwgSSdtIGFza2luZyBpcywgaG93IGRvZXMgdGhlIHVz
ZXIga25vdyB0aGF0IHRoZSB1cGxvYWQgZGlkbid0IHN1Y2NlZWQ/DQo+IA0KDQpJIHRoaW5rIGl0
IHNob3VsZCBkZXBlbmQgb24gdXNlciBhcHAgYWJvdXQgd2hpY2ggQVBJIHRoZXkgYXJlIHVzaW5n
Lg0KSWYgdGhleSBhcmUgdXNpbmcgc3lzY2FsbCB0aGVuIGVycm9ycyB3b3VsZCBiZSByZXR1cm5l
ZCB0aHJvdWdoIHdyaXRlKDIpLg0KSWYgdGhleSBhcmUgdXNpbmcgbGliYyBBUElzIGZ3cml0ZSwg
ZnB1dHMgYW5kIGZwcmludGYsIHRoZW4gdGhlIGVycm9ycyB3b3VsZA0KcmV0dXJuIHRocm91Z2gg
dGhvc2UgQVBJcy4gSG93ZXZlciwgdGhpcyBkZXNpZ24gaXMgdGFyZ2V0aW5nIHRoZSBzaW1wbGUN
CnVwbG9hZCBhY3Rpb24gImNhdCBjYXBzdWxlLmJpbiA+IC9kZXYvZWZpX2NhcHN1bGVfbG9hZGVy
Iiwgc28gdGhlIGVycm9ycw0Kc2hvdWxkIGJlIHJldHVybmVkIHRocm91Z2ggY2F0KCkgb3IgSS9P
IHJlZGlyZWN0aW9uIG1lY2hhbmlzbSBmcm9tDQpzaGVsbCB0ZXJtaW5hbC4gQW0gSSBhbnN3ZXJl
ZCB5b3VyIHF1ZXN0aW9uPw0KDQpCdHcsIEkgaGF2ZSBhbiBvdXQgdG9waWMgcXVlc3Rpb246IEkg
ZG8gbm90aWNlIHlvdSBndXlzIHdyb3RlIGluIHRoZSBtZXNzYWdlDQp0aGF0IGEgZnVuY3Rpb24g
bG9vayBsaWtlIHdyaXRlKDIpIG9yIGNsb3NlKDIpLiBXaGF0IGFjdHVhbGx5IHRoZSAiMiIgbWVh
biB0aGVyZT8NCg0KVGhhbmtzICYgcmVnYXJkcywNCldpbHNvbg0KDQo=
