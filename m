From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH 1/3] efi: don't call the system table version the runtime
 services version
Date: Tue, 13 Sep 2016 13:32:49 +0100
Message-ID: <20160913123249.GI3872@codeblueprint.co.uk>
References: <20160907122339.GB28333@wunner.de>
 <1473260186-4500-1-git-send-email-pjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1473260186-4500-1-git-send-email-pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, 07 Sep, at 10:56:24AM, Peter Jones wrote:
> The system table's hdr.revision is not the runtime services revision,
> it's the EFI Spec revision.  The runtime services revision is the one on
> systab->runtime->hdr.revision.
> 
> So we shouldn't call it runtime_version throughout the code, as that's
> misleading if you're *actually* looking for the runtime services
> revision.
> 
> We also move some of the assignments around just a bit, in support of
> making a future patch more readable.
> 
> This also fixes a minor bug where the version field was not set in the
> efi structure on ia64.
> 
> Signed-off-by: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
> ---
>  arch/ia64/kernel/efi.c                  | 3 +++
>  arch/x86/platform/efi/efi.c             | 7 ++++---
>  arch/x86/platform/efi/efi_64.c          | 2 +-
>  arch/x86/xen/efi.c                      | 4 ++--
>  drivers/firmware/efi/arm-init.c         | 5 +++--
>  drivers/firmware/efi/runtime-wrappers.c | 8 ++++----
>  drivers/xen/efi.c                       | 6 +++---
>  include/linux/efi.h                     | 2 +-
>  8 files changed, 21 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/ia64/kernel/efi.c b/arch/ia64/kernel/efi.c
> index 1212956..2af99a8 100644
> --- a/arch/ia64/kernel/efi.c
> +++ b/arch/ia64/kernel/efi.c
> @@ -513,6 +513,9 @@ efi_init (void)
>  		panic("Whoa! Can't find EFI system table.\n");
>  	if (efi.systab->hdr.signature != EFI_SYSTEM_TABLE_SIGNATURE)
>  		panic("Whoa! EFI system table signature incorrect\n");
> +
> +	efi.spec_version = efi.systab->hdr.version;
> +
>  	if ((efi.systab->hdr.revision >> 16) == 0)
>  		printk(KERN_WARNING "Warning: EFI system table version "
>  		       "%d.%02d, expected 1.00 or greater\n",

I applied this and fixed up the above typo s/hdr.version/hdr.revision/
