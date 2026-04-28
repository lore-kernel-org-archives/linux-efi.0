Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B8FF3101C8;
	Tue, 28 Apr 2026 08:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777365177; cv=none; b=fPYlxlU98YPbknSMmC2mclOyuI3tEHqggEc8m/Lr7iImMwZKsh7zs5In496PhjCTo+dhfwMhB+ReRqFv3/1yJYjPx5t0CZ2q85M3RH+JZsxWodqVzPyMi181ACN+3dCAqbAIPd7SZ0UQT7IboQF/r762l5p5CedVpdlYGNRd92Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777365177; c=relaxed/simple;
	bh=DJo9DLWnPxdlYFpATvmZ2FFDFe+/9T9dqT6ef8Owsqs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=svsF4DsJZiP2kJfoHR9wkk7DvpLcwQxPn6XMn6+KR88AUyhOCnHgy98ARyqsvSiJMR+S6a4r5yI09ui8b8meDVC3LuTxInmaShHXahonUsgvZVbMEmBC16bMN5T3CVFBdLm6gjQnN8Yxnqn9DxISL83h4y60YuXlCVATpmIqpAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SMnR5ZLu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SMnR5ZLu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9DE6C2BCB5;
	Tue, 28 Apr 2026 08:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777365176;
	bh=DJo9DLWnPxdlYFpATvmZ2FFDFe+/9T9dqT6ef8Owsqs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SMnR5ZLuPF2X6YxMYc2hVGwGWIBHWsy5LkX1y7zmrlWeBlFYsPC9Mh8LufQYG0Lmp
	 ft1DMguAJk+u7492BXIzccdfB5V/oD7aoLy68JQov9jxHQwWj9qWArKwel5HIHkybb
	 uZ288wyh7OfCJjHxHFkbo6osjUr/vDUXONxXSQCBVZXSBTYWUdCxKyhFAVNgyOisSj
	 yNu62H0ut2ZmmD5rx7bxNPcCrtbRBNV8H93RQ6VIXSsg7ZIGfnoFSOvpEeq8bW+Eg+
	 +AXZzMV9brfNbNX+uedZ53+rnX4SGejGUNLRwkkRnaNODm/RbaPVjEQTuJz/PBf6iE
	 1hKIGgBRgEb8Q==
Date: Tue, 28 Apr 2026 10:32:51 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Dave Young <ruirui.yang@linux.dev>,
	Gregory Price <gourry@gourry.net>
Subject: Re: [PATCH v3 05/17] x86/efi: Simplify real mode trampoline
 allocation quirk
Message-ID: <afBws32wHp4Cgrgj@kernel.org>
References: <20260423152024.1098465-19-ardb+git@google.com>
 <20260423152024.1098465-24-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260423152024.1098465-24-ardb+git@google.com>

On Thu, Apr 23, 2026 at 05:20:30PM +0200, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
> 
> To work around a common bug in EFI firmware for x86 systems, Linux
> reserves all EFI boot services code and data regions until after it has
> invoked the SetVirtualAddressMap() EFI runtime service. This is needed
> because those regions may still be accessed by the firmware during that
> call, even though the EFI spec says that they shouldn't.
> 
> This includes any boot services data regions below 1M, which might mean
> that by the time the real mode trampoline is being allocated, all memory
> below 1M is already exhausted.
> 
> Commit
> 
>   5bc653b73182 ("x86/efi: Allocate a trampoline if needed in efi_free_boot_services()")
> 
> added a quirk to detect this condition, and to make another attempt at
> allocating the real mode trampoline when freeing those boot services
> regions again. This is a rather crude hack, which gets in the way of
> cleanup work on the EFI/x86 memory map handling code.
> 
> Given that
> 
> - the real mode trampoline is normally allocated soon after all EFI boot
>   services regions are reserved temporarily,
> - this allocation logic marks all memory below 1M as reserved,
> - the trampoline memory is not actually populated until an early
>   initcall,
> 
> there is actually no need to reserve any boot services regions below 1M,
> even if they are mapped into the EFI page tables during the call to
> SetVirtualAddressMap(). So cap the lower bound of the reserved regions
> to 1M, and fix up the size accordingly when making the reservation. This
> allows the additional quirk to be dropped entirely.
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  arch/x86/platform/efi/quirks.c | 34 ++++----------------
>  1 file changed, 6 insertions(+), 28 deletions(-)
> 
> diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
> index e2e57e9201a9..e79fb94c1bf6 100644
> --- a/arch/x86/platform/efi/quirks.c
> +++ b/arch/x86/platform/efi/quirks.c
> @@ -324,10 +324,14 @@ void __init efi_reserve_boot_services(void)
>  		return;
>  
>  	for_each_efi_memory_desc(md) {
> -		u64 start = md->phys_addr;
> -		u64 size = md->num_pages << EFI_PAGE_SHIFT;
> +		u64 start = max(md->phys_addr, SZ_1M);

A comment that says that we don't reserve regions below 1M because they are
reserved elsewhere would be nice here. Other that that

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> +		u64 end = md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT);
> +		u64 size = end - start;
>  		bool already_reserved;
>  
> +		if (end <= start)
> +			continue;
> +
>  		if (md->type != EFI_BOOT_SERVICES_CODE &&
>  		    md->type != EFI_BOOT_SERVICES_DATA)
>  			continue;

-- 
Sincerely yours,
Mike.
