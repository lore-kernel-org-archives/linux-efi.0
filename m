From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH 3/4] efi: add Persistent Memory type name
Date: Fri, 8 Jan 2016 12:20:31 +0000
Message-ID: <20160108122031.GJ2532@codeblueprint.co.uk>
References: <1450402114-3606-1-git-send-email-elliott@hpe.com>
 <1450402114-3606-4-git-send-email-elliott@hpe.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1450402114-3606-4-git-send-email-elliott-ZPxbGqLxI0U@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Robert Elliott <elliott-ZPxbGqLxI0U@public.gmane.org>
Cc: tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, 17 Dec, at 07:28:33PM, Robert Elliott wrote:
> Add the "Persistent Memory" string for type 14 introduced in
> UEFI 2.5.  This is used when printing the UEFI memory map.
> 
> old:
> efi: mem61: [type=14            |   |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x0000000880000000-0x0000000c7fffffff) (16384MB)
> 
> new:
> efi: mem61: [Persistent Memory  |   |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x0000000880000000-0x0000000c7fffffff) (16384MB)
> 
> Signed-off-by: Robert Elliott <elliott-ZPxbGqLxI0U@public.gmane.org>
> ---
>  drivers/firmware/efi/efi.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Thanks, applied.
