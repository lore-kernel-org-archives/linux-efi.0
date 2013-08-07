From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH 03/17] Add system pointer argument to shared EFI stub
 related functions so they no longer use global system table pointer as they
 did when part of eboot.c.
Date: Wed, 7 Aug 2013 14:08:51 +0100
Message-ID: <20130807130851.GC2515@console-pimps.org>
References: <1375847113-24884-1-git-send-email-roy.franz@linaro.org>
 <1375847113-24884-4-git-send-email-roy.franz@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1375847113-24884-4-git-send-email-roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, dave.martin-5wv7dgnIgG8@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tue, 06 Aug, at 08:44:59PM, Roy Franz wrote:
> Signed-off-by: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  arch/x86/boot/compressed/eboot.c       |   38 +++++++------
>  drivers/firmware/efi/efi-stub-helper.c |   96 +++++++++++++++++---------------
>  2 files changed, 72 insertions(+), 62 deletions(-)

For future reference you should really use a shorter first line in your
git commit message, which would produe a shorter subject when mailing
your patches.

I'll fix up the commit messages when I apply these patches, so don't
worry about it for now.

[...]

> @@ -19,15 +19,16 @@ struct initrd {
>  
>  
>  
> -static void efi_char16_printk(efi_char16_t *str)
> +static void efi_char16_printk(efi_system_table_t *sys_table_arg,
> +			      efi_char16_t *str)
>  {
>  	struct efi_simple_text_output_protocol *out;
>  
> -	out = (struct efi_simple_text_output_protocol *)sys_table->con_out;
> +	out = (struct efi_simple_text_output_protocol *)sys_table_arg->con_out;
>  	efi_call_phys2(out->output_string, out, str);
>  }
>  
> -static void efi_printk(char *str)
> +static void efi_printk(efi_system_table_t *sys_table_arg, char *str)
>  {
>  	char *s8;
>  

Hmm... I'm not necessarily convinced this is an improvement over using
some kind of a global pointer to the EFI System Table.

Parameterizing stuff like this is useful when the argument changes at
runtime from call to call, but that isn't the case for the boot stubs. I
don't think there's anything wrong with a global in this scenario, and
this patch is a fair amount of churn for no real improvement.

-- 
Matt Fleming, Intel Open Source Technology Center
