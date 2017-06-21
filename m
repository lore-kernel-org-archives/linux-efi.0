From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 1/2] efi: Add 'nr_config_table' variable in efi structure
Date: Wed, 21 Jun 2017 14:07:01 +0200
Message-ID: <CAKv+Gu8fQmPRoxR67gm1yBvN0Z8ShY++TW07_RUYRsv-BAu_1g@mail.gmail.com>
References: <20170619175423.70656-1-qiuxu.zhuo@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170619175423.70656-1-qiuxu.zhuo-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Qiuxu Zhuo <qiuxu.zhuo-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 19 June 2017 at 19:54, Qiuxu Zhuo <qiuxu.zhuo-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> The 'nr_config_table' and 'config_table' (alreay in efi structure)
> in efi structure provide a way for some driver(e.g. capsule-pstore
> goes through the configuration table to extract crash capsules to
> aid in debugging) iterates over the EFI configuration table array.
>
> Signed-off-by: Qiuxu Zhuo <qiuxu.zhuo-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  arch/x86/platform/efi/efi.c | 1 +
>  drivers/firmware/efi/efi.c  | 1 +
>  include/linux/efi.h         | 1 +
>  3 files changed, 3 insertions(+)
>
> diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
> index 7e76a4d..bcda1b9 100644
> --- a/arch/x86/platform/efi/efi.c
> +++ b/arch/x86/platform/efi/efi.c
> @@ -498,6 +498,7 @@ void __init efi_init(void)
>                 return;
>
>         efi.config_table = (unsigned long)efi.systab->tables;
> +       efi.nr_config_table = (unsigned long)efi.systab->nr_tables;

As it turns out, we never assign efi.config_table on ARM/arm64, and
this needs to be fixed, so I queued a patch in the EFI -next branch.
Could you rebase your series onto that, and make sure you add a
similar line as this one to uefi_init() in
drivers/firmware/efi/arm-init.c?

>         efi.fw_vendor    = (unsigned long)efi.systab->fw_vendor;
>         efi.runtime      = (unsigned long)efi.systab->runtime;
>
> diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
> index b372aad..b511197 100644
> --- a/drivers/firmware/efi/efi.c
> +++ b/drivers/firmware/efi/efi.c
> @@ -48,6 +48,7 @@ struct efi __read_mostly efi = {
>         .fw_vendor              = EFI_INVALID_TABLE_ADDR,
>         .runtime                = EFI_INVALID_TABLE_ADDR,
>         .config_table           = EFI_INVALID_TABLE_ADDR,
> +       .nr_config_table        = EFI_INVALID_TABLE_ADDR,

nr_config_table is not a physical address, so please just initialize it to 0

>         .esrt                   = EFI_INVALID_TABLE_ADDR,
>         .properties_table       = EFI_INVALID_TABLE_ADDR,
>         .mem_attr_table         = EFI_INVALID_TABLE_ADDR,
> diff --git a/include/linux/efi.h b/include/linux/efi.h
> index ec36f42..bd5ff8f 100644
> --- a/include/linux/efi.h
> +++ b/include/linux/efi.h
> @@ -892,6 +892,7 @@ extern struct efi {
>         unsigned long fw_vendor;        /* fw_vendor */
>         unsigned long runtime;          /* runtime table */
>         unsigned long config_table;     /* config tables */
> +       unsigned long nr_config_table;
>         unsigned long esrt;             /* ESRT table */
>         unsigned long properties_table; /* properties table */
>         unsigned long mem_attr_table;   /* memory attributes table */
> --
> 2.9.0.GIT
>
