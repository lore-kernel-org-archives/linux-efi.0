Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 498C413D886
	for <linux-efi@vger.kernel.org>; Thu, 10 Sep 2026 07:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789026818; cv=none; b=hJoRBLVPDH0QK/nPpp0vKAFTu6IwiIK4heRKJocK12LNZ/QfjBk5rR9yYXxQhceTcTy2aBlpb2DgfcjoF7wWNL6znoSeFJbvq8ls3Kis2o1lBcufguDriwAChyogtqxOh4vFOESvBNf3hqolVH2L+v8XQASBCBWT6oz4FUSCZbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789026818; c=relaxed/simple;
	bh=VifgjBx4o5YOa1mgKjLVMaWXawUaIZCGEGZx8ySrxwE=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=psvy4jh75TmQObSpu04br9iCbUwUDiGJcukwksRlWhS1HugJ/vK8QJB1BZCl6+pJ2XPjXoXTqJJdYx8ut8XIVx56TQTtyC4JSjt9H6AqBuMmJ7RjQrVDTxuKmZy6azPYD9gqbiyTjJp9N21haSY+BffmnQz+uK/9i+ElXVKB5wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dT6HeNiG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dT6HeNiG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92CB11F00898;
	Thu, 10 Sep 2026 07:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789026817;
	bh=jgKxlw2lLVblwi+QhFBTRDP3s7qMEEumx97pBaUADHo=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=dT6HeNiGMF43/gjVHz7iJF8/6dJA7Fn4Kh7424qu6WCU3mcYvMHA+X4OcKq3SUgHu
	 DdYBfSzLg6S8IYeA5gcjT2bTQg0THWIqveBFa76EwvfOB65fdWKtMFH1n1y4Yw6AWw
	 /u/mPn7KL/n3BiUfdriuIpr5fNq4Q3f4JZiAW6+jfNnlxZSnPywP/BHndp3+jtyucc
	 7NwsnSLcGkcRFItDlo5Zby4CEg2kBGQ7xyrTXB3kttvZyaNxLF3EwqrWe1ihWqCvlB
	 IUdCOS6so/z6/DFBkuWualvvwaFIU8oA3enMhnk0qbt0DWGGrujf8XDoZN8XqwfsUy
	 0Qf8zBcr+6zEQ==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 0BFB2198003A;
	Thu, 10 Sep 2026 03:53:35 -0400 (EDT)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Thu, 10 Sep 2026 03:53:35 -0400
X-ME-Sender: <xms:_WGiaoQ2XAdrAk4zHL58Ho49WTkps0YgndccMvdkP1M1WJW-upUEJA>
    <xme:_WGiagmifJBNRvPTclSGCB9jpmtsi4ulCR4mW6zH2JupdlM-Glr3_SwPSUc_zy-Db
    7e4uZpk4UCGwfF6h62U6hUHOu7e5xh3OIaFQliFFALFgrTJA06CiIgO>
X-ME-Proxy-Cause: dmFkZTEmhSEeZiUdG3XmtlcScG4+j9IeaOGnAcX+S5yZ00PQ20oQaWWQ2hR9h9cjShQV4p
    1jvmviI0DPV8v5K4KGmEkn8iE5B8FMEpPaoNMlST93r3TlIZd9r8CqjUsWShQR0jwTZPn2
    xV9WR9vcnggSnUacI6/rvRyzj77Xs4345qkx7QJvIrPFh7PZBSR7+2JXZeCnol3i7efnni
    2+HbITTtYxsSDvrzXnYCBlAWA5vYsjrBA3FV5L2/DiHoXfkFHCHijJ1OuXyTQyr4NTlVOq
    ZQn3+M2jztd/LTSQlLkRmMfrFx7RsrD9KIq7ChC2WJuXm8ZUCi/7ZWqDtd0Yq4nUfdSFGl
    bz80XRgqQH04GhVuwAbCiv12ar5iLULic+DTwCZotEZBDJ3+lQzCTf3v0jwy1JYcE7/52v
    coJd2g+VUa+5cHt0hbywXiD4R5c/2RjNNgv5EQ8Ha1XEIWdok7vLuhh9/bggW4dcBz/DJ+
    uefMFWo817AELz6J+ex6G0PmqFC1rTYRBPsuG8vqDNCQ0nS2awcYWB5jI4sSUZXvXX6ZuN
    YWydkVaYwr+2LA2pU2KCZ23Dj+fuz/QkrDhw4/smUsf8kQQUdspzcy+wury9MxfSYwmixz
    48VY+jl/T2K/gKkjpjuW3X5RUdRdDMWOp+GrO82FKkQjymnbqpVjtSsVfPkQ
