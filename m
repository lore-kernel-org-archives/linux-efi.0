From: Matthew Garrett <matthew.garrett@nebula.com>
Subject: Re: [PATCH] x86: Lock down MSR writing in secure boot
Date: Wed, 13 Feb 2013 06:27:40 +0000
Message-ID: <1360736860.18083.33.camel@x230.lan>
References: <dee64752-850c-4d78-b703-f47a985bc13e@email.android.com>
	   <CAGXu5jLAufTRm=sDST0br_WEkn4o0Hpjv2jDP2Na=cCvuM+MGg@mail.gmail.com>
	   <1360355671.18083.18.camel@x230.lan>
	   <CAGXu5jKo2PfMBO4A0ZgQcrPuj8OHNaff+CjAesOAWkZc0vB9+Q@mail.gmail.com>
	   <51157C9C.6030501@zytor.com> <20130208230655.GB28990@pd.tnic>
	   <1360366012.18083.21.camel@x230.lan> <5115A4CC.3080102@zytor.com>
	   <1360373383.18083.23.camel@x230.lan>
	   <CAGXu5j+xvJ3L5ejxtZ-Jw3F6rV7OsrE0_HZCGu_er0rH2_PwKA@mail.gmail.com>
	   <20130209092925.GA17728@pd.tnic> <1360422712.18083.24.camel@x230.lan>
	  <511AE2CC.5040705@zytor.com> <1360733962.18083.30.camel@x230.lan>
	 <511B2EB9.5070406@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <511B2EB9.5070406@zytor.com>
Content-Language: en-US
Content-ID: <DEEF580DB97AA647AA3C3EC974EB9437@namprd05.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@alien8.de>, Kees Cook <keescook@chromium.org>, LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "x86@kernel.org" <x86@kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

T24gVHVlLCAyMDEzLTAyLTEyIGF0IDIyOjEyIC0wODAwLCBILiBQZXRlciBBbnZpbiB3cm90ZToN
Cg0KPiBTb3VuZHMgbGlrZSB5b3UgYXJlIHRoaW5raW5nIG9mIENBUF9TWVNfQURNSU4sIGJ1dCBJ
IGRvbid0IHJlYWxseSBzZWUgYSANCj4gaHVnZSBkaWZmZXJlbmNlIGJldHdlZW4gTVNScyBhbmQg
SS9PIGNvbnRyb2wgcmVnaXN0ZXJzLi4uIGp1c3QgZGlmZmVyZW50IA0KPiBhZGRyZXNzIHNwYWNl
cy4NCg0KTm90IGhhdmluZyBDQVBfU1lTX1JBV0lPIGJsb2NrcyB2YXJpb3VzIFNDU0kgY29tbWFu
ZHMsIGZvciBpbnN0YW5jZS4NClRoZXNlIG1pZ2h0IHJlc3VsdCBpbiB0aGUgYWJpbGl0eSB0byB3
cml0ZSBpbmRpdmlkdWFsIGJsb2NrcyBvciBkZXN0cm95DQp0aGUgZGV2aWNlIGZpcm13YXJlLCBi
dXQgZG8gYW55IG9mIHRoZW0gcGVybWl0IG1vZGlmeWluZyB0aGUgcnVubmluZw0Ka2VybmVsPw0K
