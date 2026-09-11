Received: from mail.avm.de (mail.avm.de [212.42.244.119])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28FDE4AA592;
	Fri, 11 Sep 2026 19:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.42.244.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789155280; cv=none; b=ip1aVpdklYtr6fqHBVzO5F7iTg40nmoINGLVycX4I2nfRvIEAXehyYyFWyr7d71S/KMDBXf/zb1JtNEAaVstaSZhbmlxXgC0oliFJFl4CjhO8ShdVE/z2ty6Asyheyv0iufCNgQsR9IJM9dGw+E21vEyPucRzwKlgT1a/WrB7xU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789155280; c=relaxed/simple;
	bh=1JfbmLy+b2xGLH17ANL6tQt8xAUXkYVFyRMRSFYKTI8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CtbCaSzVVe37xh9mtxE2IefOxRIVnzYI0P6ozxyru/SVp/jLwFeb78B2/5MZckg5yiYY6CPMigGBGGsxqM+7NUU7LKag716WH9qjHJbydfFpfXFPKJe0kgpq0s39ojgYvZQp3auPokAGOzMpdNzBUgNUJBHwgZl6Fym+2aqrTlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fritz.com; spf=pass smtp.mailfrom=fritz.com; dkim=pass (2048-bit key) header.d=fritz.com header.i=@fritz.com header.b=FhnZcspB; arc=none smtp.client-ip=212.42.244.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fritz.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fritz.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fritz.com header.i=@fritz.com header.b="FhnZcspB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=fritz.com; s=mail;
	t=1789155262; bh=1JfbmLy+b2xGLH17ANL6tQt8xAUXkYVFyRMRSFYKTI8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FhnZcspBrpigELbZTgL3IYBI0b+pFDqdiLuNUuMEvP1XCe3lb8wJ35046eFcsSlJv
	 6ly2ytvvQtvbyiWv6X2+0OM74cilE326ACJHMCheipzLn0tIWeTUo+b5OBdSyh2bH0
	 WyxyJXMmzBTzMLPFtiK+a5hx1kJyf6Uluud9RT3qAQe/f7lnqJI6E8x749lE+1GJKx
	 yCJcYDWKy/eRMhv63UeDEuL7M2u3eTE2ik8Kak8gec8vyjYrVhK/hjjE7re9rqOOQ3
	 Yt6uFUsJKm+lGKHzCkP/TOzn5zSViKBtjcAMf7qaK7wthDOMSth5CVx+0gr36hV3i3
	 iC02B5tSCJjqg==
Received: from [212.42.244.78] (helo=mail.avm.de)
	by mail.avm.de with ESMTP (eXpurgate 4.57.1)
	(envelope-from <n.schier@fritz.com>)
	id 6aa457be-ea3f-7f0000032729-7f000001ab1c-1
	for <multiple-recipients>; Fri, 11 Sep 2026 21:34:22 +0200
Received: from mail-auth.fritz.com (unknown [212.42.244.78])
	by mail.avm.de (Postfix) with ESMTPS;
	Fri, 11 Sep 2026 21:34:22 +0200 (CEST)
Date: Fri, 11 Sep 2026 21:34:21 +0200
From: Nicolas Schier <n.schier@fritz.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: David Laight <david.laight.linux@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
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
Message-ID: <20260911-just-vanilla-seal-ea4f6a@l-nschier-aarch64>
References: <20260908-build-speedup-v1-0-5dc1ac01672d@kernel.org>
 <20260908-build-speedup-v1-12-5dc1ac01672d@kernel.org>
 <178901395292.3971858.13236774094648272066.b4-review@b4>
 <20260910-translucent-sweet-sidewinder-7acacb@l-nschier-aarch64>
 <20260911183333.1df0f2e2@pumpkin>
 <20260911-invaluable-indigo-seal-e31aec@l-nschier-aarch64>
 <aqRGYXKDzXZMXmmp@gremlin>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aqRGYXKDzXZMXmmp@gremlin>
Organization: FRITZ! Technology GmbH
x-ms-reactions: disallow
X-purgate-ID: 149429::1789155262-F4C99720-D05EFFBE/0/0
X-purgate-type: clean
X-purgate-size: 1635
X-Notice: Whitelisted
X-purgate: This mail is considered clean (visit https://www.eleven.de for further information)
X-purgate: clean
X-pfmilter: host: postfix-mx-02  mail-id: A62CAA0468  external: no

On Fri, Sep 11, 2026 at 07:24:50PM +0100, Lorenzo Stoakes (ARM) wrote:
> On Fri, Sep 11, 2026 at 08:17:57PM +0200, Nicolas Schier wrote:
> > On Fri, Sep 11, 2026 at 06:33:33PM +0100, David Laight wrote:
> > > On Thu, 10 Sep 2026 17:42:35 +0200
> > > Nicolas Schier <n.schier@fritz.com> wrote:
> > >
> > > ...
> > > > Yes, skimming through the patch, I thought about that, too.  Moving more
> > > > cc option checks to Kconfig will make building out-of-tree kmods with a
> > > > different compiler more dangerous.  Maybe we will have to make the
> > > > warning in Makefile's prepare (external kmods) target a bit louder.
> > >
> > > One problem is that distributions have a nasty habit of shipping kernels
> > > that are compiled with a different compiler version to they actually
> > > ship as a compiler.
> > > In some cases the versions are clearly the same - but the version
> > > strings differ.
> >
> > yeah, I guess you hit the mark.
> 
> I mean this is a problem that already exists for any flags already specified in
> Kconfig.
> 
> Out-of-tree modules are historically something that we don't go to great lengths
> to support and haven't historically worried about breaking, either.
> 
> I'm sure distros can find ways around this if a problem were to arise. But I
> don't think it's something to worry about all that much.
> 
> I expect a _lot_ of these, in any case, would only require the compilers to be
> within a fair few major versions of one another anyway.

yes, I have similar thoughts about that.  But I think it's good that it 
has been mentioned here in public.

-- 
Nicolas
