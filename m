From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH] efi: Quirk out SGI UV
Date: Tue, 4 Mar 2014 17:27:24 +0000
Message-ID: <20140304172130.GB3037@console-pimps.org>
References: <1393948937-21840-1-git-send-email-bp@alien8.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1393948937-21840-1-git-send-email-bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Russ Anderson <rja-sJ/iWh9BUns@public.gmane.org>, Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>, Linux EFI <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 04 Mar, at 05:02:17PM, Borislav Petkov wrote:
> From: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
> 
> Getting this thing to work with the new mapping scheme would need more
> work.
> 
> Signed-off-by: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
> ---
>  arch/x86/include/asm/efi.h  |  1 +
>  arch/x86/kernel/setup.c     | 10 ++--------
>  arch/x86/platform/efi/efi.c | 20 ++++++++++++++++++++
>  3 files changed, 23 insertions(+), 8 deletions(-)

Thanks, applied to 'urgent' with an updated commit message.

-- 
Matt Fleming, Intel Open Source Technology Center
