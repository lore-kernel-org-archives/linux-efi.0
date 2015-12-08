From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH v2 7/7] efi: runtime-wrappers: run UEFI Runtime Services
 with interrupts enabled
Date: Tue, 8 Dec 2015 13:53:44 +0000
Message-ID: <20151208135344.GE2518@codeblueprint.co.uk>
References: <1448967020-20190-1-git-send-email-ard.biesheuvel@linaro.org>
 <1448967020-20190-8-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1448967020-20190-8-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tue, 01 Dec, at 11:50:20AM, Ard Biesheuvel wrote:
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
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  drivers/firmware/efi/runtime-wrappers.c | 73 ++++++++------------
>  1 file changed, 30 insertions(+), 43 deletions(-)

Thanks Ard, this and all the other patches in this series look good to
me, apart from the comments I had for patch 4.

Once that is resolved I'd like to get this queued up for v4.5.
