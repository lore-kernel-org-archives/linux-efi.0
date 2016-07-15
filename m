From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH v2 2/3] efi: don't use spinlocks for efi vars
Date: Fri, 15 Jul 2016 15:44:49 +0100
Message-ID: <20160715144449.GB2406@codeblueprint.co.uk>
References: <1468249165-25523-1-git-send-email-ard.biesheuvel@linaro.org>
 <1468249165-25523-3-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1468249165-25523-3-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, sylvain.chouleur-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Mon, 11 Jul, at 04:59:24PM, Ard Biesheuvel wrote:
> From: Sylvain Chouleur <sylvain.chouleur-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> All efivars operations are protected by a spinlock which prevents
> interruptions and preemption. This is too restricted, we just need a
> lock preventing concurrency.
> The idea is to use a semaphore of count 1 and to have two ways of
> locking, depending on the context:
> - In interrupt context, we call down_trylock(), if it fails we return
>   an error
> - In normal context, we call down_interruptible()
> 
> We don't use a mutex here because the mutex_trylock() function must not
> be called from interrupt context, whereas the down_trylock() can.
> 
> Signed-off-by: Sylvain Chouleur <sylvain.chouleur-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> [ardb: rebased onto v4.7-rc3]
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  drivers/firmware/efi/efi-pstore.c |  36 +++--
>  drivers/firmware/efi/efivars.c    |  22 +++-
>  drivers/firmware/efi/vars.c       | 137 ++++++++++++--------
>  fs/efivarfs/inode.c               |   5 +-
>  fs/efivarfs/super.c               |   9 +-
>  include/linux/efi.h               |   6 +-
>  6 files changed, 143 insertions(+), 72 deletions(-)
 
[...]

> @@ -545,10 +562,10 @@ EXPORT_SYMBOL_GPL(efivar_entry_remove);
>   */
>  static void efivar_entry_list_del_unlock(struct efivar_entry *entry)
>  {
> -	lockdep_assert_held(&efivars_lock);
> +	lockdep_assert_held(&efivars_lock.lock);
>  
>  	list_del(&entry->list);
> -	spin_unlock_irq(&efivars_lock);
> +	up(&efivars_lock);
>  }
>  
>  /**

These LOCKDEP annotations are now incorrect because the spin lock
inside the semaphore is only held while acquiring the semaphore.
 
I can't see an equivalent assert for semaphores, so it's probably best
to just rip these out.

Other than that, this looks OK.
