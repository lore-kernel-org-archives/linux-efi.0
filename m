From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH v2 3/3] efi: replace runtime services spinlock with
 semaphore
Date: Fri, 15 Jul 2016 15:49:29 +0100
Message-ID: <20160715144929.GC2406@codeblueprint.co.uk>
References: <1468249165-25523-1-git-send-email-ard.biesheuvel@linaro.org>
 <1468249165-25523-4-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1468249165-25523-4-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, sylvain.chouleur-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Mon, 11 Jul, at 04:59:25PM, Ard Biesheuvel wrote:
> The purpose of the efi_runtime_lock is to prevent concurrent calls into
> the firmware. There is no need to use spinlocks here, as long as we ensure
> that runtime service invocations from an atomic context (i.e., EFI pstore)
> cannot block.
> 
> So use a semaphore instead, and use down_trylock() in the nonblocking case.
> We don't use a mutex here because the mutex_trylock() function must not
> be called from interrupt context, whereas the down_trylock() can.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> --
> v2: rebased onto v4.7-rc3
>     handle EFI_ABORT in efi_status_to_err()
> ---
>  drivers/firmware/efi/efi.c              |  3 +
>  drivers/firmware/efi/runtime-wrappers.c | 81 ++++++++++++--------
>  include/linux/efi.h                     |  1 +
>  3 files changed, 53 insertions(+), 32 deletions(-)

This one looks good too.
