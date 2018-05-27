From: "Prakhya, Sai Praneeth" <sai.praneeth.prakhya@intel.com>
Subject: RE: [PATCH V4 0/3] Use efi_rts_wq to invoke EFI Runtime Services
Date: Sun, 27 May 2018 05:32:52 +0000
Message-ID: <FFF73D592F13FD46B8700F0A279B802F3952F0CF@ORSMSX114.amr.corp.intel.com>
References: <1527285903-31799-1-git-send-email-sai.praneeth.prakhya@intel.com>
 <CAKv+Gu_oNUmOwTgM9sAsfMn4WgY+grC2f12vRC4HH9CgxxkfXQ@mail.gmail.com>
 <FFF73D592F13FD46B8700F0A279B802F39481456@ORSMSX114.amr.corp.intel.com>
 <CAKv+Gu_eShqmjkDSXnFs-_Hcay67+JTMdb6TatNZpV2v5_MoaQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu_eShqmjkDSXnFs-_Hcay67+JTMdb6TatNZpV2v5_MoaQ@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Lee Chun-Yi <jlee@suse.com>, Borislav Petkov <bp@alien8.de>, "Luck, Tony" <tony.luck@intel.com>, Will Deacon <will.deacon@arm.com>, "Hansen, Dave" <dave.hansen@intel.com>, Mark Rutland <mark.rutland@arm.com>, Bhupesh Sharma <bhsharma@redhat.com>, Naresh Bhat <naresh.bhat@linaro.org>, "Neri, Ricardo" <ricardo.neri@intel.com>, Peter Zijlstra <peterz@infradead.org>, "Shankar, Ravi V" <ravi.v.shankar@intel.com>, Matt Fleming <matt@codeblueprint.co.uk>, "Williams, Dan J" <dan.j.williams@intel.com>, Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
List-Id: linux-efi@vger.kernel.org

PiA+IEFzc3VtZSBzb21lIHVzZXIgcmVxdWVzdGVkIHRvIGV4ZWN1dGUgc29tZSBub24tYmxvY2tp
bmcgdmFyaWFudCBvZg0KPiA+IGVmaV9ydHMgYW5kIHRoZSBrZXJuZWwgaGFzbid0IGNhbGxlZCBl
ZmlfY2FsbF92aXJ0KCkgeWV0LCBidXQgd2FzDQo+ID4gc2NoZWR1bGVkIG91dC4gSU9XLCBldmVu
IHRob3VnaCB1c2VyIHJlcXVlc3RzIGZvciBub24tYmxvY2tpbmcgZWZpIGNhbGwsIHdlDQo+IG1p
Z2h0IHN0aWxsIGJsb2NrLiBBbSBJIHJpZ2h0Pw0KPiA+DQo+IA0KPiBObywgdGhhdCBpcyB0aGUg
d2hvbGUgcG9pbnQuIFRoZXNlIGZ1bmN0aW9ucyBtYXkgYmUgY2FsbGVkIGZyb20gYXRvbWljIGNv
bnRleHQsDQo+IHdoaWNoIGlzIHdoeSB0aGV5IHRyeWxvY2soKSBhbmQgZ2l2ZSB1cCByYXRoZXIg
dGhhbiBibG9jayBvbiB0aGUgc2VtYXBob3JlIGlmIGEgcnQNCj4gc2VydmljZXMgY2FsbCBpcyBh
bHJlYWR5IGluIHByb2dyZXNzLiBFLmcuLA0KPiANCj4gLyoNCj4gICogZWZpdmFyX2VudHJ5X3Nl
dF9ub25ibG9ja2luZyAtIGNhbGwgc2V0X3ZhcmlhYmxlX25vbmJsb2NraW5nKCkNCj4gICoNCj4g
ICogVGhpcyBmdW5jdGlvbiBpcyBndWFyYW50ZWVkIHRvIG5vdCBibG9jayBhbmQgaXMgc3VpdGFi
bGUgZm9yIGNhbGxpbmcNCj4gICogZnJvbSBjcmFzaC9wYW5pYyBoYW5kbGVycy4NCj4gICoNCj4g
ICogQ3J1Y2lhbGx5LCB0aGlzIGZ1bmN0aW9uIHdpbGwgbm90IGJsb2NrIGlmIGl0IGNhbm5vdCBh
Y3F1aXJlDQo+ICAqIGVmaXZhcnNfbG9jay4gSW5zdGVhZCwgaXQgcmV0dXJucyAtRUJVU1kuDQo+
ICAqLw0KPg0KDQpPbmUgbW9yZSBxdWVzdGlvbiBhZ2FpbiwgaWYgd2UgYXJlIHN1cmUgdGhhdCBu
b24tYmxvY2tpbmcgdmFyaWFudHMgd2lsbA0KX2Fsd2F5c18gYmUgY2FsbGVkIGluIGF0b21pYyBj
b250ZXh0LCB0aGVuLCB3ZSBnb3QgaXQgY292ZXJlZC4gQmVjYXVzZSwgaW4NCnNldF92YXJpYWJs
ZSgpIGFuZCBxdWVyeV92YXJpYWJsZV9pbmZvKCkgKGJvdGggYmxvY2tpbmcgYW5kIG5vbi1ibG9j
a2luZykgd2UgY2hlY2sNCmZvciBpbl9hdG9taWMoKSBhbmQgaWYgc28sIHdlIGRvbid0IHVzZSBl
ZmlfcnRzX3dxIChwbGVhc2UgcmVmZXIgdG8gcGF0Y2ggMykuDQoNCklmIHlvdSB0aGluaywgdGhl
cmUgbWlnaHQgYmUgYSBwcm9iYWJpbGl0eSBvZiBjYWxsaW5nIG5vbi1ibG9ja2luZyBlZmlfcnRz
IG91dCBvZiBhdG9taWMNCmNvbnRleHQsIHRoZW4sIHN1cmUhIExldCdzIG1ha2UgdGhlbSBuZXZl
ciB1c2UgZWZpX3J0c193cS4NCg0KUmVnYXJkcywNClNhaQ0K
