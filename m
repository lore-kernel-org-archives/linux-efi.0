From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH] x86/efi: Add EFI_PGT_DUMP support for x86_32, kexec and
 efi=old_map
Date: Thu, 11 May 2017 13:18:28 +0200
Message-ID: <20170511111828.pu2i3pn6lyiukgaf@pd.tnic>
References: <1494456545-26300-1-git-send-email-sai.praneeth.prakhya@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1494456545-26300-1-git-send-email-sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ricardo Neri <ricardo.neri-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Ravi Shankar <ravi.v.shankar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, May 10, 2017 at 03:49:05PM -0700, Sai Praneeth Prakhya wrote:
> From: Sai Praneeth <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> EFI_PGT_DUMP, as the name suggests dumps efi page tables to dmesg during
> kernel boot. This feature is very useful while debugging page
> faults/null pointer dereferences to efi related addresses. Presently,
> this feature is limited only to x86_64, so let's extend it to other efi
> configurations like kexec kernel, efi=old_map and to x86_32 as well.
> This doesn't effect normal boot path because this config option should
> be used only for debug purposes.
> 
> Signed-off-by: Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
> Cc: Ricardo Neri <ricardo.neri-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
> Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> Cc: Ravi Shankar <ravi.v.shankar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  arch/x86/platform/efi/efi.c    | 2 ++
>  arch/x86/platform/efi/efi_32.c | 9 ++++++++-
>  arch/x86/platform/efi/efi_64.c | 5 ++++-
>  3 files changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
> index 217dc166c649..a6d6cd8fe78a 100644
> --- a/arch/x86/platform/efi/efi.c
> +++ b/arch/x86/platform/efi/efi.c
> @@ -890,6 +890,8 @@ static void __init kexec_enter_virtual_mode(void)
>  	if (efi_enabled(EFI_OLD_MEMMAP) && (__supported_pte_mask & _PAGE_NX))
>  		runtime_code_page_mkexec();
>  
> +	efi_dump_pagetable();

You can call that only once at the end of efi_enter_virtual_mode()
instead of adding it here and leaving it in __efi_enter_virtual_mode().

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
