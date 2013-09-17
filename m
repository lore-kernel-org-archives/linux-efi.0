From: Matt Fleming <matt@console-pimps.org>
Subject: Re: [PATCH] EFI: use nr_tables param directly in efi_config_init
Date: Tue, 17 Sep 2013 16:49:21 +0100
Message-ID: <20130917154921.GH3409@console-pimps.org>
References: <20130912084528.GA13448@dhcp-16-126.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130912084528.GA13448@dhcp-16-126.nay.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Young <dyoung@redhat.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, vgoyal@redhat.com
List-Id: linux-efi@vger.kernel.org

On Thu, 12 Sep, at 04:45:28PM, Dave Young wrote:
> efi_config_init has the parameter nr_tables. Just use it instead of
> dereference efi.systab->nr_tables.
> 
> Signed-off-by: Dave Young <dyoung@redhat.com>
> ---
>  arch/x86/platform/efi/efi.c |    7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> --- linux-2.6.orig/arch/x86/platform/efi/efi.c
> +++ linux-2.6/arch/x86/platform/efi/efi.c
> @@ -599,7 +599,7 @@ static int __init efi_config_init(u64 ta
>  
>  	tablep = config_tables;
>  	pr_info("");
> -	for (i = 0; i < efi.systab->nr_tables; i++) {
> +	for (i = 0; i < nr_tables; i++) {
>  		efi_guid_t guid;
>  		unsigned long table;
>  
> @@ -612,8 +612,7 @@ static int __init efi_config_init(u64 ta
>  			if (table64 >> 32) {
>  				pr_cont("\n");
>  				pr_err("Table located above 4GB, disabling EFI.\n");
> -				early_iounmap(config_tables,
> -					      efi.systab->nr_tables * sz);
> +				early_iounmap(config_tables, nr_tables * sz);
>  				return -EINVAL;
>  			}
>  #endif
> @@ -648,7 +647,7 @@ static int __init efi_config_init(u64 ta
>  		tablep += sz;
>  	}
>  	pr_cont("\n");
> -	early_iounmap(config_tables, efi.systab->nr_tables * sz);
> +	early_iounmap(config_tables, nr_tables * sz);
>  	return 0;
>  }

Thanks Dave, but this patch should no longer be necessary because of the
changes sitting in the 'next' branch at,

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git

-- 
Matt Fleming, Intel Open Source Technology Center
