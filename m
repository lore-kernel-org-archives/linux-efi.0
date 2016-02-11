From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH v3 2/3] efi: don't use spinlocks for efi vars
Date: Thu, 11 Feb 2016 13:45:51 +0000
Message-ID: <20160211134551.GC4134@codeblueprint.co.uk>
References: <1452119637-10958-1-git-send-email-sylvain.chouleur@gmail.com>
 <1452702762-27216-1-git-send-email-sylvain.chouleur@gmail.com>
 <1452702762-27216-3-git-send-email-sylvain.chouleur@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1452702762-27216-3-git-send-email-sylvain.chouleur-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sylvain Chouleur <sylvain.chouleur-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Sylvain Chouleur <sylvain.chouleur-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, 13 Jan, at 05:32:41PM, Sylvain Chouleur wrote:
> From: Sylvain Chouleur <sylvain.chouleur-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> All efivars operations are protected by a spinlock which prevents
> interruptions and preemption. This is too restricted, we just need a
> lock preventing concurency.
> The idea is to use a semaphore of count 1 and to have two ways of
> locking, depending on the context:
>  - In interrupt context, we call down_trylock(), if it fails we return
>  an error
>  - In normal context, we call down_interruptible()
> 
> We don't use a mutex here because the mutex_trylock() function must not
> be called from interrupt context, whereas the down_trylock() can.
> 
> Signed-off-by: Sylvain Chouleur <sylvain.chouleur-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/firmware/efi/efi-pstore.c |  36 +++++++---
>  drivers/firmware/efi/efivars.c    |  22 ++++--
>  drivers/firmware/efi/vars.c       | 145 +++++++++++++++++++++++---------------
>  fs/efivarfs/inode.c               |   5 +-
>  fs/efivarfs/super.c               |   9 ++-
>  include/linux/efi.h               |   6 +-
>  6 files changed, 149 insertions(+), 74 deletions(-)

Looks fine to me.
