From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH v4 0/2] Add EFI capsule pstore backend support
Date: Fri, 23 Jun 2017 13:42:34 -0700
Message-ID: <CAGXu5jLzd8PdH3mGS_+kYA3-nZwmJCYkeQXH2crJr5LqYGoHaQ@mail.gmail.com>
References: <20170622163434.95704-1-qiuxu.zhuo@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170622163434.95704-1-qiuxu.zhuo-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Qiuxu Zhuo <qiuxu.zhuo-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, Jun 22, 2017 at 9:34 AM, Qiuxu Zhuo <qiuxu.zhuo-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> Change Log v3->v4:
>  - Add comment 'the number of config tables' for 'nr_config_table' in efi structure
>  - Initialize 'efi.nr_config_table' to 0 in default
>  - Set 'efi.nr_config_table' to 'efi.systab->nr_tables' in drivers/firmware/efi/arm-init.c -> uefi_init()
>  - Mark 'efi_capsule_pstore_disable' as __ro_after_init
>  - Use timestamp value passed from pstore API rather than using get_seconds()
>  - Pass page physcial addresses rather than struct page pointers to efi_capsule_update()

Thanks for the updates!

Reviewed-by: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>

>
> Qiuxu Zhuo (2):
>   efi: Add 'nr_config_table' variable in efi structure
>   eif/capsule-pstore: Add capsule pstore backend
>
>  arch/x86/platform/efi/efi.c           |   1 +
>  drivers/firmware/efi/Kconfig          |  21 ++
>  drivers/firmware/efi/Makefile         |   1 +
>  drivers/firmware/efi/arm-init.c       |   4 +-
>  drivers/firmware/efi/capsule-pstore.c | 679 ++++++++++++++++++++++++++++++++++
>  drivers/firmware/efi/efi.c            |   1 +
>  include/linux/efi.h                   |   1 +
>  7 files changed, 707 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/firmware/efi/capsule-pstore.c
>
> --
> 2.9.0.GIT
>



-- 
Kees Cook
Pixel Security
