From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH] x86/efi: Remove the always true EFI_DEBUG symbol
Date: Thu, 21 Apr 2016 14:45:42 +0200
Message-ID: <20160421124542.GF28821@pd.tnic>
References: <1461236970-19275-1-git-send-email-matt@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1461236970-19275-1-git-send-email-matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Robert Elliott <elliott-ZPxbGqLxI0U@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, Apr 21, 2016 at 12:09:30PM +0100, Matt Fleming wrote:
> This symbol is always set which makes it useless. Additionally we have
> a kernel command-line switch, efi=debug, which actually controls the
> printing of the memory map.
> 
> Reported-by: Robert Elliott <elliott-ZPxbGqLxI0U@public.gmane.org>
> Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
> Signed-off-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
> ---
>  arch/x86/platform/efi/efi.c | 4 ----
>  1 file changed, 4 deletions(-)

Acked-by: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>

Btw, there's also

arch/ia64/kernel/efi.c:45:#define EFI_DEBUG     0
arch/ia64/kernel/efi.c:399:#if EFI_DEBUG
arch/ia64/kernel/efi.c:559:#if EFI_DEBUG

I'm assuming you want to put that behind "if (efi_enabled(EFI_DBG))" too...

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
