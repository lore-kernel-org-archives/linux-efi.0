From: "Prakhya, Sai Praneeth" <sai.praneeth.prakhya@intel.com>
Subject: RE: [PATCH V5 0/3] Use efi_rts_wq to invoke EFI Runtime Services
Date: Fri, 1 Jun 2018 19:38:33 +0000
Message-ID: <FFF73D592F13FD46B8700F0A279B802F3B53A8E4@ORSMSX114.amr.corp.intel.com>
References: <1527560464-19466-1-git-send-email-sai.praneeth.prakhya@intel.com>
 <CAKv+Gu_Wy2=8eC3U5Xuj_4CLsFmgQoeq34RPVaPOusvMA2i-7Q@mail.gmail.com>
 <CACi5LpOk6e+=Ly4r4WP+Mriq5ThAcnU2UJ8Eupz4gCTfeYB71A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CACi5LpOk6e+=Ly4r4WP+Mriq5ThAcnU2UJ8Eupz4gCTfeYB71A@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Bhupesh Sharma <bhsharma@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Lee Chun-Yi <jlee@suse.com>, Borislav Petkov <bp@alien8.de>, "Luck, Tony" <tony.luck@intel.com>, Will Deacon <will.deacon@arm.com>, "Hansen, Dave" <dave.hansen@intel.com>, Mark Rutland <mark.rutland@arm.com>, Naresh Bhat <naresh.bhat@linaro.org>, "Neri, Ricardo" <ricardo.neri@intel.com>, Peter Zijlstra <peterz@infradead.org>, "Shankar, Ravi V" <ravi.v.shankar@intel.com>, Matt Fleming <matt@codeblueprint.co.uk>, "Williams, Dan J" <dan.j.williams@intel.com>, Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
List-Id: linux-efi@vger.kernel.org

PiA+PiBUZXN0aW5nOg0KPiA+PiAtLS0tLS0tLQ0KPiA+PiBUZXN0ZWQgdXNpbmcgTFVWIChMaW51
eCBVRUZJIFZhbGlkYXRpb24pIGZvciB4ODZfNjQsIHg4Nl8zMiBhbmQgYXJtNjQNCj4gPj4gKHFl
bXUgb25seSkuIFdpbGwgYXBwcmVjaWF0ZSB0aGUgZWZmb3J0IGlmIHNvbWVvbmUgY291bGQgdGVz
dCB0aGUNCj4gPj4gcGF0Y2hlcyBvbiByZWFsIEFSTS9BUk02NCBtYWNoaW5lcy4NCj4gDQo+IEkg
d291bGQgZ2l2ZSB0aGUgbGF0ZXN0IHY1IGEgdHJ5IG9uIG15IEFSTTY0IHF1YWxjb21tIGJvYXJk
IGFzIHdlbGwuDQo+IFdJbGwgZ2V0IGJhY2sgd2l0aCB0aGUgdGVzdCByZXN1bHRzIHNvb24uDQo+
IA0KDQpTdXJlISBUZXN0aW5nIGlzIGFsd2F5cyB3ZWxjb21lZCA6KQ0KYW5kIGlmIHlvdSBnZXQg
YSBjaGFuY2UgcGxlYXNlIHRyeSBvbiBVVjMwMCBtYWNoaW5lIHRvby4uIChwcm9iYWJseSBpdCBt
aWdodCBmaW5kIGlzc3VlcyANCmFzIGhhcHBlbmVkIHdpdGggbW1fc3RydWN0IHBhdGNoZXMpLg0K
DQpSZWdhcmRzLA0KU2FpDQo=
