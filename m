From: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>
Subject: RE: [PATCH v9 1/1] efi: a misc char interface for user to update
 efi firmware
Date: Thu, 17 Dec 2015 01:59:26 +0000
Message-ID: <F54AEECA5E2B9541821D670476DAE19C4A8911C4@PGSMSX102.gar.corp.intel.com>
References: <F54AEECA5E2B9541821D670476DAE19C4A879BFE@PGSMSX102.gar.corp.intel.com>
 <20151103195934.GC3620@pd.tnic>
 <F54AEECA5E2B9541821D670476DAE19C4A890F50@PGSMSX102.gar.corp.intel.com>
 <20151216112610.GC29775@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20151216112610.GC29775@pd.tnic>
Content-Language: en-US
Sender: linux-fsdevel-owner@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>
Cc: Matt Fleming <matt@console-pimps.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Ong, Boon Leong" <boon.leong.ong@intel.com>, LKML <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Sam Protsenko <semen.protsenko@linaro.org>, Peter Jones <pjones@redhat.com>, Andy Lutomirski <luto@amacapital.net>, Roy Franz <roy.franz@linaro.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "Anvin, H Peter" <h.peter.anvin@intel.com>, 'Matt Fleming' <matt@codeblueprint.co.uk>
List-Id: linux-efi@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBCb3Jpc2xhdiBQZXRrb3YgW21h
aWx0bzpicEBhbGllbjguZGVdDQo+IFNlbnQ6IFdlZG5lc2RheSwgRGVjZW1iZXIgMTYsIDIwMTUg
NzoyNiBQTQ0KPiBUbzogS3dlaCwgSG9jayBMZW9uZw0KPiBDYzogTWF0dCBGbGVtaW5nOyBHcmVn
IEtyb2FoLUhhcnRtYW47IE9uZywgQm9vbiBMZW9uZzsgTEtNTDsgbGludXgtDQo+IGVmaUB2Z2Vy
Lmtlcm5lbC5vcmc7IFNhbSBQcm90c2Vua287IFBldGVyIEpvbmVzOyBBbmR5IEx1dG9taXJza2k7
IFJveQ0KPiBGcmFuejsgSmFtZXMgQm90dG9tbGV5OyBMaW51eCBGUyBEZXZlbDsgQW52aW4sIEgg
UGV0ZXI7ICdNYXR0IEZsZW1pbmcnDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggdjkgMS8xXSBlZmk6
IGEgbWlzYyBjaGFyIGludGVyZmFjZSBmb3IgdXNlciB0byB1cGRhdGUgZWZpDQo+IGZpcm13YXJl
DQo+IA0KPiBPbiBXZWQsIERlYyAxNiwgMjAxNSBhdCAxMTowOTo1MEFNICswMDAwLCBLd2VoLCBI
b2NrIExlb25nIHdyb3RlOg0KPiA+IFNvLCBteSBjb25jbHVzaW9uIGlzIHRoYXQgdGhpcyBtb2R1
bGUgaXMgbm90IGFibGUgdG8gYmUgdGVzdGVkIG9uIFFFTVUNCj4gPiBlbnZpcm9ubWVudC4NCj4g
DQo+IFRoYXQncyBub3QgdGhlIHBvaW50Lg0KPiANCj4gVGhlIG1vZHVsZSBzaG91bGQgYmV0dGVy
IGhhbmRsZSB3cml0aW5nIHRvIHRoZSBkZXZpY2UgZmlsZSBncmFjZWZ1bGx5DQo+IGFuZCBub3Qg
ZXhwbG9kZS4gUmVnYXJkbGVzcyBvZiB3aGV0aGVyIGl0IGlzIHJ1bm5pbmcgb24gYW4gRUZJIHN5
c3RlbSBvcg0KPiBub3QuDQo+IA0KPiBlZmlfY2Fwc3VsZV9sb2FkZXJfaW5pdCgpIHNpbXBseSBs
b2FkcyB0aGUgZHJpdmVyIG9uICphbnkqIHN5c3RlbSwNCj4gZXZlbiBhICFVRUZJIG9uZS4gQW5k
IHdoZW4gSSB3cml0ZSBzb21lIGdhcmJhZ2UgdG8gdGhlIGRldmljZSBmaWxlLCBpdA0KPiBleHBs
b2Rlcy4NCj4gDQo+IFdoYXQgaXQgc2hvdWxkIGRvIGluc3RlYWQgaXMgY2hlY2sgd2hldGhlciBp
dCBpcyBiZWluZyBsb2FkZWQgb24gZW4gRUZJDQo+IHN5c3RlbSBhbmQgd2hldGhlciBhbGwgaXQg
bmVlZHMgdG8gZnVuY3Rpb24gcHJvcGVybHkgaXMgaW5pdGlhbGl6ZWQNCj4gYWxyZWFkeSwgbGlr
ZSBydW50aW1lIHNlcnZpY2VzLiBJZiBub3QsIGl0IHNob3VsZCByZWZ1c2UgdG8gbG9hZC4NCj4g
DQo+IC0tDQo+IFJlZ2FyZHMvR3J1c3MsDQo+ICAgICBCb3Jpcy4NCg0KSGkgQm9yaXNsYXYsDQoN
CkkgY2F0Y2ggeW91ciBwb2ludCBub3cuIEkgd2lsbCBmaXggdGhhdCBpbiB2MTAgcGF0Y2guDQoN
ClRoYW5rcyAmIFJlZ2FyZHMsDQpXaWxzb24NCg0K
