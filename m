From: "Prakhya, Sai Praneeth" <sai.praneeth.prakhya@intel.com>
Subject: RE: [PATCH 1/2] x86/efi: Unmap efi boot services code/data regions
 from efi_pgd
Date: Mon, 22 Oct 2018 17:36:48 +0000
Message-ID: <FFF73D592F13FD46B8700F0A279B802F485D5D95@ORSMSX114.amr.corp.intel.com>
References: <1540172145-17134-1-git-send-email-sai.praneeth.prakhya@intel.com>
 <1540172145-17134-2-git-send-email-sai.praneeth.prakhya@intel.com>
 <20181022015738.GB24095@gmail.com>
 <f88841ec-e104-fa8b-0be6-7418c7bf5161@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <f88841ec-e104-fa8b-0be6-7418c7bf5161@intel.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Hansen, Dave" <dave.hansen@intel.com>, Ingo Molnar <mingo@kernel.org>
Cc: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>, Bhupesh Sharma <bhsharma@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Peter Zijlstra <peterz@infradead.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>
List-Id: linux-efi@vger.kernel.org

PiBPbiAxMC8yMS8yMDE4IDA2OjU3IFBNLCBJbmdvIE1vbG5hciB3cm90ZToNCj4gPiBEb2VzIHRo
ZSBDUFUgX2V2ZXJfIGxvb2sgbG9vayBhdCB0aGUgUEZOIGlmIHRoZSBwYWdlIGlzDQo+ID4gIV9Q
QUdFX1BSRVNFTlQsIGZvciBleGFtcGxlIHNwZWN1bGF0aXZlbHk/IElmIHllcyB0aGVuIHdoYXQg
aXMgdGhlDQo+ID4gcmVjb21tZW5kZWQgdmFsdWUgZm9yIHRoZSBwZm4gLSB6ZXJvIHBlcmhhcHM/
DQo+IA0KPiBJJ2xsIG5ldmVyIHNheSBuZXZlci4gOikNCj4gDQo+IEZvciBMMVRGWzFdLCB3ZSBr
bm93IHRoZSBDUFUgZGlkIGV4YWN0bHkgdGhpczsgaXQgaWdub3JlZCB0aGUgX1BBR0VfUFJFU0VO
VA0KPiBiaXQgd2hlbiBmZXRjaGluZyBkYXRhIGZyb20gdGhlIEwxLiAgVGhhdCdzIHdoYXQgaXMg
d29ya2VkIGFyb3VuZCB3aXRoIHRoZSBndW5rDQo+IGluIGFyY2gveDg2L2luY2x1ZGUvYXNtL3Bn
dGFibGUtaW52ZXJ0LmguDQo+IA0KPiBJIHRoaW5rIEFuZGkgcGx1Z2dlZCB0aGUgY29kZSBpbiBo
ZXJlIGF0IGEgbG93IGVub3VnaCBsZXZlbCBpbiB0aGUgcGFnZSB0YWJsZQ0KPiBtYW5pcHVsYXRp
b24gdGhhdCBwYWdlYXR0ci5jIHNob3VsZCBpbmhlcml0IGl0IHdpdGhvdXQgZG9pbmcgYW55dGhp
bmcgZXhwbGljaXQuDQo+IEJ1dCwgU2FpLCB5b3UgbWlnaHQgd2FudCB0byBkb3VibGUtY2hlY2sg
dGhpcy4NCj4gDQo+IDEuDQo+IGh0dHBzOi8vd3d3LmludGVsLmNvbS9jb250ZW50L3d3dy91cy9l
bi9hcmNoaXRlY3R1cmUtYW5kLQ0KPiB0ZWNobm9sb2d5L2wxdGYuaHRtbA0KDQpTdXJlISBEYXZl
LiBUaGFua3MgZm9yIHRoZSBsaW5rLiBJIHdpbGwgdGFrZSBhIGxvb2sgYXQgaXQuDQoNClJlZ2Fy
ZHMsDQpTYWkNCg==
