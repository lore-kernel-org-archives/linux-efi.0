From: Maniaxx <tripleshiftone@gmail.com>
Subject: Re: [PATCH 4.11 049/150] efi/bgrt: Skip efi_bgrt_init() in case of
 non-EFI boot
Date: Thu, 15 Jun 2017 01:34:38 +0200
Message-ID: <9a71b41b-5e6a-e0a5-776d-829792e7f998@gmail.com>
References: <20170612152519.404936272@linuxfoundation.org>
 <20170612152521.552786146@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170612152521.552786146@linuxfoundation.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On 12.06.2017 at 17:24 wrote Greg Kroah-Hartman:
> 4.11-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Dave Young <dyoung@redhat.com>
> 
> commit 7425826f4f7ac60f2538b06a7f0a5d1006405159 upstream.
> 
> Sabrina Dubroca reported an early panic:
> 
>   BUG: unable to handle kernel paging request at ffffffffff240001
>   IP: efi_bgrt_init+0xdc/0x134
> 
>   [...]
> 
>   ---[ end Kernel panic - not syncing: Attempted to kill the idle task!
> 
> ... which was introduced by:
> 
>   7b0a911478c7 ("efi/x86: Move the EFI BGRT init code to early init code")
> 
> The cause is that on this machine the firmware provides the EFI ACPI BGRT
> table even on legacy non-EFI bootups - which table should be EFI only.
> 
> The garbage BGRT data causes the efi_bgrt_init() panic.
> 
> Add a check to skip efi_bgrt_init() in case non-EFI bootup to work around
> this firmware bug.
> 
> Tested-by: Sabrina Dubroca <sd@queasysnail.net>
> Signed-off-by: Dave Young <dyoung@redhat.com>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: linux-efi@vger.kernel.org
> Fixes: 7b0a911478c7 ("efi/x86: Move the EFI BGRT init code to early init code")
> Link: http://lkml.kernel.org/r/20170526113652.21339-6-matt@codeblueprint.co.uk
> [ Rewrote the changelog to be more readable. ]
> Signed-off-by: Ingo Molnar <mingo@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> ---
>  arch/x86/platform/efi/efi-bgrt.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> --- a/arch/x86/platform/efi/efi-bgrt.c
> +++ b/arch/x86/platform/efi/efi-bgrt.c
> @@ -36,6 +36,9 @@ void __init efi_bgrt_init(struct acpi_ta
>  	if (acpi_disabled)
>  		return;
>  
> +	if (!efi_enabled(EFI_BOOT))
> +		return;
> +
>  	if (table->length < sizeof(bgrt_tab)) {
>  		pr_notice("Ignoring BGRT: invalid length %u (expected %zu)\n",
>  		       table->length, sizeof(bgrt_tab));
> 
> 
> 

The patch is ok but it only fixes BIOS systems.
To fix the regression above (commit 7b0a911478c7) for EFI systems 
it needs this patch as well:
commit 792ef14df5c585c19b2831673a077504a09e5203 master
(efi: Fix boot panic because of invalid BGRT image address)
