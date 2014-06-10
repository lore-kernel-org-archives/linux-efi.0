From: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [RFC] Best place/method to determine BIOS version?
Date: Tue, 10 Jun 2014 10:03:00 +0200
Message-ID: <20140610080300.GA28607@pd.tnic>
References: <20140609200017.GD2700@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140609200017.GD2700-sJ/iWh9BUns@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>
Cc: Linux EFI <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Russ Anderson <rja-sJ/iWh9BUns@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Jun 09, 2014 at 03:00:17PM -0500, Alex Thorlton wrote:
> Hi guys,
> 
> We recently ran into/corrected a bug in our BIOS that was exposed by the
> recent updates to the way that the EFI code maps in memory during boot.
> Discussion here:
> 
> http://comments.gmane.org/gmane.linux.kernel/1638074
> 
> Anyways, we now need to find a way to determine the BIOS version before
> efi_apply_memmap_quirks is called, so that we know whether or not the
> BIOS we're running requires the quirk.  We have a function in one of our
> EFI runtime services that provides this information, but I'm having a
> lot of trouble calling this function early enough in boot.
> 
> It seems that all the necessary function pointers are available well
> before efi_apply_memmap_quirks is called, but when trying to use
> efi_call_phys6 to call our function,

Why not use DMI instead of EFI for getting the BIOS version? I see
dmi_scan_machine() called earlier than efi_apply_memmap_quirks() in
setup_arch()...?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
