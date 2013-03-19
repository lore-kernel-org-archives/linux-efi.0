From: Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org>
Subject: RE: sysfs: cannot create duplicate filename
Date: Tue, 19 Mar 2013 15:46:41 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D41AF6F4F8@USINDEM103.corp.hds.com>
References: <CAHsu+b-cG+ED6TX5evRTBjR-LwHugW+8-9hnHXAz5DnAioJnUQ@mail.gmail.com>
  <5135BD66.1030005@redhat.com>
  <1362755479.15011.238.camel@mfleming-mobl1.ger.corp.intel.com>
  <513A2B29.8090705@redhat.com>
  <1363082900.15011.257.camel@mfleming-mobl1.ger.corp.intel.com>
  <513F0734.80600@redhat.com>
  <1363106125.15011.263.camel@mfleming-mobl1.ger.corp.intel.com>
  <51405943.2000601@redhat.com>
  <1363278817.15011.316.camel@mfleming-mobl1.ger.corp.intel.com>
  <A5ED84D3BB3A384992CBB9C77DEDA4D41AF68807@USINDEM103.corp.hds.com>
 <1363618261.14988.4.camel@mfleming-mobl1.ger.corp.intel.com>
 <51483A88.6060509@redhat.com>
 <A5ED84D3BB3A384992CBB9C77DEDA4D41AF6E1F9@USINDEM103.corp.hds.com>
 <514883B7.1010602@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <514883B7.1010602-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andre Heider <a.heider-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

DQo+IFdlJ3ZlIG5vIHJlYXNvbiB0byBiZWxpZXZlIHRoYXQgdGhlcmUgYXJlIGJyb2tlbiBTZXRW
YXJpYWJsZSgpIGltcGxlbWVudGF0aW9ucyBpbiB0aGUgd2lsZC4gSWYgYW55IGV2ZXIgY3JvcCB1
cCwgd2UgY2FuIGRlYWwgd2l0aA0KPiB0aGVtIGFzIGFuZCB3aGVuLg0KDQpPSy4gSSB3aWxsIG1h
a2UgYSBwYXRjaCBkaXNhYmxpbmcganVzdCBnZXRfbmV4dF92YXJpYWJsZSgpLg0KSSdtIHRoaW5r
aW5nIHRoYXQgaXQgaXMgcmVhc29uYWJsZSB0byBzZXQgb3BzLT5nZXRfbmV4dF92YXJpYWJsZSB0
byBOVUxMIGluIHJlZ2lzdGVyX2VmaXZhcnMoKSwNCiBpbnN0ZWFkIG9mIGludHJvZHVjaW5nIGEg
bmV3IGdsb2JhbCB2YXJpYWJsZS4uLi4NCg0KU2VpamkNCg0KDQo+IC0tLS0tT3JpZ2luYWwgTWVz
c2FnZS0tLS0tDQo+IEZyb206IE1hdHQgRmxlbWluZyBbbWFpbHRvOm1hdHRAY29uc29sZS1waW1w
cy5vcmddDQo+IFNlbnQ6IFR1ZXNkYXksIE1hcmNoIDE5LCAyMDEzIDExOjI3IEFNDQo+IFRvOiBT
ZWlqaSBBZ3VjaGkNCj4gQ2M6IExpbmd6aHUgWGlhbmc7IEFuZHJlIEhlaWRlcjsgbGludXgtZWZp
QHZnZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0OiBSZTogc3lzZnM6IGNhbm5vdCBjcmVhdGUgZHVw
bGljYXRlIGZpbGVuYW1lDQo+IA0KPiBPbiAwMy8xOS8yMDEzIDAyOjI1IFBNLCBTZWlqaSBBZ3Vj
aGkgd3JvdGU6DQo+ID4gSSBzZWUsIHlvdSBhcmUgY29uY2VybmVkIHRoYXQgYSBzZXRfdmFyaWFi
bGUgc2VydmljZSBtYXkgbm90IHdvcmsgY29ycmVjdGx5Lg0KPiA+IElmIHNvLCAgdGhlIHNldF92
YXJpYWJsZSBzZXJ2aWNlIHNob3VsZCBiZSBkaXNhYmxlZCBpbiBhZGRpdGlvbiB0byBnZXRfbmV4
dF92YXJpYWJsZSBzZXJ2aWNlLg0KPiANCj4gV2UndmUgbm8gcmVhc29uIHRvIGJlbGlldmUgdGhh
dCB0aGVyZSBhcmUgYnJva2VuIFNldFZhcmlhYmxlKCkgaW1wbGVtZW50YXRpb25zIGluIHRoZSB3
aWxkLiBJZiBhbnkgZXZlciBjcm9wIHVwLCB3ZSBjYW4gZGVhbCB3aXRoDQo+IHRoZW0gYXMgYW5k
IHdoZW4uDQo+IA0KPiAtLQ0KPiBNYXR0IEZsZW1pbmcsIEludGVsIE9wZW4gU291cmNlIFRlY2hu
b2xvZ3kgQ2VudGVyDQo=
