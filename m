From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH v2] efi/libstub: arm*: Pass latest memory map to the
 kernel
Date: Mon, 19 Dec 2016 21:38:59 +0000
Message-ID: <20161219213859.GA2225@codeblueprint.co.uk>
References: <20161219142419.16780-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161219142419.16780-1-james.morse-5wv7dgnIgG8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, jhugo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Mon, 19 Dec, at 02:24:19PM, James Morse wrote:
> From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> 
> As reported by James, the current libstub code involving the annotated
> memory map only works somewhat correctly by accident, due to the fact
> that a pool allocation happens to be reused immediately, retaining its
> former contents.
> 
> Instead of juggling memory maps, which makes the code more complex than
> it needs to be, simply put a placholder value into the FDT, and only
> write the actual value after ExitBootServices() has been called.
> 
> Reported-by: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> [Update mmap-size too, remove updated_fdt()s unused params and header entry]
> Signed-off-by: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
> ---
> Hi Ard,
> 
> This is a v2 of your patch that updates the mmap-size too. This solves the
> truncated memmap problem I saw with v1 on Seattle.
> 
> The original patch was CC-stable, so I think this should also have:
> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
> Fixes: ed9cc156c42f ("efi/libstub: Use efi_exit_boot_services() in FDT")
> 
> 
> Thanks,
> 
> James
> 
>  drivers/firmware/efi/libstub/efistub.h |  8 ----
>  drivers/firmware/efi/libstub/fdt.c     | 75 +++++++++++++++++++++-------------
>  2 files changed, 47 insertions(+), 36 deletions(-)

Thanks James. I've queued this one up in the 'urgent' queue and tagged
it for stable. I'll send it to tip before the end of the week.
