From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH v2] x86/efi: always map first physical page into EFI
 pagetables
Date: Fri, 27 Jan 2017 16:23:15 +0000
Message-ID: <20170127162315.GG31613@codeblueprint.co.uk>
References: <alpine.LSU.2.20.1701252048550.25515@cbobk.fhfr.pm>
 <alpine.LSU.2.20.1701252130410.25515@cbobk.fhfr.pm>
 <20170127151248.GF31613@codeblueprint.co.uk>
 <alpine.LSU.2.20.1701271638240.25515@cbobk.fhfr.pm>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.20.1701271638240.25515-YHPUNQjx9ReKbouaWp301Q@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jiri Kosina <jikos-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Waiman Long <waiman.long-ZPxbGqLxI0U@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Laura Abbott <labbott-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vojtech Pavlik <vojtech-+ZI9xUNit7I@public.gmane.org>, Hanka Pavlikova <hanka-+ZI9xUNit7I@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Fri, 27 Jan, at 04:39:59PM, Jiri Kosina wrote:
> From: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>
> 
> Commit 129766708 ("x86/efi: Only map RAM into EFI page tables if in 
> mixed-mode") stopped creating 1:1 mapping for all RAM in case of running 
> in native 64bit mode.
> 
> It turns out though that there are 64bit EFI implementations in the wild 
> (this particular problem has been reported on Lenovo Yoga 710-11IKB) which 
> still make use of first physical page for their own private use even 
> though they explicitly mark it EFI_CONVENTIONAL_MEMORY in the memory map.
> 
> In case there is no mapping for this particular frame in EFI pagetables, 
> as soon as firmware tries to make use of it, triple fault occurs and the 
> system reboots (in case of Yoga 710-11IKB this is very early during boot).
> 
> Fix that by always mapping the first page of physical memory into EFI 
> pagetables. We're on a safe side, as trim_bios_range() will reserve the 
> first page and isolate it away from memory allocators anyway.
> 
> Note: just reverting 129766708 is not enough on v4.9-rc1+ to fix the 
> regression on affected hardware, as commit ab72a27da ("x86/efi: 
> Consolidate region mapping logic") later made the first physical frame not 
> to be mapped anyway.
> 
> Fixes: 129766708 ("x86/efi: Only map RAM into EFI page tables if in mixed-mode")
> Cc: stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org # v4.8+
> Cc: Waiman Long <waiman.long-ZPxbGqLxI0U@public.gmane.org>
> Cc: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
> Cc: Laura Abbott <labbott-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Vojtech Pavlik <vojtech-+ZI9xUNit7I@public.gmane.org>
> Reported-by: Hanka Pavlikova <hanka-+ZI9xUNit7I@public.gmane.org>
> Signed-off-by: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>
> ---
 
Thanks Jiri. Queued for v4.10-rc6.
