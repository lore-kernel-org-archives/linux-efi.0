Received: from mail.avm.de (mail.avm.de [212.42.244.119])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB0B748F851;
	Fri, 18 Sep 2026 19:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.42.244.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789761094; cv=none; b=JKW59GrVZANf8hD1+qVJzG2J5wtP0hv1+Dus+dVnZhhH14i6LjJgDwHD7/xS7n4K/WBb5V/xVRlzDMpGsYNMDKwwylcK38XPkE8lHFo1p2AVMW86f9d9g223dgf/DKEQyOSDSvkNdvMAkKCAzepijBHJpMN/dKCgPm6v+Fj4IZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789761094; c=relaxed/simple;
	bh=leG1surbbAGzFqImsj1nRlYADVAoFUfkGP9usQfU0ZY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k5qTGPdOH1OsjLh8f0Dh1MKJRDsjO6GKExXGoBkxg9cFY7AbIWI8npq552leP2uc/P5HKGbTJt2OMcRpqbk+SuhBXsZgSPWpacdVfAHnlDLWkJGG81L/QyrfXMN3JHbhhcMgvVICWIMWefJ9vBus6fl2uiVUUmpnR37Q6i/Dltg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fritz.com; spf=pass smtp.mailfrom=fritz.com; dkim=pass (2048-bit key) header.d=fritz.com header.i=@fritz.com header.b=CwUTTwfQ; arc=none smtp.client-ip=212.42.244.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fritz.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fritz.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fritz.com header.i=@fritz.com header.b="CwUTTwfQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=fritz.com; s=mail;
	t=1789761087; bh=leG1surbbAGzFqImsj1nRlYADVAoFUfkGP9usQfU0ZY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CwUTTwfQ0nDfM8KmKEGWxW3N9BGzebJ7oxpcse/seHt1EanTZdQmQsCRUSPmw+40W
	 WlAtsMpEXNVrU77mdkPu6WvEobutBsQvh9ZoOMQjhKEBDrFLZp/pyZy7amGwaHBqUX
	 h/f9FtMXnzpRuanVqUGDUlA2NAqPev4jpkSzX+gywfZoneCagdfhwi/nitq1v0s8Kr
	 4P+SuZ1vWe1+VMnamkZN9HQmcXD/7JQkY13HyBLC4hMeS8Y8THgYzPyM1uzRlvcmQR
	 VxRy+V8I9xw3dIh5udQWYQqkAAA9/EYJiwjcs9lLCoxMH6ail+PCTL8XDeIIKIsQ+2
	 7AaSZLQoGXL+Q==
Received: from [2001:bf0:244:244::78] (helo=mail.avm.de)
	by mail.avm.de with ESMTP (eXpurgate 4.57.1)
	(envelope-from <n.schier@fritz.com>)
	id 6aad963f-03d5-7f0000032729-7f000001a58a-1
	for <multiple-recipients>; Fri, 18 Sep 2026 21:51:27 +0200
Received: from mail-auth.fritz.com (unknown [IPv6:2001:bf0:244:244::78])
	by mail.avm.de (Postfix) with ESMTPS;
	Fri, 18 Sep 2026 21:51:27 +0200 (CEST)
Date: Fri, 18 Sep 2026 21:51:26 +0200
From: Nicolas Schier <n.schier@fritz.com>
To: Kees Cook <kees@kernel.org>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Nathan Chancellor <nathan@kernel.org>,
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
	Randy Dunlap <rdunlap@infradead.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev, linux-riscv@lists.infradead.org,
	linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-efi@vger.kernel.org, rust-for-linux@vger.kernel.org,
	linux-doc@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH v3 08/20] kbuild: cache list, composite object state per
 object
Message-ID: <20260918-godlike-devious-perch-707bf6@l-nschier-aarch64>
References: <20260917-build-speedup-v3-0-9ecf4163ff36@kernel.org>
 <20260917-build-speedup-v3-8-9ecf4163ff36@kernel.org>
 <202609171110.438BC7477A@keescook>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <202609171110.438BC7477A@keescook>
Organization: FRITZ! Technology GmbH
x-ms-reactions: disallow
X-purgate-ID: 149429::1789761087-71FB9EF9-5D565A0E/0/0
X-purgate-type: clean
X-purgate-size: 512
X-purgate: This mail is considered clean (visit https://www.eleven.de for further information)
X-purgate: clean
X-pfmilter: host: postfix-mx-02  mail-id: E2AD4A0120  external: no

On Thu, Sep 17, 2026 at 11:11:41AM -0700, Kees Cook wrote:
> On Thu, Sep 17, 2026 at 05:06:18PM +0100, Lorenzo Stoakes (ARM) wrote:
> > Fix the issue by caching this data and looking it up instead of getting it
> > over and over again.
> 
> Nit: I would describe this as "calculate these once". It _is_ caching,
> but I think with Makefiles there is an implication the "caching" means
> "write to disk". But maybe that's just me.

+1

Reviewed-by: Nicolas Schier <n.schier@fritz.com>

-- 
Nicolas
