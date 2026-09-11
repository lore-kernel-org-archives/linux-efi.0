Received: from mail.avm.de (mail.avm.de [212.42.244.120])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C54444AE11E;
	Fri, 11 Sep 2026 18:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.42.244.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789150690; cv=none; b=pf3vJu74IIWWROfQ973VF1oMH/ngNaSPiZPXwJqvnIWqyBt6qm8MX78wE17LtITJoEe6M+reJtcc74DCmFNcWV3czlG3IU7M/jnrbXs946+EELTy+V0XLZDfSYhVJ28chXok6EHT3KfBfXtboNAiBXGWs8AePHa4bFewvcYt5Mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789150690; c=relaxed/simple;
	bh=4m5yk/k55asBFxV3Yrw4jckjF0Ccpy/QWIGf4quzAAg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kWuWdCdfrQBBZGIL0fmRDNH+woyxIOAVreKHctvXOxdAqqJTJkfo6eYYC4kSLT3fSdlceycBQlGFodUCP67DB9veiT/dVnKxocM1qkAeZQcABO0OF8Q9vHmaF62C//wuRG5pkTM8NsB+6aX62rWf5R7z9FQUDYVO/Tm9/kKThh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fritz.com; spf=pass smtp.mailfrom=fritz.com; dkim=pass (2048-bit key) header.d=fritz.com header.i=@fritz.com header.b=feKsbpgg; arc=none smtp.client-ip=212.42.244.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fritz.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fritz.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fritz.com header.i=@fritz.com header.b="feKsbpgg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=fritz.com; s=mail;
	t=1789150677; bh=4m5yk/k55asBFxV3Yrw4jckjF0Ccpy/QWIGf4quzAAg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=feKsbpggxPjO+L8yKkeMjSg6GdSQSLR9XKrPldZ9xwoiDTB1nada6e6Li3U1uvJBE
	 Bo9ycQtybDQsKVCVHFCI8iHDrDHnM45RxEWyVLs2ro3ntOgdpgJ11kkgAY9jdofcnW
	 LgO4oBww24RpJ58OsSW3XCpjW+FXiwHlRhE98b3U1MFCqvppGY+ughJOa04x0D4ZrC
	 peC9C90PMJA5fL176KDAzvRjAu7tZIyjUhEGV54N6o9V9ACcFMSWAMg0W3ImC2L1ai
	 cjCBFHzkytvnqjpewr3Nj6Uv8G3FTG6D8hkEPSX8PgDsKMcdUjYS53LHKCoY3pYAUs
	 rVNlWagNGbLcw==
Received: from [2001:bf0:244:244::78] (helo=mail.avm.de)
	by mail.avm.de with ESMTP (eXpurgate 4.57.1)
	(envelope-from <n.schier@fritz.com>)
	id 6aa445d5-0449-7f0000032729-7f000001c01e-1
	for <multiple-recipients>; Fri, 11 Sep 2026 20:17:57 +0200
Received: from mail-auth.fritz.com (unknown [IPv6:2001:bf0:244:244::78])
	by mail.avm.de (Postfix) with ESMTPS;
	Fri, 11 Sep 2026 20:17:57 +0200 (CEST)
Date: Fri, 11 Sep 2026 20:17:57 +0200
From: Nicolas Schier <n.schier@fritz.com>
To: David Laight <david.laight.linux@gmail.com>
Cc: Nathan Chancellor <nathan@kernel.org>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Alexey Gladkov <legion@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	Arnd Bergmann <arnd@arndb.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>,
	Gary Guo <gary@garyguo.net>,
	=?utf-8?B?QmrDtnJu?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Tamir Duberstein <tamird@kernel.org>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Onur =?utf-8?B?w5Z6a2Fu?= <work@onurozkan.dev>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
	linux-riscv@lists.infradead.org, linux-arch@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org,
	rust-for-linux@vger.kernel.org, linux-doc@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 12/23] kbuild: avoid re-running compiler and linker probes
Message-ID: <20260911-invaluable-indigo-seal-e31aec@l-nschier-aarch64>
References: <20260908-build-speedup-v1-0-5dc1ac01672d@kernel.org>
 <20260908-build-speedup-v1-12-5dc1ac01672d@kernel.org>
 <178901395292.3971858.13236774094648272066.b4-review@b4>
 <20260910-translucent-sweet-sidewinder-7acacb@l-nschier-aarch64>
 <20260911183333.1df0f2e2@pumpkin>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260911183333.1df0f2e2@pumpkin>
Organization: FRITZ! Technology GmbH
x-ms-reactions: disallow
X-purgate-ID: 149429::1789150677-0CF8F965-95D5DB55/0/0
X-purgate-type: clean
X-purgate-size: 775
X-purgate: This mail is considered clean (visit https://www.eleven.de for further information)
X-purgate: clean
X-pfmilter: host: postfix-mx-01  mail-id: 4CFD1A0632  external: no

On Fri, Sep 11, 2026 at 06:33:33PM +0100, David Laight wrote:
> On Thu, 10 Sep 2026 17:42:35 +0200
> Nicolas Schier <n.schier@fritz.com> wrote:
> 
> ...
> > Yes, skimming through the patch, I thought about that, too.  Moving more 
> > cc option checks to Kconfig will make building out-of-tree kmods with a 
> > different compiler more dangerous.  Maybe we will have to make the 
> > warning in Makefile's prepare (external kmods) target a bit louder.
> 
> One problem is that distributions have a nasty habit of shipping kernels
> that are compiled with a different compiler version to they actually
> ship as a compiler.
> In some cases the versions are clearly the same - but the version
> strings differ.

yeah, I guess you hit the mark.

-- 
Nicolas
