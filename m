From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH] efi: Clean up the efi_call_phys_[prolog|epilog]()
 save/restore interaction
Date: Tue, 10 Mar 2015 13:36:37 +0000
Message-ID: <20150310133637.GC17573@codeblueprint.co.uk>
References: <20150303064850.GA30036@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150303064850.GA30036-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Tapasweni Pathak <tapaswenipathak-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 03 Mar, at 07:48:50AM, Ingo Molnar wrote:
> 
> Also clean up the save_pgd global variable while at it.
> 
> untested as well.
> 
> Thanks,
> 
> 	Ingo
> 
> ==============>
> From 166625ceaef68fcbeee63adc63c02d75abcaf0db Mon Sep 17 00:00:00 2001
> From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Date: Tue, 3 Mar 2015 07:42:48 +0100
> Subject: [PATCH] efi: Clean up the efi_call_phys_[prolog|epilog]() save/restore interaction
> 
> Currently x86-64 efi_call_phys_prolog() saves into a global variable (save_pgd),
> and efi_call_phys_epilog() restores the kernel pagetables from that global
> variable.
> 
> Change this to a cleaner save/restore pattern where the saving function returns
> the saved object and the restore function restores that.
> 
> Apply the same concept to the 32-bit code as well.
> 
> Plus this approach, as an added bonus, allows us to express the
> !efi_enabled(EFI_OLD_MEMMAP) situation in a clean fashion as well,
> via a 'NULL' return value.
> 
> Cc: Tapasweni Pathak <tapaswenipathak-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
>  arch/x86/include/asm/efi.h     |  6 ++++--
>  arch/x86/platform/efi/efi.c    |  5 +++--
>  arch/x86/platform/efi/efi_32.c | 11 ++++++++---
>  arch/x86/platform/efi/efi_64.c | 26 ++++++++++++++++----------
>  4 files changed, 31 insertions(+), 17 deletions(-)

Applied, thanks!

-- 
Matt Fleming, Intel Open Source Technology Center
