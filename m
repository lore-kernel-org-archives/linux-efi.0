From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH v3 0/3] efi interruptible runtime services
Date: Mon, 25 Jul 2016 16:58:20 +0100
Message-ID: <20160725155820.GD31759@codeblueprint.co.uk>
References: <1468611391-4039-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1468611391-4039-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, sylvain.chouleur-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Fri, 15 Jul, at 09:36:28PM, Ard Biesheuvel wrote:
> This is a resend of the generic part of the series 'efi interruptible runtime
> services', of which v3 was sent out on January 13th. I have added an additional
> patch on top which gives runtime-wrappers.c the same treatment as efivars.c,
> i.e., replacing the spinlock with a semaphore.
> 
> v2: rebase onto v4.7-rc3
>     pr_warn() on failure to acquire the rt services semaphore before invoking
>     the reset_system runtime service
>     map EFI_ABORTED onto -EINTR
> 
> v3: drop lockdep_assert_xxx() calls (#2)
> 
> Ard Biesheuvel (1):
>   efi: replace runtime services spinlock with semaphore
> 
> Sylvain Chouleur (2):
>   efi: use a file local lock for efivars
>   efi: don't use spinlocks for efi vars

Thanks Ard, applied for v4.9.
