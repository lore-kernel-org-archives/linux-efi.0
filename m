From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH] earlyprintk=efi,keep fix
Date: Wed, 30 Apr 2014 12:52:11 -0700
Message-ID: <20140430125211.cb33039fc1248c953bcc13dc@linux-foundation.org>
References: <20140430021303.GA12316@darkstar.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140430021303.GA12316-4/PLUo9XfK/1wF9wiOj0lkEOCMrvLtNR@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, 30 Apr 2014 10:13:03 +0800 Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

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
> To fix this issue, I added one early initcall efi_ioremap_fb which will map the whole
> efi fb for later use. OTOH, adding a wrapper function efi_ioremap which will call
> early_ioremap before ioremap is available.
> 
> With this patch applied efi boot ok with earlyprintk=efi,keep console=efi
> 

CONFIG_DEBUG_SECTION_MISMATCH should have detected this, but
CONFIG_DEBUG_SECTION_MISMATCH doesn't seem to work any more. 
scripts/Makefile.modpost appears to be trying to pass -S to modpost if
CONFIG_DEBUG_SECTION_MISMATCH, but I'm not seeing any warnings.  The
CONFIG_DEBUG_SECTION_MISMATCH Kconfig help is not useful.  What did we
do?

Shudder.  I'll assume Matt will handle this patch?
