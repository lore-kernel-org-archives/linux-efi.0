From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v7 09/14] efi: passing kexec necessary efi data via
 setup_data
Date: Tue, 17 Dec 2013 16:08:42 +0800
Message-ID: <20131217080842.GA13339@dhcp-16-126.nay.redhat.com>
References: <1387186235-15972-1-git-send-email-dyoung@redhat.com>
 <1387186235-15972-10-git-send-email-dyoung@redhat.com>
 <20131217080140.GB12621@dhcp-16-126.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20131217080140.GB12621-je1gSBvt1TcFLmT5oZ11vB/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/kexec/>
List-Post: <mailto:kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=subscribe>
Sender: "kexec" <kexec-bounces-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Errors-To: kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, toshi.kani-VXdhtT5mjnY@public.gmane.org, matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org, greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, horms-/R6kz+dDXgpPR4JQBCEnsQ@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org


Hello Boris

Does this version looks good to you? Only mapping once in print_efi_memmap..

BTW, forgot to remove 'Re:' in subject.

Please let me know if there's any other issues or need I resend the series.

Most changes vs previous version are below:

> diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
> index b1fff8e..5438083 100644
> --- a/arch/x86/platform/efi/efi.c
> +++ b/arch/x86/platform/efi/efi.c
> @@ -78,6 +78,8 @@ static __initdata efi_config_table_type_t arch_tables[] = {
>  
>  static void *efi_runtime_map;
>  static int nr_efi_runtime_map;
> +u64 efi_setup;		/* efi setup_data physical address */
> +u32 efi_data_len;	/* efi setup_data payload length */
>  

[snip]

> +
> +static void get_nr_runtime_map(void)
> +{
> +	if (!efi_setup)
> +		return;
> +
> +	nr_efi_runtime_map = (efi_data_len - sizeof(struct efi_setup_data)) /
> +			     sizeof(efi_memory_desc_t);
> +}
> +
>  void __init efi_init(void)
>  {
>  	efi_char16_t *c16;
> @@ -638,6 +719,7 @@ void __init efi_init(void)
>  	int i = 0;
>  	void *tmp;
>  
> +	get_nr_runtime_map();
>  #ifdef CONFIG_X86_32
>  	if (boot_params.efi_info.efi_systab_hi ||
>  	    boot_params.efi_info.efi_memmap_hi) {
> @@ -676,6 +758,9 @@ void __init efi_init(void)
>  
		efi.systab->hdr.revision >> 16,
[snip]

>  
>  	/*
> diff --git a/arch/x86/platform/efi/efi_32.c b/arch/x86/platform/efi/efi_32.c
> index 7b3ec6e..249b183 100644
> --- a/arch/x86/platform/efi/efi_32.c
> +++ b/arch/x86/platform/efi/efi_32.c
> @@ -48,6 +48,7 @@ void __init efi_map_region(efi_memory_desc_t *md)
>  }
>  
>  void __init efi_map_region_fixed(efi_memory_desc_t *md) {}
> +void __init parse_efi_setup(u64 phys_addr, u32 data_len) {}
>  
>  void efi_call_phys_prelog(void)
>  {
> diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
> index ff08cb1..324b651 100644
> --- a/arch/x86/platform/efi/efi_64.c
> +++ b/arch/x86/platform/efi/efi_64.c
> @@ -228,3 +228,9 @@ void __iomem *__init efi_ioremap(unsigned long phys_addr, unsigned long size,
>  
>  	return (void __iomem *)__va(phys_addr);
>  }
> +
> +void __init parse_efi_setup(u64 phys_addr, u32 data_len)
> +{
> +	efi_setup = phys_addr + sizeof(struct setup_data);
> +	efi_data_len = data_len - sizeof(struct setup_data);
> +}
> -- 
> 1.8.3.1
> 
