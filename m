From: "Prakhya, Sai Praneeth" <sai.praneeth.prakhya@intel.com>
Subject: RE: [PATCH V2 2/6] x86/efi: Remove __init attribute from memory
 mapping functions
Date: Mon, 3 Sep 2018 08:15:48 +0000
Message-ID: <FFF73D592F13FD46B8700F0A279B802F485B9196@ORSMSX114.amr.corp.intel.com>
References: <1535881594-25469-1-git-send-email-sai.praneeth.prakhya@intel.com>
 <1535881594-25469-3-git-send-email-sai.praneeth.prakhya@intel.com>
 <20180902105602.GA19431@zn.tnic>
 <FFF73D592F13FD46B8700F0A279B802F485B9142@ORSMSX114.amr.corp.intel.com>
 <20180903071207.GA10249@zn.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180903071207.GA10249@zn.tnic>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>
Cc: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Neri, Ricardo" <ricardo.neri@intel.com>, "matt@codeblueprint.co.uk" <matt@codeblueprint.co.uk>, Lee Chun-Yi <jlee@suse.com>, Al Stone <astone@redhat.com>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Bhupesh Sharma <bhsharma@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

PiBPbiBNb24sIFNlcCAwMywgMjAxOCBhdCAwNTowMzo1NkFNICswMDAwLCBQcmFraHlhLCBTYWkg
UHJhbmVldGggd3JvdGU6DQo+ID4gSG1tLi4gdGhvdWdodCB0aGF0IF9fZWZpX2luaXQgbWlnaHQg
YmUgY29uZnVzaW5nIHdpdGggdGhlIG5vcm1hbA0KPiA+IF9faW5pdCBhdHRyaWJ1dGUNCj4gDQo+
IEhvdyB3b3VsZCB0aGF0IGJlIGNvbmZ1c2luZz8gSXQgaGFzICJfX2VmaSIgcHJlcGVuZGVkPyEN
Cj4gDQo+IEFsbCBJJ20gc2F5aW5nIGlzLCBpZiB5b3UncmUgZ29pbmcgdG8gZGVmaW5lIHlvdXIg
b3duIGZ1bmN0aW9uIGF0dHJpYnV0ZXMsIGRvIHRoZW0NCj4gZ2VuZXJpYyBhbmQgc2hvcnQuICJf
Zml4dXAiIGlzIHRvbyBzcGVjaWZpYyBJTU8uIEl0IGFsc28gZW5sYXJnZXMgZnVuY3Rpb24NCj4g
ZGVmaW5pdGlvbnMgdW5uZWNlc3NhcmlseS4NCj4gDQoNClllcy4uIGFncmVlZCB0aGF0IHRoZSBm
dW5jdGlvbiBkZWZpbml0aW9ucyBkaWQgZW5sYXJnZS4NCg0KPiBXaXRoICJfX2VmaV9pbml0IiB5
b3UgYWxyZWFkeSBkZW5vdGUgdGhhdCBpdCBpcyBhIHNwZWNpYWwgYXR0cmlidXRlIHdoaWNoIGhh
cw0KPiByZWxldmFuY2UgaW4gdGhlIEVGSSBjb2RlIG9ubHkuIFdoYXQgeW91IGRvIGFib3V0IGl0
IC0gdGhlDQo+ICpmaXh1cCogLSBpcyB0aGUgdGhpbmcgeW91IGRvIHdpdGggdGhlIGF0dHJpYnV0
ZS4gQnV0IHlvdSBkb24ndCBoYXZlIHRvIGhhdmUgdGhlDQo+ICJ3aGF0IHlvdSBkbyIgaW4gdGhl
IGF0dHJpYnV0ZSBuYW1lIHRvby4NCg0KT2suLiBtYWtlcyBzZW5zZS4gV2lsbCByb2xsIGEgVjMg
d2l0aCBfX2VmaV9pbml0Lg0KDQpSZWdhcmRzLA0KU2FpDQo=
