Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [80.241.56.161])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDA3F4848AC;
	Fri, 18 Sep 2026 14:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.161
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789741690; cv=none; b=B9JEFrMR2P7ELXPvmvDNyuplQ+6l+zQL96RBus0EHzo0f9uXgR4Wsd9rQrWIbg5ww+KOsEb7mtSPphG4RiOiG8DR9OdBOk0C3CAoYfwQJmoTy+CvBMjGCPoyvn6C82WrBzW/4rpjWCapRuZou0bAyUKCQiNyUoTQXxhDt16EHIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789741690; c=relaxed/simple;
	bh=3LJNpJj2ubKY+C6Gxo12BSDq3Lod0zkfHV93NdYf+qg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=inYv1mZ8sNE+oi1MWJJQiUvNDHhYa7aqwBBFWl10do/Cp3Pez1n2B/lj/rwmqGYaOxtcWxxxSQeewO+PGGsoSEM2Vmw5rnLqqLwE75ueDZQnQ2+X3tP+8DkeWm1VycV+kLGpjh6s49N+j5EDNJxsLgaayYwk89cnPuNLNqBdMXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org; spf=pass smtp.mailfrom=mailbox.org; dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b=QtQBRhqN; arc=none smtp.client-ip=80.241.56.161
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mailbox.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b="QtQBRhqN"
Received: from smtp102.mailbox.org (smtp102.mailbox.org [10.196.197.102])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4hmZjH5DLCzKnWZ;
	Fri, 18 Sep 2026 16:28:03 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1789741683;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3LJNpJj2ubKY+C6Gxo12BSDq3Lod0zkfHV93NdYf+qg=;
	b=QtQBRhqNjHsK/KLhhot0vgb22pcbL20fdA0WwoYksT3T9wduucrJo+jcYJnebwXZr5sWqz
	XpRtntf190GGKdWxJOpehJ8W8ytiDbniY9HYejEckdfmUmZY2QhL8wAGHZ5FBJ1Gvf4c+Q
	nXw8Mr75M3VgMxUwddbSFlLVDI0HGscVW76eQzA8VSWYO27qQ56HcPpHkbI7AxQxWIFVD5
	8Rm9Afyo6V9Vpe8ZkLAtK5umIu0Aqo4hdfGPO8uj00nY/cLCnRK/lBEKLQpTa7Z8KPQ2XW
	fw/m3qVq5qXNiDXeyzuhqRJ/2zttPxoPOc0uXfYXXAhkwZEDnGxIjHisL0Zh1g==
Message-ID: <3be3dca3bee5695972e5419a1198bfee40a1ede7.camel@mailbox.org>
Subject: Re: [PATCH v3 20/20] kbuild: compress the kernel with pigz if
 available
From: Manuel Ebner <manuelebnerli@mailbox.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Linus Torvalds	
 <torvalds@linux-foundation.org>, Nathan Chancellor <nathan@kernel.org>, 
 Nicolas Schier	 <nsc@kernel.org>, Nick Desaulniers
 <ndesaulniers@google.com>, Bill Wendling	 <morbo@google.com>, Justin Stitt
 <justinstitt@google.com>, Masahiro Yamada	 <masahiroy@kernel.org>, Alexey
 Gladkov <legion@kernel.org>, Thomas Gleixner	 <tglx@kernel.org>, Ingo
 Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,  Dave Hansen
 <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin"
 <hpa@zytor.com>, Paul Walmsley	 <pjw@kernel.org>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou	 <aou@eecs.berkeley.edu>, Alexandre Ghiti
 <alex@ghiti.fr>, Arnd Bergmann	 <arnd@arndb.de>, Catalin Marinas
 <catalin.marinas@arm.com>, Will Deacon	 <will@kernel.org>, Mark Rutland
 <mark.rutland@arm.com>, Ard Biesheuvel	 <ardb@kernel.org>, Ilias Apalodimas
 <ilias.apalodimas@linaro.org>, Josh Poimboeuf <jpoimboe@kernel.org>, Peter
 Zijlstra <peterz@infradead.org>, Miguel Ojeda <ojeda@kernel.org>,  Boqun
 Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>,
 =?ISO-8859-1?Q?Bj=F6rn?= Roy Baron	 <bjorn3_gh@protonmail.com>, Benno
 Lossin <lossin@kernel.org>, Andreas Hindborg	 <a.hindborg@kernel.org>,
 Alice Ryhl <aliceryhl@google.com>, Trevor Gross	 <tmgross@umich.edu>,
 Danilo Krummrich <dakr@kernel.org>, Daniel Almeida	
 <daniel.almeida@collabora.com>, Tamir Duberstein <tamird@kernel.org>, 
 Alexandre Courbot <acourbot@nvidia.com>, Onur =?ISO-8859-1?Q?=D6zkan?=
 <work@onurozkan.dev>, Jonathan Corbet	 <corbet@lwn.net>, Randy Dunlap
 <rdunlap@infradead.org>, Kees Cook	 <kees@kernel.org>, "Gustavo A. R.
 Silva" <gustavoars@kernel.org>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	llvm@lists.linux.dev, linux-riscv@lists.infradead.org, 
	linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-efi@vger.kernel.org, rust-for-linux@vger.kernel.org, 
	linux-doc@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, 
	linux-hardening@vger.kernel.org
