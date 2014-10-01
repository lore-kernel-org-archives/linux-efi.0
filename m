From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 1/2] efi: Provide a non-blocking SetVariable() operation
Date: Wed, 1 Oct 2014 17:26:24 +0200
Message-ID: <20141001152624.GB2843@worktop.programming.kicks-ass.net>
References: <1412165200-32141-1-git-send-email-matt@console-pimps.org>
 <1412165200-32141-2-git-send-email-matt@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1412165200-32141-2-git-send-email-matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Oct 01, 2014 at 01:06:39PM +0100, Matt Fleming wrote:
> From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> There are some circumstances that call for trying to write an EFI
> variable in a non-blocking way. One such scenario is when writing pstore
> data in efi_pstore_write() via the pstore_dump() kdump callback.
> 
> Now that we have an EFI runtime spinlock we need a way of aborting if
> there is contention instead of spinning, since when writing pstore data
> from the kdump callback, the runtime lock may already be held by the CPU
> that's running the callback if we crashed in the middle of an EFI
> variable operation.
> 
> The situation is sufficiently special that a new EFI variable operation
> is warranted.
> 
> Introduce ->set_variable_nonblocking() for this use case. It is an
> optional EFI backend operation, and need only be implemented by those
> backends that usually acquire locks to serialize access to EFI
> variables, as is the case for virt_efi_set_variable() where we now grab
> the EFI runtime spinlock.
> 
> Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
> Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> Cc: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
> Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/firmware/efi/runtime-wrappers.c | 19 +++++++++++++
>  drivers/firmware/efi/vars.c             | 47 +++++++++++++++++++++++++++++++++
>  include/linux/efi.h                     |  6 +++++
>  3 files changed, 72 insertions(+)
> 
> diff --git a/drivers/firmware/efi/runtime-wrappers.c b/drivers/firmware/efi/runtime-wrappers.c
> index 9694cba665c4..4349206198b2 100644
> --- a/drivers/firmware/efi/runtime-wrappers.c
> +++ b/drivers/firmware/efi/runtime-wrappers.c
> @@ -200,6 +200,24 @@ static efi_status_t virt_efi_set_variable(efi_char16_t *name,
>  	return status;
>  }
>  
> +static efi_status_t
> +virt_efi_set_variable_nonblocking(efi_char16_t *name, efi_guid_t *vendor,
> +				  u32 attr, unsigned long data_size,
> +				  void *data)
> +{
> +	unsigned long flags;
> +	efi_status_t status;
> +
> +	if (!spin_trylock_irqsave(&efi_runtime_lock, flags))
> +		return EFI_NOT_READY;
> +
> +	status = efi_call_virt(set_variable, name, vendor, attr, data_size,
> +			       data);
> +	spin_unlock_irqrestore(&efi_runtime_lock, flags);
> +	return status;
> +}

If you want to have this usable from NMI context, you need to convert
efi_runtime_lock to a raw_spinlock_t.

Also, it would probably be a good idea to have some selftest like thing
that actually calls this from NMI context, right?
