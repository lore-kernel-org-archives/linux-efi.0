Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F18D23B0587;
	Wed,  9 Sep 2026 19:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788981276; cv=none; b=F0H50/7r1sGyfS1E1vN3LGNH0r4JpY7moJ9FO8+jyPmFKMhmOh6ckEAD4XZ3BQAiBir3jUtdNhWEis+c8toHPjQ1Vw1m6VgqGEIa8S8FLQ4sdfC6OsHhdyNExUHvl/ONEsWywmUQRUXMW13TiXmuNL/xdnsqLe6fgATWukXV4L8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788981276; c=relaxed/simple;
	bh=d8WCbeo6jjOivxNyTxUN+oxzgGbmO2YuDGqsYw1uw7I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uCRzsN8J+6+1JVvSeDcAlnUDsFu1JJi0vXNHFzF+8AArZOduJwButIOzehH58u54fUy8CqQXs8P+Kb/luTEvkda+3+jWYOmzH+FdZ/50Uj4Ycq+p6y60mkCnRKHXoTPm5O+bEZ5QlFifZPIBAYdzkXoxDeevhiWbOuU++IVvSqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=ah4+xZDI; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="ah4+xZDI"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id E28AF40E01ED;
	Wed,  9 Sep 2026 19:14:30 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id iIu_wFNTMsPI; Wed,  9 Sep 2026 19:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1788981261; bh=XeugPcE935YQxipQwg/vnfXosvIcdyaMCLFwxk84wns=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ah4+xZDIHdXYnFEBnKOX7zJPSURXnBXKOovTMsu0XCpBsjYPcwt6+pxfSosZQzjXH
	 ILxaMTmNpV3u/EpBFwJ0i8RBZjWpj90xaYmyBUVwR7zoNHs/l/n0G+R+BFOTBJdFXn
	 oGQZeiZ9PiiUYli4nOfLTugp2sNG9R3L7ZYEgqHdKRTDOnGGOk/zxFIURyAJmrFN2J
	 +oGGRWvRID45uATYRrvCNjybFxQnwc0sNr2/Noy4ubVx98C9OlQhELrOkEVgSdfn/F
	 4RHZXKWMliaORaZox4VuPS62wH0rAjtA7V0VC2kuhXZvp7RDqCVuxkcJ5MPbx6fgVF
	 cw4d1GdG92XpdlWGsJqBHHLubqgTTrl9Vl+6pFL1yp2HWtlW8CHExFEjUSXiG1dbvD
	 9yDvwHKIQRhN9p97XgOuXczfkVN0yD+mUssrMFNxYPI5AVTUug4ShLGW6s/hA7tMLZ
	 CfU8+WXTU7DQzcRSeXFEhkxAmf5GcOsgFfaaOwA2+lUWdvGD5p5LAC5NaLYpBZCGKL
	 HxzTVQYWzvhwFxIWNa662gA0Q2LUbF4r9JjO9OX/aDHLIvU6+0XXCYw3dsAnGh61ut
	 vgShKQnqYqatEj5rOrHh1tsfd2dG8xlFrTgJvOsfQrZnxTh4eDyZ6ilQwhUSEOqhw1
	 9E4OSwq5RGa9V7MQN+yZv2eE=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 6150440E01E1;
	Wed,  9 Sep 2026 19:14:13 +0000 (UTC)
Date: Wed, 9 Sep 2026 12:14:10 -0700
From: Borislav Petkov <bp@alien8.de>
To: Ard Biesheuvel <ardb+git@google.com>,
	Kiryl Shutsemau <kirill@shutemov.name>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Vincent Mailhol <mailhol@kernel.org>, x86@kernel.org
Subject: Re: [PATCH v2 01/10] x86/boot: Drop pointless re-implementation of
 panic()
Message-ID: <20260909191410.GAaqGwAsCewrdVZZ0s@fat_crate.local>
References: <20260909115530.1924665-12-ardb+git@google.com>
 <20260909115530.1924665-13-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260909115530.1924665-13-ardb+git@google.com>

