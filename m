Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AC5226A0C7;
	Fri,  6 Mar 2026 23:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772839035; cv=none; b=IyL+YTQkUcN8h94Ek+nF2s8WS52+KhXuclFRIPbudINNU6tqxfL6FI9FGoJNs1Wt+FSbkxNJB+ys3nZRAqr9yMnklH/em/2UdrQT7VAHveUQTihFcCj9dPhJIG6M/W3OXTySRyHNKZ4i9ykCEuo0RMHgllCh9pn0FMHJgJoXimE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772839035; c=relaxed/simple;
	bh=A/uuCYUUHbNrrdKdzYdGzSe5pMInGIZfaSIgsjBFQtg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dmVh5JC+jV0rZcl0qFysJzQMGa1cjf8bJI+CJsRs+hODfDQIvYLGwYvaAD2Z2z9XOrJFRnUgFy9Rnyd1C1WWY8lPYYEwg6M86kLlrY515A1gKYuwmdz99uFXuh9Y06rw3buU4HSP/7jLj5Rv/W3YwmeVHnUTLe/RwVX5jQQR/4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CiNTmhly; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CiNTmhly"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86B13C4CEF7;
	Fri,  6 Mar 2026 23:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772839035;
	bh=A/uuCYUUHbNrrdKdzYdGzSe5pMInGIZfaSIgsjBFQtg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CiNTmhly2/1kTdtRkuNAgOXwAQT7A+wQx51m3gawq6ph2TOb1AmR20TS/sy1txYNU
	 iElaZlD0mEOexw6DRDS/H4TTDu/pyj/oV6d7iSt93lYyho/X6/HC8T986ocCrdSX8f
	 W0fMhB4DiENlMrX0hKOJVXylpR8JdeJwPK1us4hrvgF/gpr5p0tTJy8J9/hBJuGZ7x
	 J6oOaB9DvzC1IcXPWbDiXcwZ6M+56B4nTerYJlMNfl+KbCI8z/0xfmHkRzg6Ie7YMn
	 mh/kZD1RDkMqTowspybgiAXSVWjmzHV1BRX2XnLenj50feqtNdUtqkWd/KSVt0jhRK
	 6S7laj3n5tF8A==
Date: Fri, 6 Mar 2026 16:17:05 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
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
	Ard Biesheuvel <ardb@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>, Kees Cook <kees@kernel.org>,
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, loongarch@lists.linux.dev,
	linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-s390@vger.kernel.org, linux-efi@vger.kernel.org,
	llvm@lists.linux.dev
Subject: Re: [PATCH 0/2] kbuild: Switch from '-fms-extensions' to
 '-fms-anonymous-structs' when available
Message-ID: <20260306231705.GD2746259@ax162>
References: <20260223-fms-anonymous-structs-v1-0-8ee406d3c36c@kernel.org>
 <01433066-eb9b-4a96-8d7f-794af941d365@zytor.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <01433066-eb9b-4a96-8d7f-794af941d365@zytor.com>

On Thu, Mar 05, 2026 at 03:43:29PM -0800, H. Peter Anvin wrote:
> Question: does clang allow this with __extension__, or only if the option is
> on the command line?  It would be desirable in the long run if both clang and

It looks like only on the command line:

  https://godbolt.org/z/zrE766obe

> gcc would allow this with __extension__, as that would be required to use it
> in uapi headers (at least without some doable-but-nontrivial preprocessing,
> which might be worthwhile to do anyway...)

I agree that would be desirable but wouldn't that change how
__extension__ works? As far as I can tell from reading GCC's
documentation [1], __extension__ just supresses warnings from -pedantic
and such, it does not actually enable a used extension if it conflicts
with whatever -std= value is passed?

[1]: https://gcc.gnu.org/onlinedocs/gcc/Alternate-Keywords.html

Cheers,
Nathan
