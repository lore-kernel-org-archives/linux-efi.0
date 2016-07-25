From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH v3 2/3] efi: don't use spinlocks for efi vars
Date: Mon, 25 Jul 2016 16:43:54 +0100
Message-ID: <20160725154354.GC31759@codeblueprint.co.uk>
References: <1468611391-4039-1-git-send-email-ard.biesheuvel@linaro.org>
 <1468611391-4039-3-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1468611391-4039-3-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, sylvain.chouleur-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Sylvain Chouleur <sylvain.chouleur-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tobias Klauser <tklauser-93Khv+1bN0NyDzI6CaY1VQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 15 Jul, at 09:36:30PM, Ard Biesheuvel wrote:
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
> [ardb: rebased onto v4.7-rc3, remove lockdep_assert_xxx() calls]
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
> v3: remove lockdep_assert() calls: they are no longer appropriate now that we
>     have switched to a semaphore
> v2: rebased onto v4.7-rc3
> 
>  drivers/firmware/efi/efi-pstore.c |  36 +++--
>  drivers/firmware/efi/efivars.c    |  22 +++-
>  drivers/firmware/efi/vars.c       | 137 ++++++++++++--------
>  fs/efivarfs/inode.c               |   5 +-
>  fs/efivarfs/super.c               |   9 +-
>  include/linux/efi.h               |   6 +-
>  6 files changed, 139 insertions(+), 76 deletions(-)
 
[...]

> diff --git a/fs/efivarfs/inode.c b/fs/efivarfs/inode.c
> index 1d73fc6dba13..cbb50cadcffc 100644
> --- a/fs/efivarfs/inode.c
> +++ b/fs/efivarfs/inode.c
> @@ -105,7 +105,10 @@ static int efivarfs_create(struct inode *dir, struct dentry *dentry,
>  
>  	inode->i_private = var;
>  
> -	efivar_entry_add(var, &efivarfs_list);
> +	err = efivar_entry_add(var, &efivarfs_list);
> +	if (err)
> +		goto out;
> +
>  	d_instantiate(dentry, inode);
>  	dget(dentry);
>  out:

Tobias, this patch requires the exact error path that was removed in
patch ("efivarfs: Eliminate dead code in efivarfs_create()").

Which unfortunately means I'm going to drop your patch from the queue.
