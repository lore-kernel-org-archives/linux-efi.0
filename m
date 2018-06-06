From: "Prakhya, Sai Praneeth" <sai.praneeth.prakhya@intel.com>
Subject: RE: [PATCH V5 0/3] Use efi_rts_wq to invoke EFI Runtime Services
Date: Wed, 6 Jun 2018 17:24:34 +0000
Message-ID: <FFF73D592F13FD46B8700F0A279B802F3B8BBBB8@ORSMSX114.amr.corp.intel.com>
References: <1527560464-19466-1-git-send-email-sai.praneeth.prakhya@intel.com>
 <CAFoFrHYcD7fGYaJzKwcPCtu+XyR+mh5ORDqmCpiBjLmEkDfwOQ@mail.gmail.com>
 <FFF73D592F13FD46B8700F0A279B802F3B6EABDF@ORSMSX114.amr.corp.intel.com>
 <CAFoFrHbOkKpfrt-NVX9wm49aR1Mv7dXLVrDuXGQPiD0ZNbvyrw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAFoFrHbOkKpfrt-NVX9wm49aR1Mv7dXLVrDuXGQPiD0ZNbvyrw@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Naresh Bhat <naresh.bhat@linaro.org>
Cc: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Lee Chun-Yi <jlee@suse.com>, Borislav Petkov <bp@alien8.de>, "Luck, Tony" <tony.luck@intel.com>, Will Deacon <will.deacon@arm.com>, "Hansen, Dave" <dave.hansen@intel.com>, Mark Rutland <mark.rutland@arm.com>, Bhupesh Sharma <bhsharma@redhat.com>, "Neri, Ricardo" <ricardo.neri@intel.com>, Peter Zijlstra <peterz@infradead.org>, "Shankar, Ravi V" <ravi.v.shankar@intel.com>, Matt Fleming <matt@codeblueprint.co.uk>, "Williams, Dan J" <dan.j.williams@intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, "Nair, Jayachandran" <Jayachandran.Nair@cavium.com>
List-Id: linux-efi@vger.kernel.org

PiA+PiBJIGhhdmUgdGVzdGVkIFY0IHNlcmllcyBvbiBUaHVuZGVyWDIgVmFsMSBhbmQgU2FiZXIg
cGxhdGZvcm0gYnkNCj4gPj4gaW50ZWdyYXRpbmcgdGhlIHBhdGNoZXMgd2l0aCBMVVYgcHJvamVj
dC4NCj4gPj4gSSB3aWxsIHRlc3QgVjUgdmVyc2lvbiBzb29uIGFuZCBsZXQgeW91IGtub3cgdGhl
IG91dGNvbWUuDQo+ID4NCj4gPiBUaGFua3MgYSBsb3QhIGZvciB0YWtpbmcgdGltZSB0byB0ZXN0
IHRoZSBwYXRjaCBzZXQsIE5hcmVzaC4gV2lsbCBiZSB3YWl0aW5nIHRvDQo+IHNlZSB0aGUgcmVz
dWx0Lg0KPiANCj4gU2FpLCBJIGRpZCB1cGdyYWRlIExVViBrZXJuZWwgdG8gdjQuMTcsIGFwcGx5
IGFuZCB0ZXN0IHlvdXIgcGF0Y2hlcyBieSBydW5uaW5nDQo+IExVViBvbiBRRU1VIGFuZCBUaHVu
ZGVyWDIgaGFyZHdhcmUuIEFsbCBlZmkgdGVzdCByZXN1bHRzIGxvb2tzIG9rLg0KDQpUaGFua3Mg
YSBsb3QhIGZvciB0aGUgdXBkYXRlIDopDQoNCj4gQnV0IGFzIEFyZCBwb2ludGVkLCBJIGFsc28g
bm90aWNlZCBoYW5nIGlzc3VlIGFmdGVyIGV4ZWN1dGluZyByZWJvb3QgY29tbWFuZCBvbiBjb25z
b2xlDQo+IG9uIHJlYWwgaGFyZHdhcmUuDQoNCkFyZCBoYXMgZml4ZWQgdGhlIGlzc3VlIGJlZm9y
ZSBhcHBseWluZyBhbmQgdGhlIGxhdGVzdCBwYXRjaGVzIGNhbiBiZSBmb3VuZCBhdDoNCmh0dHBz
Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L2VmaS9lZmkuZ2l0L2xv
Zy8/aD1uZXh0DQoNClJlZ2FyZHMsDQpTYWkNCg==
