Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AC7A37B41B;
	Mon, 23 Feb 2026 22:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771887201; cv=none; b=Q01vmrRJMUp5/Ri1XziR8hiY9MTvQu/LRPccLerH9pGpHWRFi+kcKyP0smsEQdcYogLDxkZnmAUUWj7ilQSurD/BZjcBSDYTYXW2Ydga7EFqjgNijQZTEktRoKal9tRU9Ks/h4Fdptj0hqhmQSrYshJPnpLJe/TtXZHnfjYuLjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771887201; c=relaxed/simple;
	bh=XGtuTf6Jcf122l6S01HJPRF+WchS/Q65b0NtmqAoVfE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V8ksSwmniot5m9kixAItuQoKNdBwSumI94SuOOovFH8sbTCRn4aRiDCTueanr/CuM8ocHuEvxTtr94l7IR7pKeuHPiyhmbjl8koO+Eaa9+6x8CUOWpE21J6LLK0ulrGqPpA2zu9k57qBIS1T0e6ddpJi85wr5+2AuldmgxIZrwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZmfHgfUr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZmfHgfUr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AAC4C116C6;
	Mon, 23 Feb 2026 22:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771887200;
	bh=XGtuTf6Jcf122l6S01HJPRF+WchS/Q65b0NtmqAoVfE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZmfHgfUrB8rf7SxS+m7i6Nbm83akA5w9OLDipQGSOaVcHUJGhBGr5JleV+lvbT9Ih
	 ES1jeEYODvs6SIXAPyGAAqikZa4UUtROdKJg27d0BjUclgv47EtSp4h3ptI4rsvsT/
	 A/Q6dW5mmG7a+LrrgsNs234f6ShddcgHYyrsN1srQ7REoeTAP28vUOzECSlNUqNnLH
	 G9qNJfAkWQ76V6BqhrsUIj/wgc43wW4DjMi+HPcfE29HwNkfPdhL31UnAXovXRGfzq
	 1HY/4jllrJt2uUrbR8H93TaAt2kzOEpXk+3SA5YCx8OLMs+sxQjnNO3yfFcXNCeWQl
	 UR0qUMHlXOhng==
Date: Mon, 23 Feb 2026 15:53:11 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Kees Cook <kees@kernel.org>
Cc: Nicolas Schier <nsc@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	Helge Deller <deller@gmx.de>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	loongarch@lists.linux.dev, linux-parisc@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
	linux-efi@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH 2/2] kbuild: Use '-fms-anonymous-structs' if it is
 available
Message-ID: <20260223225311.GA2462602@ax162>
References: <20260223-fms-anonymous-structs-v1-0-8ee406d3c36c@kernel.org>
 <20260223-fms-anonymous-structs-v1-2-8ee406d3c36c@kernel.org>
 <202602231432.20F3F0CF@keescook>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202602231432.20F3F0CF@keescook>

On Mon, Feb 23, 2026 at 02:33:35PM -0800, Kees Cook wrote:
> Series looks good to me. One style question, why go the round-trip with
> Kconfig instead of doing it all with a fallback in the Makefile:
> 
> CC_FLAGS_DIALECT += $(call cc-option,-fms-anonymous-structs,-fms-extensions)

I might be misunderstanding how Kbuild works but
arch/$(SRCARCH)/Makefile may have logic for selecting CROSS_COMPILE,
which can impact the selection of $(CC), so I cannot use cc-option prior
to its inclusion but I need CC_FLAGS_DIALECT to be included before
arch/$(SRCARCH)/Makefile in the main build so that they can be used
within it, which is only possible after Kconfig has run. This is
probably worth more flushing out in the code or a comment since it is
subtle.

Cheers,
Nathan
