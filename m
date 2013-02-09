From: Matthew Garrett <matthew.garrett@nebula.com>
Subject: Re: [PATCH] x86: Lock down MSR writing in secure boot
Date: Sat, 9 Feb 2013 01:29:44 +0000
Message-ID: <1360373383.18083.23.camel@x230.lan>
References: <20130208191213.GA25081@www.outflux.net>
	  <00780235-deac-4f80-b936-867834e05661@email.android.com>
	  <CAGXu5jJnLY6Qp3J6HBpVg-AdUGdKYm-e4wErZO3=NuRo04ajvg@mail.gmail.com>
	  <5115553A.5000708@zytor.com>
	  <CAGXu5j+_mGzR+72YqORhErMUY1aF1H2urczZ8SwuJHZK-oZL6g@mail.gmail.com>
	  <dee64752-850c-4d78-b703-f47a985bc13e@email.android.com>
	  <CAGXu5jLAufTRm=sDST0br_WEkn4o0Hpjv2jDP2Na=cCvuM+MGg@mail.gmail.com>
	  <1360355671.18083.18.camel@x230.lan>
	  <CAGXu5jKo2PfMBO4A0ZgQcrPuj8OHNaff+CjAesOAWkZc0vB9+Q@mail.gmail.com>
	  <51157C9C.6030501@zytor.com> <20130208230655.GB28990@pd.tnic>
	 <1360366012.18083.21.camel@x230.lan> <5115A4CC.3080102@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <5115A4CC.3080102@zytor.com>
Content-Language: en-US
Content-ID: <E80C690A62C21E4989B0E129D6CA9BAA@namprd05.prod.outlook.com>
Sender: linux-security-module-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@alien8.de>, Kees Cook <keescook@chromium.org>, LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "x86@kernel.org" <x86@kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

T24gRnJpLCAyMDEzLTAyLTA4IGF0IDE3OjIyIC0wODAwLCBILiBQZXRlciBBbnZpbiB3cm90ZToN
Cg0KPiBZb3UgZG9uJ3QgaGF2ZSB0byBidWlsZCB0aGUga2VybmVsIHR3aWNlIHRvIGV4Y2x1ZGUg
YSBsb2FkYWJsZSBtb2R1bGUuDQoNCkkgZ3Vlc3MgeW91IGNvdWxkIGp1c3Qgc3RyaXAgdGhlIHNp
Z25hdHVyZXMgb2ZmIGFueSBtb2R1bGVzIHlvdSBkb24ndA0Kd2FudCB0byBzdXBwb3J0IHVuZGVy
IFNlY3VyZSBCb290LCBidXQgdGhhdCBicmVha3Mgc29tZSBvdGhlciB1c2UgY2FzZXMuDQoNCg==

