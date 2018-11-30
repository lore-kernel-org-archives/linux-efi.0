From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 01/11] x86/efi: Allocate e820 buffer before calling
 efi_exit_boot_service
Date: Fri, 30 Nov 2018 08:29:53 +0100
Message-ID: <20181130072952.GA16084@gmail.com>
References: <20181129171230.18699-1-ard.biesheuvel@linaro.org>
 <20181129171230.18699-2-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181129171230.18699-2-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-efi@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, Arend van Spriel <arend.vanspriel@broadcom.com>, Bhupesh Sharma <bhsharma@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@intel.com>, Eric Snowberg <eric.snowberg@oracle.com>, Hans de Goede <hdegoede@redhat.com>, Joe Perches <joe@perches.com>, Jon Hunter <jonathanh@nvidia.com>, Julien Thierry <julien.thierry@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Nathan Chancellor <natechancellor@gmail.com>, Peter Zijlstra <peterz@infradead.org>, Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>, Sedat Dilek <sedat.dilek@gmail.com>, YiFei Zhu <zhuyifei1999@gmail.com>
List-Id: linux-efi@vger.kernel.org


* Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:

> From: Eric Snowberg <eric.snowberg@oracle.com>
> 
> Commit d64934019f6c ("x86/efi: Use efi_exit_boot_services()")
> introduced a regression on systems with large memory maps
> causing them to hang on boot. The first "goto get_map" that was removed
> from exit_boot insured there was enough room for the memory map when
> efi_call_early(exit_boot_services) was called. This happens when
> (nr_desc > ARRAY_SIZE(params->e820_table).
> 
> Chain of events:
>   exit_boot()
>     efi_exit_boot_services()
>       efi_get_memory_map <- at this point the mm can't grow over 8 desc
>       priv_func()
>         exit_boot_func()
>           allocate_e820ext() <- new mm grows over 8 desc from e820 alloc
>       efi_call_early(exit_boot_services) <- mm key doesn't match so retry
>       efi_call_early(get_memory_map) <- not enough room for new mm
>       system hangs
> 
> This patch allocates the e820 buffer before calling efi_exit_boot_services
> and fixes the regression.
> 
> Signed-off-by: Eric Snowberg <eric.snowberg@oracle.com>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  arch/x86/boot/compressed/eboot.c | 65 ++++++++++++++++++++------------
>  1 file changed, 41 insertions(+), 24 deletions(-)

Any objections against marking this for -stable and filing it in 
efi/urgent? Boot hangs are show-stopper bugs, so distributions would want 
to backport this fix anyway.

> +	boot_map.map =		&map;
> +	boot_map.map_size =	&map_size;
> +	boot_map.desc_size =	&desc_size;
> +	boot_map.desc_ver =	NULL;
> +	boot_map.key_ptr =	NULL;
> +	boot_map.buff_size =	&buff_size;

I have changed this to the canonical style, which is also used elsewhere 
in the file:

>  	map.buff_size		= &buff_size;
>  	priv.boot_params	= boot_params;
>  	priv.efi		= &boot_params->efi_info;
> -	priv.e820ext		= NULL;
> -	priv.e820ext_size	= 0;

I.e.:

+	boot_map.map		= &map;
+	boot_map.map_size	= &map_size;
+	boot_map.desc_size	= &desc_size;
+	boot_map.desc_ver	= NULL;
+	boot_map.key_ptr	= NULL;
+	boot_map.buff_size	= &buff_size;
+
+	status = efi_get_memory_map(sys_table, &boot_map);

Thanks,

	Ingo
