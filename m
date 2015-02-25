From: "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: Re: [PATCH v2 3/3] efi: Capsule update with user helper
 interface
Date: Wed, 25 Feb 2015 12:38:20 +0000
Message-ID: <F54AEECA5E2B9541821D670476DAE19C2B8ACE92@PGSMSX102.gar.corp.intel.com>
References: <F54AEECA5E2B9541821D670476DAE19C2B8AC95C@PGSMSX102.gar.corp.intel.com>
 <F54AEECA5E2B9541821D670476DAE19C2B8AC9DD@PGSMSX102.gar.corp.intel.com>
 <20150225114747.GC3226@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150225114747.GC3226-fF5Pk5pvG8Y@public.gmane.org>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Sam Protsenko <semen.protsenko-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "Ong, Boon Leong" <boon.leong.ong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBCb3Jpc2xhdiBQZXRrb3YgW21h
aWx0bzpicEBhbGllbjguZGVdDQo+IFNlbnQ6IFdlZG5lc2RheSwgRmVicnVhcnkgMjUsIDIwMTUg
Nzo0OCBQTQ0KPiANCj4gT24gVHVlLCBGZWIgMjQsIDIwMTUgYXQgMTI6NDk6MDlQTSArMDAwMCwg
S3dlaCwgSG9jayBMZW9uZyB3cm90ZToNCj4gDQo+IFNvIHRoaXMgc291bmRzIHByZXR0eSBvdmVy
ZW5naW5lZXJlZCBmb3Igbm8gcmVhc29uLCBvciBtYXliZSBJJ20gbWlzc2luZw0KPiB0aGUgcmVh
c29uLg0KPiANCj4gSWYgSSBoYWQgdG8gZ2l2ZSBhbiBleGFtcGxlIGZyb20gdGhlIG1pY3JvY29k
ZSBsb2FkZXIsIHdoYXQgd2UgZG8gdGhlcmUNCj4gaXMgcHV0IHRoZSBtaWNyb2NvZGUgaW4gL2xp
Yi9maXJtd2FyZS8uLi4gYW5kIGRvDQo+IA0KPiBlY2hvIDEgPiAvc3lzL2RldmljZXMvc3lzdGVt
L2NwdS9taWNyb2NvZGUvcmVsb2FkDQo+IA0KPiB3aGljaCBnb2VzIGFuZCBjYWxscyByZWxvYWRf
c3RvcmUoKSBpbg0KPiBhcmNoL3g4Ni9rZXJuZWwvY3B1L21pY3JvY29kZS9jb3JlLmMgd2hpY2gg
Z3JhYnMgYSBtdXRleCwgZGlzYWJsZXMgQ1BVDQo+IGhvdHBsdWcsIGV0YywgZXRjLi4uDQo+IA0K
PiBBbmQgdGhpcyBtZWNoYW5pc20gaXMgYXMgc2ltcGxlIGFzIGl0IGNhbiBnZXQuIE1heWJlIGNh
cHN1bGVzIGNhbiBiZQ0KPiBsb2FkZWQgbGlrZSB0aGF0IHRvbz8NCj4gDQo+IEVycm9yIGNvZGUg
Y2FuIGJlIHByb3BhZ2F0ZWQgdG9vLCBpZiBuZWVkZWQsIG9mIGNvdXJzZS4NCj4gDQo+IC0tDQo+
IFJlZ2FyZHMvR3J1c3MsDQo+ICAgICBCb3Jpcy4NCj4gDQo+IEVDTyB0aXAgIzEwMTogVHJpbSB5
b3VyIG1haWxzIHdoZW4geW91IHJlcGx5Lg0KPiAtLQ0KDQpIaSBCb3JpcywNCg0KVGhlIHJlYXNv
biB3ZSB1c2UgdGhpcyBpbnRlcmZhY2UgZm9yIGVmaSBjYXBzdWxlIGlzIHRoYXQgZWZpIGNhcHN1
bGUNCnN1cHBvcnQgbXVsdGkgYmluYXJpZXMgdG8gYmUgdXBsb2FkZWQgYW5kIGVhY2ggYmluYXJ5
IGZpbGUgbmFtZQ0KY2FuIGJlIGRpZmZlcmVudC4NCg0KDQpSZWdhcmRzLA0KV2lsc29uDQoNCg==
