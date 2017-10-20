From: joeyli <jlee@suse.com>
Subject: Re: [PATCH 11/27] x86: Lock down IO port access when the kernel is
 locked down
Date: Fri, 20 Oct 2017 14:43:15 +0800
Message-ID: <20171020064315.GS3285@linux-l9pv.suse>
References: <150842463163.7923.11081723749106843698.stgit@warthog.procyon.org.uk>
 <150842471673.7923.7676307847318724274.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <150842471673.7923.7676307847318724274.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: linux-security-module@vger.kernel.org, gnomes@lxorguk.ukuu.org.uk, linux-efi@vger.kernel.org, matthew.garrett@nebula.com, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, jforbes@redhat.com
List-Id: linux-efi@vger.kernel.org

On Thu, Oct 19, 2017 at 03:51:56PM +0100, David Howells wrote:
> From: Matthew Garrett <matthew.garrett@nebula.com>
> 
> IO port access would permit users to gain access to PCI configuration
> registers, which in turn (on a lot of hardware) give access to MMIO
> register space. This would potentially permit root to trigger arbitrary
> DMA, so lock it down by default.
> 
> This also implicitly locks down the KDADDIO, KDDELIO, KDENABIO and
> KDDISABIO console ioctls.
> 
> Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
> Signed-off-by: David Howells <dhowells@redhat.com>
> Reviewed-by: Thomas Gleixner <tglx@linutronix.de>

I have reviewed this patch. Please feel free to add:

Reviewed-by: "Lee, Chun-Yi" <jlee@suse.com>

Thanks!
Joey Lee

> cc: x86@kernel.org
> ---
> 
>  arch/x86/kernel/ioport.c |    6 ++++--
>  drivers/char/mem.c       |    2 ++
>  2 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/ioport.c b/arch/x86/kernel/ioport.c
> index 9c3cf0944bce..2c0f058651c5 100644
> --- a/arch/x86/kernel/ioport.c
> +++ b/arch/x86/kernel/ioport.c
> @@ -30,7 +30,8 @@ asmlinkage long sys_ioperm(unsigned long from, unsigned long num, int turn_on)
>  
>  	if ((from + num <= from) || (from + num > IO_BITMAP_BITS))
>  		return -EINVAL;
> -	if (turn_on && !capable(CAP_SYS_RAWIO))
> +	if (turn_on && (!capable(CAP_SYS_RAWIO) ||
> +			kernel_is_locked_down("ioperm")))
>  		return -EPERM;
>  
>  	/*
> @@ -120,7 +121,8 @@ SYSCALL_DEFINE1(iopl, unsigned int, level)
>  		return -EINVAL;
>  	/* Trying to gain more privileges? */
>  	if (level > old) {
> -		if (!capable(CAP_SYS_RAWIO))
> +		if (!capable(CAP_SYS_RAWIO) ||
> +		    kernel_is_locked_down("iopl"))
>  			return -EPERM;
>  	}
>  	regs->flags = (regs->flags & ~X86_EFLAGS_IOPL) |
> diff --git a/drivers/char/mem.c b/drivers/char/mem.c
> index b7c36898b689..0875b3d47773 100644
> --- a/drivers/char/mem.c
> +++ b/drivers/char/mem.c
> @@ -768,6 +768,8 @@ static loff_t memory_lseek(struct file *file, loff_t offset, int orig)
>  
>  static int open_port(struct inode *inode, struct file *filp)
>  {
> +	if (kernel_is_locked_down("Direct ioport access"))
> +		return -EPERM;
>  	return capable(CAP_SYS_RAWIO) ? 0 : -EPERM;
>  }
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-efi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
