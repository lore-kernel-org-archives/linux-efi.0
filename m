From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH 2/4] efi: efivars: don't rely on blocking operations in
 non-blocking set_var()
Date: Thu, 26 Nov 2015 09:54:41 +0000
Message-ID: <20151126095441.GA2765@codeblueprint.co.uk>
References: <1447940191-30705-1-git-send-email-ard.biesheuvel@linaro.org>
 <1447940191-30705-3-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1447940191-30705-3-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, 19 Nov, at 02:36:29PM, Ard Biesheuvel wrote:
> The non-blocking version of efivar_entry_set() gives up directly on
> failure to acquire __efivars->lock. However, it also calls check_var_size(),
> whose implementation calls the ordinary query_variable_info() and
> set_variable() runtime service wrappers, meaning we could still deadlock
> if efivar_entry_set_nonblocking() is called from an atomic context that
> interrupted a runtime service already in progress on the same CPU.
> 
> So drop the call to check_var_size(). This is potentially unsafe on some
> UEFI implementations that fail to boot if the varstore fills up, but
> those systems are unlikely to be using efi-pstore in the first place.
 
There is simply no way you can make that assumption. The whole "my
NVRAM is full, now my machine is bricked" issue arose because
efi-pstore was filling the NVRAM with crash logs; that's how we
triggered the problem in the first place.

The locking here is non-trivial, so it's worth spelling out. There are
two spinlocks we need to concern ourselves with,

  1. __efivars->lock
  2. efi_runtime_lock

All EFI variable operations are performed with __efivars->lock held,
apart from the x86 efi_delete_dummy_variable() call during boot when
we're UP anyway. For all intents and purposes, when we're SMP,
__efivars->lock is held for all EFI variable operations.

So the only potential for deadlock if CPU A is doing variable calls is
if CPU A or CPU B is doing efi_reset() or efi_capsule_*(). That's not
an impossible scenario (particularly on arm64 where efi_reset() is
used more frequently), but it gives you some clue as to when deadlock
might be a problem.

> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  drivers/firmware/efi/vars.c | 12 +++---------
>  1 file changed, 3 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/firmware/efi/vars.c b/drivers/firmware/efi/vars.c
> index 70a0fb10517f..caccdbffc1d0 100644
> --- a/drivers/firmware/efi/vars.c
> +++ b/drivers/firmware/efi/vars.c
> @@ -615,12 +615,6 @@ efivar_entry_set_nonblocking(efi_char16_t *name, efi_guid_t vendor,
>  	if (!spin_trylock_irqsave(&__efivars->lock, flags))
>  		return -EBUSY;
>  
> -	status = check_var_size(attributes, size + ucs2_strsize(name, 1024));
> -	if (status != EFI_SUCCESS) {
> -		spin_unlock_irqrestore(&__efivars->lock, flags);
> -		return -ENOSPC;
> -	}
> -
>  	status = ops->set_variable_nonblocking(name, &vendor, attributes,
>  					       size, data);

We still need some validation to occur if efi_no_storage_paranoia is
unset, i.e. "Be paranoid about how much NVRAM we use".

However, efi_query_variable_store() actually does two things,

  1. Check if the write pushes free NVRAM space below EFI_MIN_RESERVE
  2. If it does, attempt to trigger garbage collection

Now, if you're in the belly of a kdump handler, attempting to trigger
garbage collection to ensure the write succeeds should be the last
thing on your mind. Everything you do is a last ditch attempt to
record the reason your machine is going down.

I think the best solution would be to only perform step 1. above in
the efi_pstore_write() code path, and keep a cached copy of
query_variable_info() that we can perform lockless queries on. We can
initially grab it on boot and update it with every ->set_variable()
call.

Thoughts?
