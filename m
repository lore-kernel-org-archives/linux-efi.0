Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.224.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795511790;
	b=N1pnKgx4HM/v+1JdiS8Xqk0bM7/y4I42dxX1938QpheOnhJwjlPswKFWkGiZ1RNdsVap
	 A711fr58Z/9YLmAhfSviDqakMuaWMbURxEYypGvKvAEzFjm/RUU1Vvm4mt8WoYYJDudMw
	 YiyI5QGKIqBeS8yAIex3J3oeCib6nMuglqlgypY+5c46EnL6wnajH6bUZF/bTfePcLagy
	 7jSnInE9so+4DU4tqzA0+eFFJv7vD5FR6Dm8eenhFHUS7ikuLMlHrQ+AC4NC+68FzBVVy
	 8P6KVqCTcQHOfYew27OtiUAI9+41DRSH6uaxtEzpDsZDOrQV21saG1yzJIwwcRY7Y+g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795511790;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type;
	bh=FigzmZe8QSMtKMdZJAWWsx/Pt0yDdHs90SYDISxeiVs=;
	b=D1u+hGT8voeRquP7P2QvGmInP/TRRNnx3MEM56hXlw+kIyvVx9tia15VNxex2XFERhjO
	 e79p5yKt+3e5fAr0VDPGhTe7vDSZgkEsUel4wFt4ufka3xUWB8Imhs83UxeIYTT6x4SrW
	 Ksj4wGTLB4tO2aBHJGP1UZzeeBsW9pP8e+Gf3JtBuV1o1P8Sc1hM/uQOsM4y6/GXsIlMB
	 Ho6x1ZOIWQ+k2TtSVO2nwWgW13chW9HK5RV5WzFAI7Fg1jKbNr7XRQ2nh12MG7vqKk61W
	 BAzOgy9Uz53792LeZR4RyyP4oLtxwq/UquayqPAf9oUegGCnIE6iuA9XQsExGGR9ZoQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linaro.org;
	spf=pass smtp.mailfrom=linaro.org;
	dkim=pass header.d=linaro.org header.i=@linaro.org header.a=rsa-sha256 header.s=google header.b=uRg9uu+q;
	arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.224.42
