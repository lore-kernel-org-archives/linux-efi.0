From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH V2] earlyprintk=efi,keep fix
Date: Fri, 2 May 2014 14:00:31 +0100
Message-ID: <20140502130031.GT26088@console-pimps.org>
References: <20140501131548.GA15258@darkstar.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140501131548.GA15258-4/PLUo9XfK/1wF9wiOj0lkEOCMrvLtNR@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, 01 May, at 09:15:48PM, Dave Young wrote:
> 
> earlyprintk=efi,keep will cause kernel hangs while freeing initmem like below:
> [    2.826089] VFS: Mounted root (ext4 filesystem) readonly on device 254:2.
> [    2.846592] devtmpfs: mounted
> [    2.856974] Freeing unused kernel memory: 880K (ffffffff817d4000 - ffffffff818b0000)
> 
> It is caused by efi earlyprintk use __init function which will be freed later.
> Such as early_efi_write is marked as __init, also it will use early_ioremap
> which is init function as well.
> 
> To fix this issue, I added early initcall early_efi_map_fb which maps the whole
> efi fb for later use. OTOH, adding a wrapper function early_efi_map which calls
> early_ioremap before ioremap is available.
> 
> With this patch applied efi boot ok with earlyprintk=efi,keep console=efi
> 
> Signed-off-by: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  arch/x86/platform/efi/early_printk.c |   83 ++++++++++++++++++++++++++---------
>  1 file changed, 64 insertions(+), 19 deletions(-)

Thanks Dave, applied!

-- 
Matt Fleming, Intel Open Source Technology Center
