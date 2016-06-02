From: Joseph Thelen <jthelen-sJ/iWh9BUns@public.gmane.org>
Subject: [RFC PATCH] x86/efi: Auto enable EFI memmap on SGI UV systems
Date: Thu,  2 Jun 2016 15:50:34 -0500
Message-ID: <1464900635-11957-1-git-send-email-jthelen@sgi.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Joseph Thelen <jthelen-sJ/iWh9BUns@public.gmane.org>, Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

The intent here is to automatically enable the EFI memory map entries
on SGI UV systems, which can have more than 128 E820 entries and
will cause headaches if the EFI memory map entries are not added.

The assumption is made that the community would prefer that this change
be a UV specific quirk, as opposed to automatically adding the EFI
memory map entries whenever more then 128 E820 entries exist. If this
assumption is incorrect, the patch can be changed to check the number
of E820 entries rather than for whether or not the system is a UV.

Cc: Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Joseph Thelen (1):
  x86/efi: Auto enable EFI memmap on SGI UV systems

 arch/x86/platform/efi/efi.c | 43 +++++++++++++++++++++++++++++++++++++++----
 1 file changed, 39 insertions(+), 4 deletions(-)

-- 
1.8.5.6
