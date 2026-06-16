Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D3073B9D97;
	Tue, 16 Jun 2026 12:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781611853; cv=none; b=kjAGke+lVhD1C/MJsGnWj5ULKglmJwJD2twBDMYOiUWU6uQpHZcD/uOoVKiwNFUh4BKNr56rz1/6dJ4k97Xr0mhYmSpDUlQZjUTfFGd+NOiG6+u8yoA1FP5ig+4HKoFd9dQJTt8hMyLGFXLyuBLRKc5QOR6UGO0FteRL9KzbAhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781611853; c=relaxed/simple;
	bh=hgvzVOV/yi4NmqBy3wj/OQdnUNQXHzuZAdvJWy7t/Pg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SP1fPOA/XwJT/GGrEneTYwJ0FIw3kaZhitwUpP5stj6MZJNvP+g2tEUpr2BAGxDgptm880noog33JE1z61qLmZGRyGndJvDAqUycrAs2/DAcM1RiYgTKAqczhrRdg9tJ1+jcM83AjLx3X9xBmlWiZFRI63hz3rpUrb4sWiu4SHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=qu266pM5; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="qu266pM5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=DmxqFHA1EQE/yqMqEUO6PKW/i3Bta7/e5+QC+vF9Rvc=; b=qu266pM5cdR99k5R1+oZ1XzLyW
	FBaN0c5/KyySQOw4Nbr1S9T+KOI4OeggndDA3VJW2sakOqSVxGuZS4b5DdfINXNDymV0Ef4YLs4tg
	qYq1GcAugihnsi/ABJGMZ15gYHgp2VnZpLCSWdl9FPTL+d651fjtWR+PMAqQyQIvt6Ub+zXCdvVw/
	oKHLgVmrATuzLI/bVYRda0iCilmStpHW+OnxbxFBp1BLQbjwlD0kBgJSZqGWgzpsuf1Ofs66WQ6w+
	wCSRZL39YlHMfFaZN4qqmrWxLQyrpgGdcUBFi+olcd7LMMcyiVq5GTBqu7EAZq1W9IShs4gn+J+fe
	nMhbfpfw==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wZSco-00Dpve-1E;
	Tue, 16 Jun 2026 12:10:38 +0000
Date: Tue, 16 Jun 2026 05:10:33 -0700
From: Breno Leitao <leitao@debian.org>
To: Ard Biesheuvel <ardb@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Borislav Petkov <bp@suse.de>, Andy Lutomirski <luto@kernel.org>, 
	Kees Cook <kees@kernel.org>, Tony Luck <tony.luck@intel.com>, 
	"Guilherme G. Piccoli" <gpiccoli@igalia.com>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v2 5/6] efi/runtime-wrappers: honour EFI_RUNTIME_SERVICES
 in the non-blocking paths
Message-ID: <ajEzSSE_JC2zN-WL@gmail.com>
References: <20260612-efi_timeout-v2-0-f714bb016df6@debian.org>
 <20260612-efi_timeout-v2-5-f714bb016df6@debian.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260612-efi_timeout-v2-5-f714bb016df6@debian.org>
X-Debian-User: leitao

On Fri, Jun 12, 2026 at 04:01:32AM -0700, Breno Leitao wrote:
> Three wrappers call firmware directly instead of going through
> __efi_queue_work(), and none of them check whether runtime services are
> still enabled: virt_efi_set_variable_nb(),
> virt_efi_query_variable_info_nb() and virt_efi_reset_system(). Once a
> hang has cleared EFI_RUNTIME_SERVICES - or efi_recover_from_page_fault()
> has cleared it on a firmware page fault - these paths still enter the
> (possibly wedged) firmware, e.g. an EFI pstore write through the
> non-blocking SetVariable() variant, in violation of UEFI's
> non-reentrancy rules. reset_system() is reachable too: efi_reboot()
> only gates it on the static efi_rt_services_supported() mask, which does
> not track the runtime disable.
> 
> Check efi_enabled(EFI_RUNTIME_SERVICES) at the top of each before taking
> efi_runtime_lock and calling into firmware.
> 
> Suggested-by: Ard Biesheuvel <ardb@kernel.org>
> Signed-off-by: Breno Leitao <leitao@debian.org>
> ---
>  drivers/firmware/efi/runtime-wrappers.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/drivers/firmware/efi/runtime-wrappers.c b/drivers/firmware/efi/runtime-wrappers.c
> index 8badf0419a148..842f72d44211f 100644
> --- a/drivers/firmware/efi/runtime-wrappers.c
> +++ b/drivers/firmware/efi/runtime-wrappers.c
> @@ -461,6 +461,9 @@ virt_efi_set_variable_nb(efi_char16_t *name, efi_guid_t *vendor, u32 attr,
>  {
>  	efi_status_t status;
>  
> +	if (!efi_enabled(EFI_RUNTIME_SERVICES))
> +		return EFI_DEVICE_ERROR;
> +
>  	if (down_trylock(&efi_runtime_lock))
>  		return EFI_NOT_READY;

Shashiko reported a good feedback, that the check for
EFI_RUNTIME_SERVICES needs to be inside the efi_runtime_lock to avoid
TOCTOU issues. Fixing it and respining.
