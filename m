From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH] efi: runtime-wrappers: run UEFI Runtime Services with
 interrupts enabled
Date: Mon, 8 Feb 2016 15:16:14 +0000
Message-ID: <20160208151614.GC2413@codeblueprint.co.uk>
References: <20160203105851.GA22159@gmail.com>
 <1454594327-5444-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1454594327-5444-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: mingo@kernel.org, linux-efi@vger.kernel.org, sai.praneeth.prakhya@intel.com, hpa@zytor.com, tglx@linutronix.de, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, luto@kernel.org, a.p.zijlstra@chello.nl
List-Id: linux-efi@vger.kernel.org

On Thu, 04 Feb, at 02:58:47PM, Ard Biesheuvel wrote:
> OK, since Sai has confirmed that Windows leaves interrupts enabled when
> calling the EFI variable store related runtime services, we should be able
> to do the same for Linux, or at least be slightly more confident that we
> won't have to back out this change later.
> 
> @Sai: could you please confirm on-list as well? Thanks.
> 
> Below is an updated version of the patch, rebased onto current tip/efi/core,
> with the BUG_ON() removed that I left in inadvertently. I also added a mention
> in the commit log that Windows leaves interrupts enabled as well. As far as
> annotating the definition of efi_runtime_lock is concerned, the existing ~40
> lines of documentation should be sufficient imo so I left that as is. Thanks.
> 
> --------8<----------------
> The UEFI spec allows Runtime Services to be invoked with interrupts
> enabled. The only reason we were disabling interrupts was to prevent
> recursive calls into the services on the same CPU, which will lead to
> deadlock. However, the only context where such invocations may occur
> legally is from efi-pstore via efivars, and that code has been updated
> to call a non-blocking alternative when invoked from a non-interruptible
> context.
> 
> So instead, update the ordinary, blocking UEFI Runtime Services wrappers
> to execute with interrupts enabled. This aims to prevent excessive interrupt
> latencies on uniprocessor platforms with slow variable stores.
> 
> Note that other OSes such as Windows call UEFI Runtime Services with
> interrupts enabled as well.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  drivers/firmware/efi/runtime-wrappers.c | 71 ++++++++------------
>  1 file changed, 28 insertions(+), 43 deletions(-)

Ingo, if you want to pick up this patch directly you can add my,

Reviewed-by: Matt Fleming <matt@codeblueprint.co.uk>

Otherwise let me know and I'll send you a pull request.
