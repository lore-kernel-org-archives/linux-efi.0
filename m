From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH] x86/efi: Auto enable EFI memmap on SGI UV systems
Date: Wed, 8 Jun 2016 13:36:23 +0100
Message-ID: <20160608123623.GW2658@codeblueprint.co.uk>
References: <1464900635-11957-1-git-send-email-jthelen@sgi.com>
 <1464900635-11957-2-git-send-email-jthelen@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1464900635-11957-2-git-send-email-jthelen-sJ/iWh9BUns@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Joseph Thelen <jthelen-sJ/iWh9BUns@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linn Crosetto <linn-ZPxbGqLxI0U@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

(Cc'ing people familiar with e820 map woes)

On Thu, 02 Jun, at 03:50:35PM, Joseph Thelen wrote:
> Currently, the EFI memory map entries are disabled by default and must
> be enabled by passing the kernel boot option:
> 
> add_efi_memmap
> 
> The EFI memory map entries should be enabled on systems with more
> than 128 E820 entries, which includes many UV systems. Check if
> we're on a UV system by chekcing the uv system table.
> Enable the EFI memory map entries if we're on a UV system.
> 
> This change is backward compatible because the EFI memory map entries are
> still disabled by default on non-UV systems, and it maintains the previous
> behavior of the kernel boot option. In addition, it allows the EFI memory
> map entries to be explicitly disabled (will not be automatically enabled)
> by setting the add_efi_memmap boot option to anything that kstringtobool
> will determine to be false.
> 
> Signed-off-by: Joseph Thelen <jthelen-sJ/iWh9BUns@public.gmane.org>
> Cc: Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>
> Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
> Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
> Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
> Cc: x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
> Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> ---
>  arch/x86/platform/efi/efi.c | 43 +++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 39 insertions(+), 4 deletions(-)
 
What's the ultimate goal here? To not require that users specify the
add_efi_memmap kernel parameter in the future? Presumably they do
today?

FYI, a lot of non-UV systems have more than 128 entries and the way we
handle it is by using the SETUP_E820_EXT setup_data entry in
boot_params in the EFI boot stub (I don't think boot loaders use it
because they largely go via the stub anyhow).

So if you've got control over your boot loader, and assuming SGI UV
systems don't boot using the EFI boot stub, you could look at adding
boot loader support for SETUP_E820_EXT to force enable > 128 entries
automatically without any new kernel code.
