From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH 1/2] x86, efi: rename print_efi_memmap() to
 efi_print_memmap()
Date: Sat, 10 Oct 2015 20:31:39 +0100
Message-ID: <20151010193139.GD2723@codeblueprint.co.uk>
References: <1443608292-37686-1-git-send-email-izumi.taku@jp.fujitsu.com>
 <1443608400-37744-1-git-send-email-izumi.taku@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1443608400-37744-1-git-send-email-izumi.taku-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Taku Izumi <izumi.taku-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, qinxishi-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, 30 Sep, at 07:20:00PM, Taku Izumi wrote:
> This patch renames print_efi_memmap() to efi_print_memmap() and
> make it global function so that we can invoke it outside of
> arch/x86/platform/efi/efi.c
> 
> Signed-off-by: Taku Izumi <izumi.taku-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
> ---
>  arch/x86/include/asm/efi.h  | 1 +
>  arch/x86/platform/efi/efi.c | 4 ++--
>  2 files changed, 3 insertions(+), 2 deletions(-)

Thanks, applied.

-- 
Matt Fleming, Intel Open Source Technology Center
