From: "Prakhya, Sai Praneeth" <sai.praneeth.prakhya@intel.com>
Subject: RE: [PATCH V4 3/3] x86/efi: Introduce EFI_PAGE_FAULT_HANDLER
Date: Fri, 7 Sep 2018 19:08:27 +0000
Message-ID: <FFF73D592F13FD46B8700F0A279B802F485BA620@ORSMSX114.amr.corp.intel.com>
References: <1536276468-28499-1-git-send-email-sai.praneeth.prakhya@intel.com>
 <1536276468-28499-4-git-send-email-sai.praneeth.prakhya@intel.com>
 <20180907112207.GS24106@hirez.programming.kicks-ass.net>
 <FFF73D592F13FD46B8700F0A279B802F485BA5C1@ORSMSX114.amr.corp.intel.com>
 <e10acaa8-f5d8-85f3-219c-86fafd793a87@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <e10acaa8-f5d8-85f3-219c-86fafd793a87@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Bhupesh Sharma <bhsharma@redhat.com>
Cc: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "Neri, Ricardo" <ricardo.neri@intel.com>, "matt@codeblueprint.co.uk" <matt@codeblueprint.co.uk>, Al Stone <astone@redhat.com>, Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Peter Zijlstra <peterz@infradead.org>
List-Id: linux-efi@vger.kernel.org

PiA+ID4gV2h5IG1ha2UgdGhpcyBvcHRpb25hbD8NCj4gPg0KPiA+IEkgbWFkZSBpdCBhcyBhIGNv
bmZpZyBvcHRpb24gaW4gUkZDIGJlY2F1c2UgdGhlIHBhZ2UgZmF1bHQgaGFuZGxlciB3YXMNCj4g
PiBjb21wbGljYXRlZCBhbmQgdG91Y2hpbmcgbWFueSBwYXJ0cyAoaXQgaGFkIGxvdHMgb2YgY29k
ZSBjaGFuZ2UgYW5kIEkNCj4gPiBkaWRuJ3Qgd2FudCB0byBicmVhayBhbnkgZXhpc3RpbmcgZnVu
Y3Rpb25hbGl0eSkuIE5vdyB0aGF0IGl0J3MNCj4gPiBzaW1wbGUsIEkgZG9uJ3QgdGhpbmsgd2Ug
bmVlZCB0aGUgY29uZmlnIG9wdGlvbi4NCj4gPg0KPiA+IFdpdGhvdXQgZWZpIHBhZ2UgZmF1bHQg
aGFuZGxlciwgYW55IHBhZ2UgZmF1bHQgY2F1c2VkIGJ5IGZpcm13YXJlDQo+ID4gc2hvdWxkIHBh
bmljIGtlcm5lbCBidXQgd2l0aCB0aGlzIHBhdGNoIEkgdGhpbmsgd2UgYXJlIGp1c3QgaW1wcm92
aW5nIGV4aXN0aW5nDQo+IGNvbmRpdGlvbiAoaWRlYWxseSkuDQo+ID4NCj4gPiBTbywgaWYgVGhv
bWFzLCBJbmdvLCBBbmR5LCBBcmQgYW5kIEJvcmlzIGFyZSBvay4uIEkgd2lsbCBtYWtlIGl0IGFz
DQo+ID4gZGVmYXVsdCAoaS5lLiB3aXRob3V0IGNvbmZpZykuDQo+ID4NCj4gPiBSZWdhcmRzLA0K
PiA+IFNhaQ0KPiA+DQo+IEFsc28sIHNvbWUgZGlzdHJpYnV0aW9ucyBhbHJlYWR5IGhhdmUgc3Bl
Y2lmaWMgd2F5cyB0byBoYW5kbGUgYnVnZ3kgZmlybXdhcmVzDQo+IHdoaWNoIGNhbiBiZSBhdCB0
aW1lcyBkZXBlbmRlbnQgb24gdGhlIHVuZGVybHlpbmcgaGFyZHdhcmUgYW5kIHRoZSBmaXJtd2Fy
ZQ0KPiB2ZXJzaW9ucy4NCj4gDQo+IEkgd291bGQgc3VnZ2VzdCB0aGF0IHdlIGVuYWJsZSB0aGlz
IHVuZGVyIGEgQ09ORklHIGZvciB0aGUgZmlyc3Qgcm91bmQgYW5kIG9uY2UNCj4gaXQgaXMgdGVz
dGVkIHdpdGggd2lkZXIgdmFyaWV0eSBvZiB4ODYgbWFjaGluZXMgd2hpY2ggaGF2ZSBidWdneSBv
ciBvcnBoYW5lZA0KPiBmaXJtd2FyZSBhbmQgbGludXggKGFuZCByZWJvb3QpIHdvcmtzIGZpbmUg
d2l0aCB0aGVtLCB3ZSBjYW4gZHJvcCB0aGUgQ09ORklHDQo+IG9wdGlvbiBpbiBmdXR1cmUgYW5k
IGVuYWJsZSB0aGlzIGJ5IGRlZmF1bHQuDQoNClNvdW5kcyBmYWlyIHRvIG1lLCBidXQsIEkgd291
bGQgbGlrZSB0byB3YWl0IGZvciBzb21lb25lIGV4cGVyaWVuY2VkIHRvIG1ha2UgdGhlIGZpbmFs
IGNhbGwuDQoNClJlZ2FyZHMsDQpTYWkNCg==
