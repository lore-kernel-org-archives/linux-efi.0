From: Mike Krinkin <krinkin.m.u-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Cannot load linux after recent efi-related changes
Date: Sat, 17 Sep 2016 19:24:00 +0300
Message-ID: <20160917162357.GA4122@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, ricardo.neri-calderon-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, scott.lawson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Hello,

after commit 3dad6f7f6975 ("x86/efi: Defer efi_esrt_init until after
memblock_x86_fill") kernel hits BUG_ON __efi_enter_virtual_mode because
efi.systab is NULL. With older kernel versions i face the problem with
efi_mem_reserve described in the commit.

AFAICS, get_systab_virt_addr called from efi_map_regions should set
efi.systab, but i dumped memory desciptors in efi_map_regions and
apparently none of them describes region that contains efi_phys.systab,
so efi.systab remains unset.
