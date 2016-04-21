From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH] x86/efi: Remove the always true EFI_DEBUG symbol
Date: Thu, 21 Apr 2016 13:48:20 +0100
Message-ID: <20160421124820.GF2829@codeblueprint.co.uk>
References: <1461236970-19275-1-git-send-email-matt@codeblueprint.co.uk>
 <20160421124542.GF28821@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160421124542.GF28821-fF5Pk5pvG8Y@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Robert Elliott <elliott-ZPxbGqLxI0U@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, 21 Apr, at 02:45:42PM, Borislav Petkov wrote:
> On Thu, Apr 21, 2016 at 12:09:30PM +0100, Matt Fleming wrote:
> > This symbol is always set which makes it useless. Additionally we have
> > a kernel command-line switch, efi=debug, which actually controls the
> > printing of the memory map.
> > 
> > Reported-by: Robert Elliott <elliott-ZPxbGqLxI0U@public.gmane.org>
> > Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
> > Signed-off-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
> > ---
> >  arch/x86/platform/efi/efi.c | 4 ----
> >  1 file changed, 4 deletions(-)
> 
> Acked-by: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
> 
> Btw, there's also
> 
> arch/ia64/kernel/efi.c:45:#define EFI_DEBUG     0
> arch/ia64/kernel/efi.c:399:#if EFI_DEBUG
> arch/ia64/kernel/efi.c:559:#if EFI_DEBUG
> 
> I'm assuming you want to put that behind "if (efi_enabled(EFI_DBG))" too...

Hmm.. Yes, that'd be a good idea. I am in the process of setting up an
Itanium box or two for runtime EFI testing, so I'll make a note of
this task.
