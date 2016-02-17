From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: [PATCH 0/2] ACPI, x86/efi: Remove ACPI BGRT tables for kexec
Date: Wed, 17 Feb 2016 15:45:08 +0000
Message-ID: <1455723910-16710-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, "Rafael J . Wysocki" <rafael.j.wysocki-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Based on Dave's report that the BGRT image regions are being accessed
on kexec reboot (which by that time contain garbage),

  https://lkml.kernel.org/r/20160127112044.GA2961-0VdLhd/A9Pl+NNSt+8eSiB/sF2h8X+2i0E9HWUfgJXw@public.gmane.org

the following patches simply delete the table when doing a kexec boot.

This is part of a wider compaign to stop kexec-specific code from
leaking into all parts of arch/x86. Instead of sprinkling "if
(efi_setup)", kexec should be shaping the platform information to more
accurately describe which features are still available, so that
existing drivers work transparently without kexec quirks.

Matt Fleming (2):
  ACPICA: Tables: Add function to remove ACPI tables
  x86/efi: Delete ACPI BGRT when booting via kexec

 arch/x86/include/asm/efi.h    |  1 +
 arch/x86/kernel/setup.c       |  4 +++-
 arch/x86/platform/efi/efi.c   | 38 ++++++++++++++++++++++++++++++
 drivers/acpi/acpica/tbxface.c | 54 +++++++++++++++++++++++++++++++++++++++++++
 include/acpi/acpixf.h         |  3 +++
 5 files changed, 99 insertions(+), 1 deletion(-)

-- 
2.6.2