X-ME-Proxy: <xmx:_2Giav2-YavfuTr3-bQQTJxOeearq4P1Z3j6qveXnH2gwPI6EN2F5Q>
    <xmx:_2GiamSw4wP5owQBgMznPlopyGFreoJMJDJS6fBgXyPpD8iqI9J5uw>
    <xmx:_2Giare0Fhb8NKqdGywOnt0ZW77NLxtmZLcYesv3DP2VMzEAQBQjTw>
    <xmx:_2GiavfhM3svfxFjTHbRbhQQg4XFr0r-qUjudiNKR5kCNsFw-ERZbg>
    <xmx:_2Giat1jHYt9d_HRidkJruRVVpFQPaMawRflbtoFk12VXhnJfqx-COxk>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 1A7DAF8007D; Thu, 10 Sep 2026 03:53:33 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Thu, 10 Sep 2026 09:53:12 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Eshaan Deshmukh" <eshaan2031@icloud.com>,
 "Thomas Gleixner" <tglx@kernel.org>, "Ingo Molnar" <mingo@redhat.com>,
 "Borislav Petkov" <bp@alien8.de>, dave.hansen@linux.intel.com, x86@kernel.org
Cc: "Ilias Apalodimas" <ilias.apalodimas@linaro.org>,
 "H . Peter Anvin" <hpa@zytor.com>, linux-efi@vger.kernel.org,
 linux-kernel@vger.kernel.org
Message-Id: <c321dc7d-7cee-4222-a346-fa0448ce4f74@app.fastmail.com>
In-Reply-To: <20260810102237.2167872-1-eshaan2031@icloud.com>
References: <20260810102237.2167872-1-eshaan2031@icloud.com>
Subject: Re: [PATCH] x86/efi: Handle errors for efi_map_region_fixed()
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hello Eshaan,

On Mon, 10 Aug 2026, at 12:22, Eshaan Deshmukh wrote:
> The function efi_map_region_fixed() ignores the errors returned from
> kernel_map_pages_in_pgd(). If mapping failes, this can cause page
> faults. Update __map_region() and efi_map_region_fixed() to return the
> error code from kernel_map_pages_in_pgd(). If there is an error,
> efi_map_region_fixed() logs an error message using pr_err(), disables
> EFI runtime services, and returns.
>

Does this solve an actual problem that you observed?

