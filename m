Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1FB21ACEDE;
	Sat, 19 Sep 2026 16:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789835169; cv=none; b=MRbiInDkRH5UfqeYJiU2fXISz6Pi1Uny20pCerja8yuAC4F6Lv3WnzKAr3tsU2OY7/mEMNw1jB6CRC0nceF83qqVrDsPd+KWcm/uXZXScW3o3q3T/vs6uKMao132vG1PjyvCxB3E76gN6x+FRy+ixs8xWv6lWafyhh64fFfwGSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789835169; c=relaxed/simple;
	bh=eCbh8mfi6adhb6JroL0azQQMp93Leh+1Nif6bKAoa2k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I9jNnRM/BlI9W9Bt77s3Y2G39SOfIvn7eBRcMAqPqHvVeczQgRiQiIg8Kw+1aHvAQb1uX4/yXrfGMqk7CA5zTYhW1hjYPU9Kpw3Cl2/20Zdwsq6Nh+mxcZgAUGqq5y4sMInjNGdNNgPIN/UPsDdeTsRMLzImYEL5fVpgwRfvckg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YDVtxTFf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YDVtxTFf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCFE91F000FF;
	Sat, 19 Sep 2026 16:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789835168;
	bh=eCbh8mfi6adhb6JroL0azQQMp93Leh+1Nif6bKAoa2k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YDVtxTFfI6xU/DPywHMbajyOUCDkZGlkv3d+iypqFADDMUIjfdHII98NSCshNfh5y
	 t4XJqUHrptMCUDegPcPxrhLflNnCCeBF224b9pF4ftNZoQhqqaYMzqv6oTpbynshL9
	 2vsg7ticySOLl+S/MejmLy9iUxDqGxRFsIRTtPlSr/TA8RmYNgSg0MuMYwGbznmr2h
	 qtOPLsQdiEu2cj26rIFitkPl3Sv8jSX2P5Xf/9vTJ4AA8YNW2joXFvMIE//WeMO3qG
	 dVjuWycXldhzpiv7SyMZsjadqF5HcMa3g4xU+WtG8sPtCzeaqVk5X7hMsDrcGwkCqO
	 JhggEWantwudQ==
Date: Sat, 19 Sep 2026 17:25:54 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Kees Cook <kees@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, 
	Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nsc@kernel.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, Bill Wendling <morbo@google.com>, 
	Justin Stitt <justinstitt@google.com>, Masahiro Yamada <masahiroy@kernel.org>, 
	Alexey Gladkov <legion@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, Arnd Bergmann <arnd@arndb.de>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ardb@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, 
	Gary Guo <gary@garyguo.net>, =?utf-8?B?QmrDtnJu?= Roy Baron <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, Daniel Almeida <daniel.almeida@collabora.com>, 
	Tamir Duberstein <tamird@kernel.org>, Alexandre Courbot <acourbot@nvidia.com>, 
	Onur =?utf-8?B?w5Z6a2Fu?= <work@onurozkan.dev>, Jonathan Corbet <corbet@lwn.net>, 
	Randy Dunlap <rdunlap@infradead.org>, "Gustavo A. R. Silva" <gustavoars@kernel.org>, 
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, llvm@lists.linux.dev, 
	linux-riscv@lists.infradead.org, linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-efi@vger.kernel.org, rust-for-linux@vger.kernel.org, linux-doc@vger.kernel.org, 
	Jens Axboe <axboe@kernel.dk>, linux-hardening@vger.kernel.org
Subject: Re: [PATCH v3 07/20] kallsyms: reimplement mksysmap in C
Message-ID: <aq63cXS-Gl3LFgf9@gremlin>
References: <20260917-build-speedup-v3-0-9ecf4163ff36@kernel.org>
 <20260917-build-speedup-v3-7-9ecf4163ff36@kernel.org>
 <202609171046.146CAE972B@keescook>
 <aq6zQng28spcTD88@gremlin>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aq6zQng28spcTD88@gremlin>

On Sat, Sep 19, 2026 at 05:24:06PM +0100, Lorenzo Stoakes (ARM) wrote:
> On Thu, Sep 17, 2026 at 11:07:31AM -0700, Kees Cook wrote:
> > On Thu, Sep 17, 2026 at 05:06:17PM +0100, Lorenzo Stoakes (ARM) wrote:
> >
> > These 2 functions kind of feel like they should live in elfparse instead?
>
> Ack, updated this and patch 4 to share code for v4!

Patch 6 even :)

--
Cheers, Lorenzo
