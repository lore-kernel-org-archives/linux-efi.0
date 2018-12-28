From: "Prakhya, Sai Praneeth" <sai.praneeth.prakhya@intel.com>
Subject: RE: [PATCH] x86/efi: Don't unmap EFI boot services code/data
 regions for EFI_OLD_MEMMAP and EFI_MIXED_MODE
Date: Fri, 28 Dec 2018 21:27:55 +0000
Message-ID: <FFF73D592F13FD46B8700F0A279B802F48608DD1@ORSMSX114.amr.corp.intel.com>
References: <20181222022234.7573-1-sai.praneeth.prakhya@intel.com>
 <20181222105410.GA130780@gmail.com>
 <CAKv+Gu93dgfXsq_sRzvXBw-h=8pn2BtrQLtpwtjK51potpOtdg@mail.gmail.com>
 <CAKv+Gu8_9zMKhNyL=R7ZJHU=cFCkASVEOrm_4kqmTQG+7wPFbw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu8_9zMKhNyL=R7ZJHU=cFCkASVEOrm_4kqmTQG+7wPFbw@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Ingo Molnar <mingo@kernel.org>
Cc: linux-efi <linux-efi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, the arch/x86 maintainers <x86@kernel.org>, Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>, "Hansen, Dave" <dave.hansen@intel.com>, Bhupesh Sharma <bhsharma@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>
List-Id: linux-efi@vger.kernel.org

PiA+IEFja2VkLWJ5OiBBcmQgQmllc2hldXZlbCA8YXJkLmJpZXNoZXV2ZWxAbGluYXJvLm9yZz4N
Cj4gPg0KPiA+IHdpdGggdGhlIHNpZGVub3RlIHRoYXQgSSB3b24ndCBiZSBhYmxlIHRvIHRlc3Qg
dGhpcyBteXNlbGYgdW50aWwNCj4gPiBtb25kYXkgYXQgdGhlIGVhcmxpZXN0Lg0KPiANCj4gT0ss
IHNvIEkgaGF2ZSB0ZXN0ZWQgYm90aCBlZmk9b2xkX21hcCBhbmQgbWl4ZWQgbW9kZSBiZWZvcmUg
YW5kIGFmdGVyDQo+IGFwcGx5aW5nIHRoaXMgcGF0Y2gsIHVzaW5nIFFFTVUvS1ZNIHdpdGggNjQt
Yml0IGFuZCAzMi1iaXQgYnVpbGRzIG9mIE9WTUYNCj4gW3Jlc3BlY3RpdmVseV0NCj4gDQo+IGVm
aT1vbGRfbWFwIGlzIGluZGVlZCBicm9rZW4gYmVmb3JlIGFuZCBuZWVkcyB0aGlzIHBhdGNoLg0K
PiANCj4gTWl4ZWQgbW9kZSB3b3JrcyBqdXN0IGZpbmUgYm90aCBiZWZvcmUgYW5kIGFmdGVyIGFw
cGx5aW5nIHRoZSBwYXRjaCwgYnV0IEkNCj4gc3VnZ2VzdCB3ZSBrZWVwIHRoaXMgcGF0Y2ggYXMt
aXMgYW5kIGFkZHJlc3MgbWl4ZWQgbW9kZSBsYXRlciBpZiBuZWVkZWQgKEkNCj4gc3BvdHRlZCBh
IGNvdXBsZSBvZiB0aGluZ3MgaW4gdGhlIGJvb3QgbG9nIHRoYXQgbWF5IG5lZWQgc29tZSBhdHRl
bnRpb24gYnV0IEknbQ0KPiBub3Qgc3VyZSBpZiB0aGUgaXNzdWUgaXMgaW4gTGludXggb3IgaW4g
T1ZNRikNCg0KVGhhbmtzIGZvciB0ZXN0aW5nIHRoaXMgQXJkLg0KDQpGb3IgdGVzdGluZyBNaXhl
ZCBtb2RlLCBJIGhhdmUgdXNlZCBRRU1VL0tWTSB3aXRoIDY0LWJpdCBhbmQgMzItYml0IE9WTUYg
DQphbmQgbWl4ZWQgbW9kZSBpcyBicm9rZW4gZm9yIG1lIHdpdGhvdXQgdGhpcyBwYXRjaC4NCg0K
SSBhbSB1c2luZyBhbiBvbGRlciBPVk1GIGJ1aWxkIGFuZCBwcm9iYWJseSB0aGF0IG1pZ2h0IGJl
IHRoZSByZWFzb24gZm9yIHVzIHNlZWluZyANCmRpZmZlcmVudCBiZWhhdmlvcnMuIEFsc28sIGtl
cm5lbCBjb25maWcgZmlsZSBtaWdodCBoYXZlIHNvbWUgcm9sZSB0byBwbGF5Li4gSSBndWVzcy4N
Cg0KUmVnYXJkcywNClNhaQ0K
