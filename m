From: "Prakhya, Sai Praneeth" <sai.praneeth.prakhya@intel.com>
Subject: RE: [PATCH 1/2] x86/efi: Unmap efi boot services code/data regions
 from efi_pgd
Date: Mon, 22 Oct 2018 17:35:36 +0000
Message-ID: <FFF73D592F13FD46B8700F0A279B802F485D5D88@ORSMSX114.amr.corp.intel.com>
References: <1540172145-17134-1-git-send-email-sai.praneeth.prakhya@intel.com>
 <1540172145-17134-2-git-send-email-sai.praneeth.prakhya@intel.com>
 <20181022015738.GB24095@gmail.com>
 <CALCETrW=M8u=F6USUk3t_sucGnU-8K6sLYOq6BGK1JhPdgjzdw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrW=M8u=F6USUk3t_sucGnU-8K6sLYOq6BGK1JhPdgjzdw@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@kernel.org>
Cc: linux-efi <linux-efi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>, Borislav Petkov <bp@alien8.de>, "Hansen, Dave" <dave.hansen@intel.com>, Bhupesh Sharma <bhsharma@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Peter Zijlstra <peterz@infradead.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>
List-Id: linux-efi@vger.kernel.org

PiA+IFRoZSBvbmUgYml0IHRoYXQgaXMgb2RkIGlzIHRoZSBjcGEtPnBmbiBmaWVsZCAtIGZvciB1
bm1hcHBlZCBwYWdlcw0KPiA+IHRoYXQncyB0b3RhbGx5IHVuaW50ZXJlc3RpbmcgYW5kIEknbSB3
b25kZXJpbmcgd2hldGhlciBzZXR0aW5nIGl0IHRvIDANCj4gPiB3b3VsZG4ndCBiZSBiZXR0ZXIu
DQo+ID4NCj4gPiBEb2VzIHRoZSBDUFUgX2V2ZXJfIGxvb2sgbG9vayBhdCB0aGUgUEZOIGlmIHRo
ZSBwYWdlIGlzDQo+ID4gIV9QQUdFX1BSRVNFTlQsIGZvciBleGFtcGxlIHNwZWN1bGF0aXZlbHk/
IElmIHllcyB0aGVuIHdoYXQgaXMgdGhlDQo+ID4gcmVjb21tZW5kZWQgdmFsdWUgZm9yIHRoZSBw
Zm4gLSB6ZXJvIHBlcmhhcHM/DQo+ID4NCj4gDQo+IFRoaXMgaXMgTDFURiwgcmlnaHQ/ICBJc24n
dCBhbGwgb25lcyB0aGUgcmVjb21tZW5kZWQgdmFsdWU/DQo+IA0KPiBJIHdvdWxkIGxvdmUgdG8g
c2VlIEVGSSBzdGFydCB0cmVhdGluZyBpdHMgbW0ganVzdCBsaWtlIGFueSBvdGhlciBtbSBhdCBz
b21lDQo+IHBvaW50LCB0aG91Z2guICBUaGF0IGlzLCBpdCBzaG91bGQgbm90IG1vZGlmeSBhbnkg
bWFwcGluZ3MgaW4gdGhlIGtlcm5lbCByYW5nZSwNCj4gYW5kIGl0IGNvdWxkIHVzZSB0aGUgcmVn
dWxhciBtbSBtb2RpZmljYXRpb24gQVBJcyBmb3IgdGhlIHVzZXIgcmFuZ2UuICBCdXQgbWF5YmUN
Cj4gdGhpcyBpcyBhIHBpcGUgZHJlYW0uDQoNClNvdW5kcyBnb29kIHRvIG1lLiBJIGhhdmUgc29t
ZSBtb3JlIGZpeGVzIGZvciBFRkkgY29kZSBhbmQgYXMgc29vbiBhcyB0aGV5IGFyZSBkb25lLCAN
Ckkgd2lsbCBzdGFydCBsb29raW5nIGludG8gdGhpcy4NCg0KUmVnYXJkcywNClNhaQ0K
