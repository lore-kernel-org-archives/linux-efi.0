From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] efi: Remove the declaration of efi_late_init() as the
 function is unused
Date: Mon, 25 Jun 2018 08:02:01 +0200
Message-ID: <CAKv+Gu_xK9WSVPx-gfy=vNjUsrT8aChofghjDbQPJaHPkS7bnw@mail.gmail.com>
References: <1529891271-24319-1-git-send-email-sai.praneeth.prakhya@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1529891271-24319-1-git-send-email-sai.praneeth.prakhya@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Cc: linux-efi <linux-efi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Lee Chun-Yi <jlee@suse.com>, Borislav Petkov <bp@alien8.de>, Dave Young <dyoung@redhat.com>, Bhupesh Sharma <bhsharma@redhat.com>, Ricardo Neri <ricardo.neri@intel.com>, Ravi Shankar <ravi.v.shankar@intel.com>, Matt Fleming <matt@codeblueprint.co.uk>
List-Id: linux-efi@vger.kernel.org

On 25 June 2018 at 03:47, Sai Praneeth Prakhya
<sai.praneeth.prakhya@intel.com> wrote:
> From: Sai Praneeth <sai.praneeth.prakhya@intel.com>
>
> Commit 7b0a911478c74 (efi/x86: Move the EFI BGRT init code to early
> init code), removed the implementation and all the references to
> efi_late_init() but the function is still declared at
> include/linux/efi.h. Hence, remove the unnecessary declaration.
>
> Signed-off-by: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
> Cc: Lee Chun-Yi <jlee@suse.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Dave Young <dyoung@redhat.com>
> Cc: Bhupesh Sharma <bhsharma@redhat.com>
> Cc: Ricardo Neri <ricardo.neri@intel.com>
> Cc: Ravi Shankar <ravi.v.shankar@intel.com>
> Cc: Matt Fleming <matt@codeblueprint.co.uk>
> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Thanks Sai

Queued in efi/next

> ---
>  include/linux/efi.h | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/include/linux/efi.h b/include/linux/efi.h
> index 56add823f190..ae47be636b98 100644
> --- a/include/linux/efi.h
> +++ b/include/linux/efi.h
> @@ -988,14 +988,12 @@ extern void efi_memmap_walk (efi_freemem_callback_t callback, void *arg);
>  extern void efi_gettimeofday (struct timespec64 *ts);
>  extern void efi_enter_virtual_mode (void);     /* switch EFI to virtual mode, if possible */
>  #ifdef CONFIG_X86
> -extern void efi_late_init(void);
>  extern void efi_free_boot_services(void);
>  extern efi_status_t efi_query_variable_store(u32 attributes,
>                                              unsigned long size,
>                                              bool nonblocking);
>  extern void efi_find_mirror(void);
>  #else
> -static inline void efi_late_init(void) {}
>  static inline void efi_free_boot_services(void) {}
>
>  static inline efi_status_t efi_query_variable_store(u32 attributes,
> --
> 2.7.4
>