Received: from mail-yx1-f42.google.com (mail-yx1-f42.google.com [74.125.224.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D462606A31E
	for <linux-efi@vger.kernel.org>; Tue, 24 Nov 2026 09:16:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2D462606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=linaro.org header.i=@linaro.org header.a=rsa-sha256 header.s=google header.b=uRg9uu+q
Received: by mail-yx1-f42.google.com with SMTP id 956f58d0204a3-67be1e468a8so3962128d50.0
        for <linux-efi@vger.kernel.org>; Tue, 24 Nov 2026 01:16:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795511789; cv=none;
        d=google.com; s=arc-20260327;
        b=naobgb+vRZXtUuAlqZ82IGNukhhrSw9E0utYCmCA4Uh0BnF2MtNUh98/8mj+FkZK4b
         O6YhKWd4NN2+ZAVshiQVzsg6V5GNnHxh3sh2ZK0SWS4jkZHNZUX5FWDkBX0jX6k/xBsd
         7JURpRGbyBea7OVUzIG9xZfm4x7drA5Nm5satiPPsgfKl54I6GvoFOmGvaBWiIomFKhJ
         T35rarfPz5Q/rDUmQfD61RMPNo2KaPXsWaDZXre5zGxR8jm4fuNMWlEmhViee5ErBSPS
         p9fXyaDLnYN5tgzTIpNbUHHUW7QTm9vLYkE3eSE/rN5hKurIboza6qi7TzvEITSOJW6B
         sMFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=FigzmZe8QSMtKMdZJAWWsx/Pt0yDdHs90SYDISxeiVs=;
        fh=qX+BTY6ap+jCMmEdYIQz82D/Yn0iwjadX958oAqtPDA=;
        b=iUxHT5G9zw7PBtAG7FN2+EEuReCLD8ZcPf1rS1wk6vSY5RsPsgdu2yCK+Xs8OzLruS
         hLHYKsG0dr1+2p/3FdaGPPPegc/qUrTzvtrZoZBDr/AxrDCsHDZcX7ItguZ6qKrvFElo
         6nk2uoTgHG6/FlF4/z0bNOVqd549eTIYH0cvre+jKyEkguIBfSf4kimWmgt/ff9GTXWZ
         avGgD8x5z/yF1xqcTESIoibR6tJnA41RFJiIJ6VQBdR3Deq9xImkPbk6R8lfYwWUbOCF
         +FD+GtIU0YuxKTEuEhClO+XDIGDb73uQDP7By8J/faBVfwVx9aaRqbU4PU7NyI9ztlwt
         a64A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1795511789; x=1796116589; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FigzmZe8QSMtKMdZJAWWsx/Pt0yDdHs90SYDISxeiVs=;
        b=uRg9uu+qazOGsyXsMZC32IHbyCggvMJkbs88ut5W0LpIg7NuFCyGLFLuyqIYTU+RRM
         P/d/NAsN5zzRyPcUuLoSsw2JqRsQwoxtBdRCR46H2qYb2P0BRFqiir5Be9NjocF3xtGe
         8r7Bu0GqbWMTql8pyZbEuQ9tB9ggHfeKVmMtCRfOtZ1D5C4e87bqKD9zad4M0P2reOty
         dGZiIim+D2PVlSTeOp8H4n4PryqAmPnSF19TRlWQKpQTJPeonFX7uqQORyE4kp2EMwPD
         0UN3UfFvxFNAqhhJSEmoPe2yEZY/LazyyMkSLxf1hJrDdxt3ahpg+tm0keMbBCQbnSQP
         LS4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795511789; x=1796116589;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=FigzmZe8QSMtKMdZJAWWsx/Pt0yDdHs90SYDISxeiVs=;
        b=uc/wgo6JbyGpRKJfw+bYhrSnSgI3++JiOBuA+vChWr3YNHY73PB65t237cHRSjW9cA
         omSE63X9UV+s811hUMpeWLqUIf7Hcijn9QjxE7YK/Kdw3DE2pg30KDmvEU5KhzoH+K3u
         rbNjwG41fccT31Gzu0F4FyD/fKBMQ8Ix9o6HNLWM9Y5A7LwGpjxQ93hU3/VsmFaBK+3s
         hchg26otj2k9oX80BcAgbSDRBRerk3bwwSE+r/yF6g6S5SQyDFYYZ/K066oFhNj5MaxJ
         oMM4gpDUb7P5fpD9W7egOKOyP9AQh+qGfPdSY01h8/xF6rtVe/SkpkDsx3AT3BO98gMy
         LGZg==
X-Gm-Message-State: APuU4Z+TV9B0rPXwVdAyHkCfn98C4RwwZoLWEktAmo1p5zr6hY30MZod
	O2p2zn8E48pK5AptFQoUn4ImUQdgOvwSNh+YqOAMHKt5qSI/ELJ6mxD5lCNxanGtLFpDtg5MYPx
	47ixwYYeju+c23VS2IF0db66kx6i7VYArk7okr2zdeQ==
X-Gm-Gg: AZFdTZd6RhyN1EnTlUr05Lytn028CrfYH+VlZ7nv9IOk1sCYwUbixZHzIqkgjyfv4/p
	lzhjSPpidP0lsxpsa/A2Sn8I0Sz9GvRYrIQ1fFb4XSnC1CIJmGGENH5hQoTJN+bbx/baGTNBA3O
	rv0VNd1TV5TyHNEk17KmZA52pDl2n4lu8WzYuxZjQHWbqbUJ06jyJ6HCLJenS/zwRWLavGjIw9p
	QCylQ+oXfGwk9NBNXDiGMM7tnsWMpTWSyCqy81bZo1Ukh1TbQPmqkThWcXKK4HhT6THfUYPsgub
	NbRuBoDMmdBFlpLH5bbLWcnwrUOHTQXqcMLrkb5MghUj+Rsfz2QlBnHlDaCIPm1ZjJxZBIwV+bz
	FoNHADKEFE8KA4+24QSstq9DDEX7uhKGkFEMy001me6CjjzgejTxbCq9uwoIxqS5uQPyCMd/rFz
	KiFR8Em1tCUrYeRLNLXcYLLXnEdhnEBB/6ePZE09IHVqG28TJRochqUVNJZfPosOYVZ5nlmQFvK
	ZoBmCnn4Pw4tdgUOX6pl1axrIH6jWgndjG4v8Af0gKaIG9NkjbYTzwr0fFnkSyeVykhJuQN0SXI
	KqR4nFWB9wZO+9GbMjfh24g2gv0AAwl5v1JiIysw6nr7ZxMIHpxR4/gXFQAVrTz5kIIZA04X9Y3
	mVzU+bLurz5Q4POPLpdpX2cxc+5AejsN3rMNkYFK8FYk2dh79500J+MasEovKGgSRLsojTGBBuX
	xznDAfJeNfS1cFUzioHOLX3s/CkRjPmrrbXUbH+usN46bIBYEoi7IRr2hjCuoTR+fjzpYpsR4=
X-Received: by 2002:a05:690e:bc7:b0:67c:332f:3fd8 with SMTP id
 956f58d0204a3-67df42bab97mr5911764d50.5.1795511788969; Tue, 24 Nov 2026
 01:16:28 -0800 (PST)
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261123094228.466164-4-ardb+git@google.com> <20261123094228.466164-6-ardb+git@google.com>
In-Reply-To: <20261123094228.466164-6-ardb+git@google.com>
From: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Date: Tue, 24 Nov 2026 11:15:52 +0200
X-Gm-Features: Aa3M54qSV-swmtVdFhCoOL-Bq6UxBFVpOCX8GHHHci_kphmx3snCRDWgxww1w68
Message-ID: <CAC_iWjK3hi6ErRCcFKaAfkXC_ug-KdROTT_5Y4p8e6uV+PX0zA@mail.gmail.com>
Subject: Re: [PATCH 2/2] efi/tpm: Allocate the event log from EFI loader data again
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-efi@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>, 
	"Jasmeet (Jazz) Bhatia" <jasmeet.bhatia.us@gmail.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, 23 Nov 2026 at 11:42, Ard Biesheuvel <ardb+git@google.com> wrote:
>
> From: Ard Biesheuvel <ardb@kernel.org>
>
> The EFI stub currently allocates the TPM event log as
> EFI_ACPI_RECLAIM_MEMORY. On x86, this becomes an ACPI data entry
> in the E820 map.
>
> On a Framework Laptop 16 (AMD Ryzen AI 300 Series), the EFI allocator
> can place this allocation at different physical addresses across boots.
> Since x86 hibernation validates architecture-specific data from
> the firmware E820 map, this causes an otherwise valid hibernation image
> to be rejected on resume with the following error:
>
>   Hibernate inconsistent memory map detected!
>   PM: hibernation: Image mismatch: architecture specific data
>
> Allocating the event log as EFI_LOADER_DATA avoids changing the E820
> map, but doing that alone would regress the kexec corruption issue fixed
> by commit 77d48d39e991 ("efistub/tpm: Use ACPI reclaim memory for event
> log to avoid corruption"): the E820 map that kexec passes on to the next
> kernel describes EFI loader data as ordinary RAM, and so the event log
> may get clobbered before the next kernel gets around to reserving it.
>
> So use the x86 implementation of efi_config_table_is_usable() to
> disregard the TPM event log table after kexec, just like the INITRD
> table, and go back to allocating it as EFI_LOADER_DATA. This is simpler
> than preserving the event log across kexec, e.g., by installing the
> memreserve table on x86 and using efi_mem_reserve_persistent(), and the
> utility of the event log after kexec is questionable to begin with.
>
> This also protects kexec'd kernels from a clobbered event log if the
> previous kernel predates the change above, and allocated the table from
> EFI loader data as well. The kexec issue was specific to x86, so other
> architectures can use EFI loader data as before.
>
> Fixes: 77d48d39e991 ("efistub/tpm: Use ACPI reclaim memory for event log to avoid corruption")
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---

Reviewed-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>

>  arch/x86/platform/efi/efi.c        | 6 ++++++
>  drivers/firmware/efi/libstub/tpm.c | 2 +-
>  2 files changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
> index c2817c7415ce..db1b179db0a5 100644
> --- a/arch/x86/platform/efi/efi.c
> +++ b/arch/x86/platform/efi/efi.c
> @@ -442,6 +442,11 @@ static int __init efi_systab_init(unsigned long phys)
>   *   data, which is released to the page allocator once the kernel is up and
>   *   running, and so the table is stale by the time kexec boots the next kernel.
>   *
> + * - The TPM event log table is installed by the EFI stub too, and allocated
> + *   from EFI loader data as well. It is reserved by the kernel, but the E820
> + *   memory map that kexec passes on describes it as ordinary RAM, and so it
> + *   may get clobbered before the next kernel gets around to reserving it.
> + *
>   * - The Memory Attributes table may reside in EFI boot services data, which is
>   *   released to the page allocator as well. Even if it is still intact, the
>   *   sanity check in efi_memattr_init() may fail spuriously, given that only
> @@ -455,6 +460,7 @@ bool __init x86_efi_config_table_is_usable(const efi_guid_t *guid,
>                 return true;
>
>         return efi_guidcmp(*guid, LINUX_EFI_INITRD_MEDIA_GUID) &&
> +              efi_guidcmp(*guid, LINUX_EFI_TPM_EVENT_LOG_GUID) &&
>                efi_guidcmp(*guid, EFI_MEMORY_ATTRIBUTES_TABLE_GUID);
>  }
>
> diff --git a/drivers/firmware/efi/libstub/tpm.c b/drivers/firmware/efi/libstub/tpm.c
> index 73f001114732..b8183bfdbaa3 100644
> --- a/drivers/firmware/efi/libstub/tpm.c
> +++ b/drivers/firmware/efi/libstub/tpm.c
> @@ -96,7 +96,7 @@ static void efi_retrieve_tcg2_eventlog(int version, efi_physical_addr_t log_loca
>         }
>
>         /* Allocate space for the logs and copy them. */
> -       status = efi_bs_call(allocate_pool, EFI_ACPI_RECLAIM_MEMORY,
> +       status = efi_bs_call(allocate_pool, EFI_LOADER_DATA,
>                              sizeof(*log_tbl) + log_size, (void **)&log_tbl);
>
>         if (status != EFI_SUCCESS) {
> --
> 2.56.1.750.gf70dc682cf-goog
>
>
