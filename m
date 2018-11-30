From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 11/11] efi/x86: earlyprintk - Fix infinite loop on some
 screen widths
Date: Fri, 30 Nov 2018 09:05:44 +0100
Message-ID: <20181130080544.GC16084@gmail.com>
References: <20181129171230.18699-1-ard.biesheuvel@linaro.org>
 <20181129171230.18699-12-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181129171230.18699-12-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-efi@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, Arend van Spriel <arend.vanspriel@broadcom.com>, Bhupesh Sharma <bhsharma@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@intel.com>, Eric Snowberg <eric.snowberg@oracle.com>, Hans de Goede <hdegoede@redhat.com>, Joe Perches <joe@perches.com>, Jon Hunter <jonathanh@nvidia.com>, Julien Thierry <julien.thierry@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Nathan Chancellor <natechancellor@gmail.com>, Peter Zijlstra <peterz@infradead.org>, Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>, Sedat Dilek <sedat.dilek@gmail.com>, YiFei Zhu <zhuyifei1999@gmail.com>
List-Id: linux-efi@vger.kernel.org


* Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:

> From: YiFei Zhu <zhuyifei1999@gmail.com>
> 
> An affected screen resolution is 1366 x 768, which width is not
> divisible by 8, the default font width. On such screens, when longer
> lines are earlyprintk'ed, overflow-to-next-line can never trigger,
> due to the left-most x-coordinate of the next character always less
> than the screen width. Earlyprintk will infinite loop in trying to
> print the rest of the string but unable to, due to the line being
> full.
> 
> This patch makes the trigger consider the right-most x-coordinate,
> instead of left-most, as the value to compare against the screen
> width threshold.
> 
> Signed-off-by: YiFei Zhu <zhuyifei1999@gmail.com>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  arch/x86/platform/efi/early_printk.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/platform/efi/early_printk.c b/arch/x86/platform/efi/early_printk.c
> index 7476b3b097e1..7138bc7a265c 100644
> --- a/arch/x86/platform/efi/early_printk.c
> +++ b/arch/x86/platform/efi/early_printk.c
> @@ -183,7 +183,7 @@ early_efi_write(struct console *con, const char *str, unsigned int num)
>  			num--;
>  		}
>  
> -		if (efi_x >= si->lfb_width) {
> +		if (efi_x + font->width > si->lfb_width) {
>  			efi_x = 0;
>  			efi_y += font->height;
>  		}

Any objections to marking this for -stable and queueing it up in 
efi/urgent as well?

Thanks,

	Ingo