On Wed, Sep 09, 2026 at 01:55:32PM +0200, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
> 
> The decompressor has its own implementation of panic(), which is based
> on the vsnprintf() routine provided by the EFI stub.
> 
> Relying on the EFI stub from code that does not execute in the context
> of the EFI boot services is a bad idea. It is also completely pointless
> in this case, given that the only user of this version of panic() only
> passes a compile time constant string, without any printf conversions.
> 
> So use error() instead of panic() in that case, and drop the panic()
> implementation entirely. This is needed so that the EFI stub's
> vsnprintf() can be modified in a manner that is incompatible with the
> expectations of this caller.
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  arch/x86/boot/compressed/error.c | 19 -------------------
>  arch/x86/boot/compressed/error.h |  1 -
>  arch/x86/boot/compressed/mem.c   |  2 +-
>  3 files changed, 1 insertion(+), 21 deletions(-)
> 
> diff --git a/arch/x86/boot/compressed/error.c b/arch/x86/boot/compressed/error.c
> index 19a8251de506..ce5ed7d8265e 100644
> --- a/arch/x86/boot/compressed/error.c
> +++ b/arch/x86/boot/compressed/error.c
> @@ -22,22 +22,3 @@ void error(char *m)
>  	while (1)
>  		asm("hlt");
>  }
> -
> -/* EFI libstub  provides vsnprintf() */
> -#ifdef CONFIG_EFI_STUB
> -void panic(const char *fmt, ...)

So this thing appeared magically in v8 of the TDX unaccepted memory patches
and I don't think we questioned it back then.

v7's tdx_accept_memory() does error():

https://lore.kernel.org/all/20220614120231.48165-15-kirill.shutemov@linux.intel.com/

and v8 started doing panic():

+void tdx_accept_memory(phys_addr_t start, phys_addr_t end)
+{
+	if (!tdx_enc_status_changed_phys(start, end, true))
+		panic("Accepting memory failed: %#llx-%#llx\n",  start, end);
+}

https://lore.kernel.org/all/20221207014933.8435-15-kirill.shutemov@linux.intel.com/

and it switched to it being a vsnprintf() wrapper because it wanted to dump
start and end perhaps.

But then it ended up dropping the params in v13 and landed upstream with
a single string as an argument.

Anyway, adding Kiryl/Kirill for comment and leaving in the rest for reference.

> -{
> -	static char buf[1024];
> -	va_list args;
> -	int len;
> -
> -	va_start(args, fmt);
> -	len = vsnprintf(buf, sizeof(buf), fmt, args);
> -	va_end(args);
> -
> -	if (len && buf[len - 1] == '\n')
> -		buf[len - 1] = '\0';
> -
> -	error(buf);
> -}
> -#endif
> diff --git a/arch/x86/boot/compressed/error.h b/arch/x86/boot/compressed/error.h
> index 31f9e080d61a..87062dea9a20 100644
> --- a/arch/x86/boot/compressed/error.h
> +++ b/arch/x86/boot/compressed/error.h
> @@ -6,6 +6,5 @@
>  
>  void warn(const char *m);
>  void error(char *m) __noreturn;
> -void panic(const char *fmt, ...) __noreturn __cold;
>  
>  #endif /* BOOT_COMPRESSED_ERROR_H */
> diff --git a/arch/x86/boot/compressed/mem.c b/arch/x86/boot/compressed/mem.c
> index 0e9f84ab4bdc..e1c017b55184 100644
> --- a/arch/x86/boot/compressed/mem.c
> +++ b/arch/x86/boot/compressed/mem.c
> @@ -37,7 +37,7 @@ void arch_accept_memory(phys_addr_t start, phys_addr_t end)
>  	/* Platform-specific memory-acceptance call goes here */
>  	if (early_is_tdx_guest()) {
>  		if (!tdx_accept_memory(start, end))
> -			panic("TDX: Failed to accept memory\n");
> +			error("TDX: Failed to accept memory\n");
>  	} else if (early_is_sevsnp_guest()) {
>  		snp_accept_memory(start, end);
>  	} else {
> -- 
> 2.55.0.1003.g10538fe699-goog

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
