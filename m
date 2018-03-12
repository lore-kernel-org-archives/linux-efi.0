From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 2/5] x86/efi: Replace efi_pgd with efi_mm.pgd
Date: Mon, 12 Mar 2018 10:02:20 +0100
Message-ID: <20180312090220.lmohpvj62v7l2qsc@gmail.com>
References: <20180312084500.10764-1-ard.biesheuvel@linaro.org>
 <20180312084500.10764-3-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180312084500.10764-3-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-efi@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Sai Praneeth <sai.praneeth.prakhya@intel.com>, linux-kernel@vger.kernel.org, "Lee, Chun-Yi" <jlee@suse.com>, Borislav Petkov <bp@alien8.de>, Tony Luck <tony.luck@intel.com>, Andy Lutomirski <luto@kernel.org>, "Michael S . Tsirkin" <mst@redhat.com>, Bhupesh Sharma <bhsharma@redhat.com>, Ricardo Neri <ricardo.neri@intel.com>, Ravi Shankar <ravi.v.shankar@intel.com>
List-Id: linux-efi@vger.kernel.org


* Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:

> From: Sai Praneeth <sai.praneeth.prakhya@intel.com>
> 
> Since the previous patch added support for efi_mm, let's handle efi_pgd
> through efi_mm and remove global variable efi_pgd.
> 
> Signed-off-by: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
> Cc: "Lee, Chun-Yi" <jlee@suse.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Tony Luck <tony.luck@intel.com>
> Cc: Andy Lutomirski <luto@kernel.org>
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Cc: Bhupesh Sharma <bhsharma@redhat.com>
> Cc: Ricardo Neri <ricardo.neri@intel.com>
> Cc: Ravi Shankar <ravi.v.shankar@intel.com>
> Tested-by: Bhupesh Sharma <bhsharma@redhat.com>
> Reviewed-by: Matt Fleming <matt@codeblueprint.co.uk>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  arch/x86/platform/efi/efi_64.c | 17 ++++++++---------
>  1 file changed, 8 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
> index 0045efe9947b..8881e601c32d 100644
> --- a/arch/x86/platform/efi/efi_64.c
> +++ b/arch/x86/platform/efi/efi_64.c
> @@ -190,8 +190,6 @@ void __init efi_call_phys_epilog(pgd_t *save_pgd)
>  	early_code_mapping_set_exec(0);
>  }
>  
> -static pgd_t *efi_pgd;
> -

Hm, so there's some interaction here with:

  116fef640859: x86/mm/dump_pagetables: Add the EFI pagetable to the debugfs 'page_tables' directory

which is in tip:x86/mm.

Could you please resolve that conflict? I'll sort out the topic branches 
afterwards.

Thanks,

	Ingo
