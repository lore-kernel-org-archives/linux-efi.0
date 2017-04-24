From: Julien Grall <julien.grall-5wv7dgnIgG8@public.gmane.org>
Subject: [PATCH 0/3 v2] xen: Implement EFI reset_system callback
Date: Mon, 24 Apr 2017 18:58:36 +0100
Message-ID: <20170424175839.5262-1-julien.grall@arm.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org
Cc: sstabellini-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Julien Grall <julien.grall-5wv7dgnIgG8@public.gmane.org>, Boris Ostrovsky <boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Juergen Gross <jgross-IBi9RG/b67k@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hi all,

This small patch series implements EFI reset_system callback when using EFI
Xen. Without this, it will not be possible to reboot/power off ARM64 DOM0
when using ACPI.

Cheers,

Cc: Boris Ostrovsky <boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Juergen Gross <jgross-IBi9RG/b67k@public.gmane.org>

Julien Grall (3):
  xen: Export xen_reboot
  arm/xen: Consolidate calls to shutdown hypercall in a single helper
  xen: Implement EFI reset_system callback

 arch/arm/xen/efi.c       |  2 +-
 arch/arm/xen/enlighten.c | 16 ++++++++++------
 arch/x86/xen/efi.c       |  2 +-
 arch/x86/xen/enlighten.c |  2 +-
 drivers/xen/efi.c        | 18 ++++++++++++++++++
 include/xen/xen-ops.h    |  5 +++++
 6 files changed, 36 insertions(+), 9 deletions(-)

-- 
2.11.0
