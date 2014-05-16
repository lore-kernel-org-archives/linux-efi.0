From: Daniel Kiper <daniel.kiper-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v4 0/5] xen: Add EFI support
Date: Fri, 16 May 2014 22:41:39 +0200
Message-ID: <1400272904-31121-1-git-send-email-daniel.kiper@oracle.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org
Cc: boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, eshelton-e+AXbWqSrlAAvxtiuMwx3w@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, ian.campbell-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, jbeulich-IBi9RG/b67k@public.gmane.org, jeremy-TSDbQ3PG+2Y@public.gmane.org, konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, stefano.stabellini-mvvWK6WmYclDPfheJLI6IQ@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Hey,

This patch series adds EFI support for Xen dom0 guests.
It is based on Jan Beulich and Tang Liang work. I was
trying to take into account all previous comments,
however, if I missed something sorry for that.

I am still not sure what to do with /sys/firmware/efi/config_table,
/sys/firmware/efi/{fw_vendor,runtime,systab} files. On bare metal
they contain physical addresses of relevant structures. However,
in Xen case they does not make sens. So maybe they should contain
invalid values (e.g. 0) or should not appear at all on Xen (I prefer
last one). What do you think about that?

Daniel

 arch/x86/kernel/setup.c          |    6 +-
 arch/x86/platform/efi/efi.c      |   60 ++++++++++----
 arch/x86/xen/enlighten.c         |   26 ++++++
 drivers/xen/Kconfig              |    3 +
 drivers/xen/Makefile             |    1 +
 drivers/xen/efi.c                |  374 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/efi.h              |   13 +--
 include/xen/interface/platform.h |  123 +++++++++++++++++++++++++++
 8 files changed, 582 insertions(+), 24 deletions(-)

Daniel Kiper (5):
      efi: Introduce EFI_DIRECT flag
      xen: Define EFI related stuff
      xen: Put EFI machinery in place
      arch/x86: Replace plain strings with constants
      arch/x86: Remove redundant set_bit() call
