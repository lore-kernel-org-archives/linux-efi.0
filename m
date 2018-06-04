From: "Prakhya, Sai Praneeth" <sai.praneeth.prakhya@intel.com>
Subject: RE: [PATCH V5 0/3] Use efi_rts_wq to invoke EFI Runtime Services
Date: Mon, 4 Jun 2018 04:27:34 +0000
Message-ID: <FFF73D592F13FD46B8700F0A279B802F3B6EABDF@ORSMSX114.amr.corp.intel.com>
References: <1527560464-19466-1-git-send-email-sai.praneeth.prakhya@intel.com>
 <CAFoFrHYcD7fGYaJzKwcPCtu+XyR+mh5ORDqmCpiBjLmEkDfwOQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAFoFrHYcD7fGYaJzKwcPCtu+XyR+mh5ORDqmCpiBjLmEkDfwOQ@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Naresh Bhat <naresh.bhat@linaro.org>
Cc: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Lee Chun-Yi <jlee@suse.com>, Borislav Petkov <bp@alien8.de>, "Luck, Tony" <tony.luck@intel.com>, Will Deacon <will.deacon@arm.com>, "Hansen, Dave" <dave.hansen@intel.com>, Mark Rutland <mark.rutland@arm.com>, Bhupesh Sharma <bhsharma@redhat.com>, "Neri, Ricardo" <ricardo.neri@intel.com>, Peter Zijlstra <peterz@infradead.org>, "Shankar, Ravi V" <ravi.v.shankar@intel.com>, Matt Fleming <matt@codeblueprint.co.uk>, "Williams, Dan J" <dan.j.williams@intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, "Nair, Jayachandran" <Jayachandran.Nair@cavium.com>
List-Id: linux-efi@vger.kernel.org

PiA+IFRlc3Rpbmc6DQo+ID4gLS0tLS0tLS0NCj4gPiBUZXN0ZWQgdXNpbmcgTFVWIChMaW51eCBV
RUZJIFZhbGlkYXRpb24pIGZvciB4ODZfNjQsIHg4Nl8zMiBhbmQgYXJtNjQNCj4gPiAocWVtdSBv
bmx5KS4gV2lsbCBhcHByZWNpYXRlIHRoZSBlZmZvcnQgaWYgc29tZW9uZSBjb3VsZCB0ZXN0IHRo
ZQ0KPiA+IHBhdGNoZXMgb24gcmVhbCBBUk0vQVJNNjQgbWFjaGluZXMuDQo+ID4gTFVWOiBodHRw
czovLzAxLm9yZy9saW51eC11ZWZpLXZhbGlkYXRpb24NCj4gDQo+IEkgaGF2ZSB0ZXN0ZWQgVjQg
c2VyaWVzIG9uIFRodW5kZXJYMiBWYWwxIGFuZCBTYWJlciBwbGF0Zm9ybSBieSBpbnRlZ3JhdGlu
ZyB0aGUNCj4gcGF0Y2hlcyB3aXRoIExVViBwcm9qZWN0Lg0KPiBJIHdpbGwgdGVzdCBWNSB2ZXJz
aW9uIHNvb24gYW5kIGxldCB5b3Uga25vdyB0aGUgb3V0Y29tZS4NCg0KVGhhbmtzIGEgbG90ISBm
b3IgdGFraW5nIHRpbWUgdG8gdGVzdCB0aGUgcGF0Y2ggc2V0LCBOYXJlc2guIFdpbGwgYmUgd2Fp
dGluZyB0byBzZWUgdGhlIHJlc3VsdC4NCg0KUmVnYXJkcywNClNhaQ0K