Date: Fri, 18 Sep 2026 16:27:39 +0200
In-Reply-To: <20260917-build-speedup-v3-20-9ecf4163ff36@kernel.org>
References: <20260917-build-speedup-v3-0-9ecf4163ff36@kernel.org>
	 <20260917-build-speedup-v3-20-9ecf4163ff36@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MBO-RS-ID: ce8f960d02e65de3df1
X-MBO-RS-META: nxxf3yfsm46sstto1rq96gpwcat4iu3u

SGkgTG9yZW56bywKCk9uIFRodSwgMjAyNi0wOS0xNyBhdCAxNzowNiArMDEwMCwgTG9yZW56byBT
dG9ha2VzIChBUk0pIHdyb3RlOgo+IFRoZSBnemlwIHN0ZXAgb2YgYSBrZXJuZWwgYnVpbGQgaXMg
dmVyeSBsZW5ndGh5LCBlc3BlY2lhbGx5IGZvciBsYXJnZXIKPiBidWlsZHMgc3VjaCBhcyBhbGxt
b2Rjb25maWcuCj4gCj4gLi4uCj4gCj4gV2hvbGUgYnVpbGQsIDEyOC10aHJlYWQgVGhyZWFkcmlw
cGVyIDk5ODBYLCBiZXN0IG9mIE4gcnVuczoKPiAKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBi
ZWZvcmXCoMKgIGFmdGVywqDCoMKgwqAgZGVsdGEKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAt
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tCj4gwqAgeDg2IGRlZmNvbmZpZywgdG91Y2gg
bW0vdm1hLmMsIGdjY8KgwqDCoMKgwqDCoMKgIDcuN3PCoMKgwqDCoCA2LjBzwqDCoMKgwqAgLTEu
N3MgKC0yMiUpCj4gwqAgeDg2IGRlZmNvbmZpZywgdG91Y2ggbW0vdm1hLmMsIGNsYW5nwqDCoMKg
wqDCoCA2LjlzwqDCoMKgwqAgNS40c8KgwqDCoMKgIC0xLjVzICgtMjElKQo+IMKgIHg4NiBkZWZj
b25maWcsIGNsZWFuLCBnY2PCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgMjguMnPCoMKg
wqAgMjYuM3PCoMKgwqDCoCAtMS44cyAoLTYlKQo+IMKgIHg4NiBkZWZjb25maWcsIGNsZWFuLCBj
bGFuZ8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIDI4LjdzwqDCoMKgIDI3LjJzwqDCoMKgwqAg
LTEuNXMgKC01JSkKPiDCoCB4ODYgYWxsbW9kY29uZmlnLCB0b3VjaCBtbS92bWEuYywgZ2NjwqDC
oMKgIDIzLjdzwqDCoMKgIDE1LjRzwqDCoMKgwqAgLTguM3MgKC0zNSUpCj4gwqAgeDg2IGFsbG1v
ZGNvbmZpZywgdG91Y2ggbW0vdm1hLmMsIGNsYW5nwqAgMjIuNXPCoMKgwqAgMTUuNnPCoMKgwqDC
oCAtNy4wcyAoLTMxJSkKPiDCoCB4ODYgYWxsbW9kY29uZmlnLCBjbGVhbiwgZ2NjwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoCAyOTQuMXPCoMKgIDI3OC42c8KgwqDCoMKgIC0xNS41cyAoLTUlKQo+IMKg
IHg4NiBhbGxtb2Rjb25maWcsIGNsZWFuLCBjbGFuZ8KgwqDCoMKgwqDCoMKgwqDCoCAyODMuOXPC
oMKgIDI2Ni44c8KgwqDCoMKgIC0xNy4xcyAoLTYlKQoKVGhhdCdzIGdvb2QgdG8gaGVhci4KCgo+
IFN1Z2dlc3RlZC1ieTogS2VlcyBDb29rIDxrZWVzQGtlcm5lbC5vcmc+Cj4gTGluazogaHR0cHM6
Ly96bGliLm5ldC9waWd6Lwo+IEFzc2lzdGVkLWJ5OiBMTE0KPiBTaWduZWQtb2ZmLWJ5OiBMb3Jl
bnpvIFN0b2FrZXMgKEFSTSkgPGxqc0BrZXJuZWwub3JnPgo+IC0tLQo+IMKgRG9jdW1lbnRhdGlv
bi9rYnVpbGQva2J1aWxkLnJzdMKgwqAgfCAxNyArKysrKysrKysrKysrKysrKwo+IMKgRG9jdW1l
bnRhdGlvbi9wcm9jZXNzL2NoYW5nZXMucnN0IHzCoCA4ICsrKysrKysrCj4gwqBNYWtlZmlsZcKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHzCoCA1ICsr
KystCj4gwqBrZXJuZWwvTWFrZWZpbGXCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqAgfMKgIDYgKysrKystCj4gwqBzY3JpcHRzL01ha2VmaWxlLmxpYsKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgIHzCoCA0ICsrLS0KClBsZWFzZSBhZGQgYSBsaW5lIHRvCnNjcmlwdHMvdmVyX2xp
bnV4Cgo+IMKgc2NyaXB0cy9qb2JzZXJ2ZXItZXhlY8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAgfMKg
IDMgKystCj4gwqB0b29scy9saWIvcHl0aG9uL2pvYnNlcnZlci5wecKgwqDCoMKgIHwgMTMgKysr
KysrKysrKysrKwo+IMKgNyBmaWxlcyBjaGFuZ2VkLCA1MSBpbnNlcnRpb25zKCspLCA1IGRlbGV0
aW9ucygtKQo+IAo+IGRpZmYgLS1naXQgYS9Eb2N1bWVudGF0aW9uL2tidWlsZC9rYnVpbGQucnN0
IGIvRG9jdW1lbnRhdGlvbi9rYnVpbGQva2J1aWxkLnJzdAo+IGluZGV4IDVhOTAxM2JhY2ZiNy4u
ZTcxYTY5MmE1NTlhIDEwMDY0NAo+IC0tLSBhL0RvY3VtZW50YXRpb24va2J1aWxkL2tidWlsZC5y
c3QKPiArKysgYi9Eb2N1bWVudGF0aW9uL2tidWlsZC9rYnVpbGQucnN0Cj4gQEAgLTExMCw2ICsx
MTAsMjMgQEAgSE9TVExETElCUwo+IMKgLS0tLS0tLS0tLQo+IMKgQWRkaXRpb25hbCBsaWJyYXJp
ZXMgdG8gbGluayBhZ2FpbnN0IHdoZW4gYnVpbGRpbmcgaG9zdCBwcm9ncmFtcy4KPiDCoAo+ICtL
R1pJUAo+ICstLS0tLQo+ICtUaGUgZ3ppcCBwcm9ncmFtIHVzZWQgZm9yIGNvbXByZXNzZWQgbW9k
dWxlcywgcGFja2FnaW5nIGFuZCB0aGUgZW1iZWRkZWQKCkNvdWxkIHlvdSBhbHNvIGFkZCBnemlw
IHRvIGNoYW5nZXMucnN0IGFuZCB2ZXJfbGludXggd2hpbGUgeW91IGFyZSBhdCBpdD8KUmVzdCBs
b29rcyBnb29kIHRvIG1lLgpSZXZpZXdlZC1ieTogTWFudWVsIEVibmVyIDxtYW51ZWxlYm5lcmxp
QG1haWxib3gub3JnPgoKVGhhbmtzCiBNYW51ZWwKCj4gK2tlcm5lbCBjb25maWd1cmF0aW9uLiBE
ZWZhdWx0cyB0byBnemlwLgo+ICsKPiArS1BHWklQCj4gKy0tLS0tLQo+ICtUaGUgZ3ppcCBwcm9n
cmFtIHVzZWQgZm9yIHRoZSBjb21wcmVzc2VkIGtlcm5lbCBpbWFnZS4gRGVmYXVsdHMgdG8gcGln
eiAoYQo+ICtwYXJhbGxlbCBpbXBsZW1lbnRhdGlvbiBvZiBnemlwKSwgcnVuIHVuZGVyIHNjcmlw
dHMvam9ic2VydmVyLWV4ZWMgc28gdGhhdCBpdAo+ICt1c2VzIHRoZSBqb2Igc2xvdHMgbWFrZSBo
YXMgZnJlZSwgaWYgcGlneiBpcyBpbnN0YWxsZWQsIG90aGVyd2lzZSB0bwo+ICtgYEtHWklQYGAu
IFNldCBgYEtQR1pJUD1gYCBvbiB0aGUgbWFrZSBjb21tYW5kIGxpbmUgdG8gdXNlIGFub3RoZXIg
cHJvZ3JhbS4KPiArCj4gK0tCWklQMiwgS0xaT1AsIExaTUEsIExaNCwgWFosIFpTVEQKPiArLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQo+ICtUaGUgY29tcHJlc3NvciBwcm9ncmFt
cyBmb3IgdGhlIG90aGVyIGZvcm1hdHMuIEVhY2ggZGVmYXVsdHMgdG8gdGhlIHByb2dyYW0KPiAr
b2YgdGhlIHNhbWUgbmFtZS4KPiArCj4gwqAuLiBfdXNlcmtidWlsZGZsYWdzOgo+IMKgCj4gwqBV
U0VSQ0ZMQUdTCj4gZGlmZiAtLWdpdCBhL0RvY3VtZW50YXRpb24vcHJvY2Vzcy9jaGFuZ2VzLnJz
dCBiL0RvY3VtZW50YXRpb24vcHJvY2Vzcy9jaGFuZ2VzLnJzdAo+IGluZGV4IDBhYTIzMmIxMTdi
NS4uMjhmMmNhNjMzMThlIDEwMDY0NAo+IC0tLSBhL0RvY3VtZW50YXRpb24vcHJvY2Vzcy9jaGFu
Z2VzLnJzdAo+ICsrKyBiL0RvY3VtZW50YXRpb24vcHJvY2Vzcy9jaGFuZ2VzLnJzdAo+IEBAIC01
NSw2ICs1NSw3IEBAIG5mcy11dGlsc8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIDEuMC41wqDC
oMKgwqDCoMKgwqDCoMKgwqDCoCBzaG93bW91bnQgLS12ZXJzaW9uCgorIGd6aXAKCj4gwqBvcGVu
c3NsICYgbGliY3J5cHRvwqDCoMKgIDEuMC4wwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBvcGVuc3Ns
IHZlcnNpb24KPiDCoHBhaG9sZcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIDEuMjbC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcGFob2xlIC0tdmVyc2lvbgo+IMKgcGNtY2lhdXRpbHPC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIDAwNMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHBjY2Fy
ZGN0bCAtVgo+ICtwaWd6IChvcHRpb25hbCnCoMKgwqDCoMKgwqDCoCAyLjTCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoCBwaWd6IC0tdmVyc2lvbgo+IMKgUFBQwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqAgMi40LjDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHBwcGQgLS12ZXJz
aW9uCj4gwqBwcm9jcHPCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAzLjIuMMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqAgcHMgLS12ZXJzaW9uCj4gwqBQeXRob27CoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoCAzLjkueMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcHl0aG9uMyAtLXZl
cnNpb24KPiBAQCAtMjA2LDYgKzIwNywxMyBAQCBHTlUgQVdLCj4gwqBHTlUgQVdLIGlzIG5lZWRl
ZCBpZiB5b3Ugd2FudCBrZXJuZWwgYnVpbGRzIHRvIGdlbmVyYXRlIGFkZHJlc3MgcmFuZ2UgZGF0
YSBmb3IKPiDCoGJ1aWx0aW4gbW9kdWxlcyAoQ09ORklHX0JVSUxUSU5fTU9EVUxFX1JBTkdFUyku
Cj4gwqAKPiArcGlneiAob3B0aW9uYWwpCj4gKy0tLS0tLS0tLS0tLS0tLQo+ICsKPiArcGlneiBp
cyBhIHBhcmFsbGVsIGltcGxlbWVudGF0aW9uIG9mIGd6aXAuIElmIGl0IGlzIGluc3RhbGxlZCB0
aGUgY29tcHJlc3NlZAo+ICtrZXJuZWwgaW1hZ2UgaXMgcHJvZHVjZWQgd2l0aCBpdCByYXRoZXIg
dGhhbiB3aXRoIGd6aXAsIHNlZSBgYEtQR1pJUGBgIGluCj4gK0RvY3VtZW50YXRpb24va2J1aWxk
L2tidWlsZC5yc3QuCj4gKwo+IMKgU3lzdGVtIHV0aWxpdGllcwo+IMKgKioqKioqKioqKioqKioq
Kgo+IMKgCj4gZGlmZiAtLWdpdCBhL01ha2VmaWxlIGIvTWFrZWZpbGUKPiAuLi4KCg==

