From: Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>
Subject: [RFC] Best place/method to determine BIOS version?
Date: Mon, 9 Jun 2014 15:00:17 -0500
Message-ID: <20140609200017.GD2700@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux EFI <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Russ Anderson <rja-sJ/iWh9BUns@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hi guys,

We recently ran into/corrected a bug in our BIOS that was exposed by the
recent updates to the way that the EFI code maps in memory during boot.
Discussion here:

http://comments.gmane.org/gmane.linux.kernel/1638074

Anyways, we now need to find a way to determine the BIOS version before
efi_apply_memmap_quirks is called, so that we know whether or not the
BIOS we're running requires the quirk.  We have a function in one of our
EFI runtime services that provides this information, but I'm having a
lot of trouble calling this function early enough in boot.

It seems that all the necessary function pointers are available well
before efi_apply_memmap_quirks is called, but when trying to use
efi_call_phys6 to call our function, I always hit a kernel paging error.

I think the problem is that I really need to be doing this at a point
where I can directly use physical addressing (the function pointer that
we have stored in efi.uv_systab contains the physical address of our
function) - at least that's the idea I get from our BIOS guys, but I
really don't know what I'm talking about here :)

Can anybody help me with how early in boot I need to make this call, and
possibly with an appropriate location to stick the code in?

Any advice is greatly appreciated.  Thanks!

- Alex
