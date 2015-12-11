From: Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>
Subject: [PATCHv2] Remove EFI memmap quirk for UV
Date: Fri, 11 Dec 2015 14:59:44 -0600
Message-ID: <1449867585-189233-1-git-send-email-athorlton@sgi.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Dimitri Sivanich <sivanich-sJ/iWh9BUns@public.gmane.org>, Hedi Berriche <hedi-sJ/iWh9BUns@public.gmane.org>, Mike Travis <travis-sJ/iWh9BUns@public.gmane.org>, Len Brown <len.brown-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Hey guys,

This is my second shot at a patch to remove this quirk.  This version
uses dmi_check_system to determine if we're on a UV that still needs
the quirk, to avoid issues on older hardware.

Let me know what everyone thinks!

Signed-off-by: Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Dimitri Sivanich <sivanich-sJ/iWh9BUns@public.gmane.org>
Cc: Hedi Berriche <hedi-sJ/iWh9BUns@public.gmane.org>
Cc: Mike Travis <travis-sJ/iWh9BUns@public.gmane.org>
Cc: Len Brown <len.brown-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Alex Thorlton (1):
  Remove EFI memmap quirk for UV2+

 arch/x86/kernel/apic/x2apic_uv_x.c |  5 ++++-
 arch/x86/platform/efi/quirks.c     | 17 +++++++++++++----
 2 files changed, 17 insertions(+), 5 deletions(-)

-- 
1.8.5.6
