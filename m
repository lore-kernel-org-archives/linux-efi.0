From: Matthew Garrett <matthew.garrett@nebula.com>
Subject: Re: [PATCH] x86: Lock down MSR writing in secure boot
Date: Wed, 13 Feb 2013 05:39:22 +0000
Message-ID: <1360733962.18083.30.camel@x230.lan>
References: <dee64752-850c-4d78-b703-f47a985bc13e@email.android.com>
	  <CAGXu5jLAufTRm=sDST0br_WEkn4o0Hpjv2jDP2Na=cCvuM+MGg@mail.gmail.com>
	  <1360355671.18083.18.camel@x230.lan>
	  <CAGXu5jKo2PfMBO4A0ZgQcrPuj8OHNaff+CjAesOAWkZc0vB9+Q@mail.gmail.com>
	  <51157C9C.6030501@zytor.com> <20130208230655.GB28990@pd.tnic>
	  <1360366012.18083.21.camel@x230.lan> <5115A4CC.3080102@zytor.com>
	  <1360373383.18083.23.camel@x230.lan>
	  <CAGXu5j+xvJ3L5ejxtZ-Jw3F6rV7OsrE0_HZCGu_er0rH2_PwKA@mail.gmail.com>
	  <20130209092925.GA17728@pd.tnic> <1360422712.18083.24.camel@x230.lan>
	 <511AE2CC.5040705@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <511AE2CC.5040705@zytor.com>
Content-Language: en-US
Content-ID: <FE9E32B54B1E104786F2C25E4A42492B@namprd05.prod.outlook.com>
Sender: linux-security-module-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@alien8.de>, Kees Cook <keescook@chromium.org>, LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "x86@kernel.org" <x86@kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

T24gVHVlLCAyMDEzLTAyLTEyIGF0IDE2OjQ4IC0wODAwLCBILiBQZXRlciBBbnZpbiB3cm90ZToN
Cg0KPiBPSy4uLiB3aGF0IG5vbmUgb2YgdGhpcyBnZXRzIGludG86DQo+IA0KPiBXaHkgc2hvdWxk
IENBUF9SQVdJTyBiZSBhbGxvd2VkIG9uIGEgc2VjdXJlIGJvb3Qgc3lzdGVtLCB3aGVuIHRoZXJl
IGFyZQ0KPiAyXm4ga25vd24gd2F5cyBvZiBjb21wcm9taXNlIGEgc3lzdGVtIHdpdGggQ0FQX1JB
V0lPPw0KDQpDQVBfU1lTX1JBV0lPIHNlZW1zIHRvIGhhdmUgZW5kZWQgdXAgYmVpbmcgYSBjYXRj
aGFsbCBvZiAiTWF5YmUgc29tZW9uZQ0Kd2hvIGlzbid0IGVudGlyZWx5IHJvb3Qgc2hvdWxkIGJl
IGFibGUgdG8gZG8gdGhpcyIsIGFuZCBub3QgZXZlcnl0aGluZw0KaXQgY292ZXJzIGlzIGVxdWl2
YWxlbnQgdG8gYmVpbmcgYWJsZSB0byBjb21wcm9taXNlIHRoZSBydW5uaW5nIGtlcm5lbC4NCkkg
d291bGRuJ3QgYXJndWUgd2l0aCB0aGUgaWRlYSB0aGF0IG1heWJlIHdlIHNob3VsZCBqdXN0IHJl
YXBwcmFpc2UgbW9zdA0Kb2YgdGhlIGN1cnJlbnQgdXNlcyBvZiBDQVBfU1lTX1JBV0lPLCBidXQg
cmVtb3ZpbmcgY2FwYWJpbGl0eSBjaGVja3MNCmZyb20gcGxhY2VzIHRoYXQgY3VycmVudGx5IGhh
dmUgdGhlbSBzZWVtcyBsaWtlIGFuIGludml0YXRpb24gZm9yDQp1c2Vyc3BhY2UgYnJlYWthZ2Uu
DQo=

