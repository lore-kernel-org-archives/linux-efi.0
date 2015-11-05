From: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>
Subject: RE: [PATCH v9 1/1] efi: a misc char interface for user to update
 efi firmware
Date: Thu, 5 Nov 2015 03:42:25 +0000
Message-ID: <F54AEECA5E2B9541821D670476DAE19C4A87A8D0@PGSMSX102.gar.corp.intel.com>
References: <1446055138-26047-1-git-send-email-hock.leong.kweh@intel.com>
 <1446055138-26047-2-git-send-email-hock.leong.kweh@intel.com>
 <20151101102944.GA12711@pd.tnic>
 <F54AEECA5E2B9541821D670476DAE19C4A8799FB@PGSMSX102.gar.corp.intel.com>
 <20151101105801.GB12711@pd.tnic>
 <F54AEECA5E2B9541821D670476DAE19C4A879A18@PGSMSX102.gar.corp.intel.com>
 <20151101125835.GC12711@pd.tnic>
 <F54AEECA5E2B9541821D670476DAE19C4A879C38@PGSMSX102.gar.corp.intel.com>
 <20151103201455.GD3620@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20151103201455.GD3620@pd.tnic>
Content-Language: en-US
Sender: linux-fsdevel-owner@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>
Cc: Matt Fleming <matt@console-pimps.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Ong, Boon Leong" <boon.leong.ong@intel.com>, LKML <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Sam Protsenko <semen.protsenko@linaro.org>, Peter Jones <pjones@redhat.com>, Andy Lutomirski <luto@amacapital.net>, Roy Franz <roy.franz@linaro.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "Fleming, Matt" <matt.fleming@intel.com>, "Anvin, H Peter" <h.peter.anvin@intel.com>
List-Id: linux-efi@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBCb3Jpc2xhdiBQZXRrb3YgW21h
aWx0bzpicEBhbGllbjguZGVdDQo+IFNlbnQ6IFdlZG5lc2RheSwgTm92ZW1iZXIgMDQsIDIwMTUg
NDoxNSBBTQ0KPiANCj4gT24gTW9uLCBOb3YgMDIsIDIwMTUgYXQgMDc6MTc6MjhBTSArMDAwMCwg
S3dlaCwgSG9jayBMZW9uZyB3cm90ZToNCj4gPiBUaGlzIGlzIG5vdCBhIHJldHVybiB2YWx1ZSB0
byBpbmRpY2F0ZSB3aGF0IGlzIGdvaW5nIG5vdy4gSXQgaXMgYSBmbGFnDQo+ID4gdXNlZCBpbiAi
Y2FwX2luZm8tPmluZGV4IiB3aGljaCBwb3NpdGl2ZSB2YWx1ZSBoYXMgYSBtZWFuaW5nIG9mIGlu
ZGV4DQo+ID4gbnVtYmVyLiBJIGFtIHVzaW5nIHRoZSBuZWdhdGl2ZSB2YWx1ZSBmb3IgdGhlIGZs
YWcgd2hpY2ggc2ltaWxhciB0bw0KPiA+IHRoZSBpbXBsZW1lbnRhdGlvbiBvZiBwb2ludGVyICYg
ZXJyb3IgcG9pbnRlciAoRVJSX1BUUikuDQo+IA0KPiBPaywgYnV0IHRoYXQgZG9lc24ndCBtYWtl
IGFueSBzZW5zZTogeW91J3JlIGFzc2lnbmluZyBVUExPQURfRE9ORSB0bw0KPiBjYXBfaW5mby0+
aW5kZXggb25seSBvbmNlIGluIGVmaV9jYXBzdWxlX3N1Ym1pdF91cGRhdGUoKSBhbmQgeW91J3Jl
IG5vdA0KPiB0ZXN0aW5nIGl0IGFueXdoZXJlLiBZZWFoLCB5ZWFoLCB5b3UncmUgaW1wbGljaXRs
eSB0ZXN0aW5nIGZvciBpdCBieQ0KPiBkb2luZyB0aGUgIjwgMCIgY2hlY2suDQo+IA0KPiBTbyBz
aW1wbHkgYXNzaWduIC0xIHRvIC0+aW5kZXggdG8gbWVhbiAqYW55KiB0eXBlIG9mIGVycm9yIG9j
Y3VycmVkLA0KPiByZW1vdmUgdGhlIGRlZmluZXMgYW5kIHlvdSBjYW4gYWx3YXlzIHRlc3QgZm9y
ICI8IDAiIHRvIG1lYW4gImRpZA0KPiBzb21ldGhpbmcgZmFpbCIuDQo+IA0KPiBZb3Ugc2ltcGx5
IGRvbid0IG5lZWQgdHdvIGVycm9yIHZhbHVlcy4uLg0KPiANCg0KT2suIE5vdGVkLg0KDQpUaGFu
a3MgJiBSZWdhcmRzLA0KV2lsc29uDQoNCg==