> Signed-off-by: Eshaan Deshmukh <eshaan2031@icloud.com>
> ---
>  arch/x86/include/asm/efi.h     |  2 +-
>  arch/x86/platform/efi/efi.c    | 10 ++++++++--
>  arch/x86/platform/efi/efi_32.c |  6 +++++-
>  arch/x86/platform/efi/efi_64.c | 20 ++++++++++++++------
>  4 files changed, 28 insertions(+), 10 deletions(-)
>
> diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
> index be58b7f5c..04952e064 100644
> --- a/arch/x86/include/asm/efi.h
> +++ b/arch/x86/include/asm/efi.h
> @@ -128,7 +128,7 @@ extern bool efi_disable_ibt_for_runtime;
>  extern int __init efi_memblock_x86_reserve_range(void);
>  extern void __init efi_print_memmap(void);
>  extern void __init efi_map_region(efi_memory_desc_t *md);
> -extern void __init efi_map_region_fixed(efi_memory_desc_t *md);
> +extern int __init efi_map_region_fixed(efi_memory_desc_t *md);
>  extern void efi_sync_low_kernel_mappings(void);
>  extern int __init efi_alloc_page_tables(void);
>  extern int __init efi_setup_page_tables(unsigned long pa_memmap, 
> unsigned num_pages);
> diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
> index 0c39adb96..4b875843a 100644
> --- a/arch/x86/platform/efi/efi.c
> +++ b/arch/x86/platform/efi/efi.c
> @@ -735,8 +735,14 @@ static void __init kexec_enter_virtual_mode(void)
>  	* Map efi regions which were passed via setup_data. The virt_addr is a
>  	* fixed addr which was used in first kernel of a kexec boot.
>  	*/
> -	for_each_efi_memory_desc(md)
> -		efi_map_region_fixed(md); /* FIXME: add error handling */
> +	for_each_efi_memory_desc(md) {
> +		if (efi_map_region_fixed(md)) {
> +			pr_err("Failed to map fixed EFI region\n");
> +			clear_bit(EFI_RUNTIME_SERVICES, &efi.flags);
> +			return;
> +		}
> +
> +	}
> 
>  	/*
>  	 * Unregister the early EFI memmap from efi_init() and install
> diff --git a/arch/x86/platform/efi/efi_32.c 
> b/arch/x86/platform/efi/efi_32.c
> index b2cc7b455..9307999b9 100644
> --- a/arch/x86/platform/efi/efi_32.c
> +++ b/arch/x86/platform/efi/efi_32.c
> @@ -84,7 +84,11 @@ int __init efi_setup_page_tables(unsigned long 
> pa_memmap, unsigned num_pages)
>  	return 0;
>  }
> 
> -void __init efi_map_region_fixed(efi_memory_desc_t *md) {}
> +int __init efi_map_region_fixed(efi_memory_desc_t *md)
> +{
> +	return 0;
> +}
> +
>  void __init parse_efi_setup(u64 phys_addr, u32 data_len) {}
> 
>  efi_status_t efi_call_svam(efi_runtime_services_t * const *,
> diff --git a/arch/x86/platform/efi/efi_64.c 
> b/arch/x86/platform/efi/efi_64.c
> index 5861008ea..05f1df6ca 100644
> --- a/arch/x86/platform/efi/efi_64.c
> +++ b/arch/x86/platform/efi/efi_64.c
> @@ -269,12 +269,12 @@ int __init efi_setup_page_tables(unsigned long 
> pa_memmap, unsigned num_pages)
>  	return 0;
>  }
> 
> -static void __init __map_region(efi_memory_desc_t *md, u64 va)
> +static int __init __map_region(efi_memory_desc_t *md, u64 va)
>  {
>  	unsigned long flags = _PAGE_RW;
>  	unsigned long pfn;
>  	pgd_t *pgd = efi_mm.pgd;
> -
> +	int error;
>  	/*
>  	 * EFI_RUNTIME_SERVICES_CODE regions typically cover PE/COFF
>  	 * executable images in memory that consist of both R-X and
> @@ -299,9 +299,11 @@ static void __init __map_region(efi_memory_desc_t 
> *md, u64 va)
>  		flags |= _PAGE_ENC;
> 
>  	pfn = md->phys_addr >> PAGE_SHIFT;
> -	if (kernel_map_pages_in_pgd(pgd, pfn, va, md->num_pages, flags))
> +	error = kernel_map_pages_in_pgd(pgd, pfn, va, md->num_pages, flags);
> +	if (error)
>  		pr_warn("Error mapping PA 0x%llx -> VA 0x%llx!\n",
>  			   md->phys_addr, va);
> +	return error;
>  }
> 
>  void __init efi_map_region(efi_memory_desc_t *md)
> @@ -357,10 +359,16 @@ void __init efi_map_region(efi_memory_desc_t *md)
>   * md->virt_addr is the original virtual address which had been mapped in kexec
>   * 1st kernel.
>   */
> -void __init efi_map_region_fixed(efi_memory_desc_t *md)
> +int __init efi_map_region_fixed(efi_memory_desc_t *md)
>  {
> -	__map_region(md, md->phys_addr);
> -	__map_region(md, md->virt_addr);
> +	int error;
> +
> +	error = __map_region(md, md->phys_addr);
> +
> +	if (error)
> +		return error;
> +
> +	return __map_region(md, md->virt_addr);
>  }
> 
>  void __init parse_efi_setup(u64 phys_addr, u32 data_len)
> -- 
> 2.55.0
