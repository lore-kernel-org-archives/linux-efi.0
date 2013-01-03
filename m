From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: [RFC PATCH 0/2] EFI facilities bitfield
Date: Thu,  3 Jan 2013 13:18:03 +0000
Message-ID: <1357219085-4312-1-git-send-email-matt@console-pimps.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Langasek <steve.langasek-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Olof Johansson <olof-nZhT3qVonbNeoWH0uzbU5w@public.gmane.org>, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Various users expect different semantics from 'efi_enabled', and one
variable can't be all things to all users. Introduce an EFI facilities
bitfield, which informs users what EFI initialisation steps were
completed successfully (are the system/config tables mapped, can we
invoke runtime services, etc?) and allows users to clearly document
which pieces of EFI firmware functionality they're using.

The immediate motivation for this patch series is the bug report at,

    https://bugzilla.kernel.org/show_bug.cgi?id=47121

Drivers need a new means of detecting whether they're running on an
EFI machine, as sadly the expression,

    if (!efi_enabled)

hasn't been a sufficient condition for quite some time.

This series has only seen minimal runtime testing since it's an RFC
and is intended to start a discussion.

Matt Fleming (2):
  efi: Make 'efi_enabled' a function to query EFI facilities
  samsung-laptop: Disable on EFI hardware

 arch/x86/include/asm/efi.h             |  1 +
 arch/x86/kernel/reboot.c               |  2 +-
 arch/x86/kernel/setup.c                | 28 ++++++++---------
 arch/x86/platform/efi/efi.c            | 55 ++++++++++++++++++++--------------
 drivers/acpi/osl.c                     |  2 +-
 drivers/firmware/dmi_scan.c            |  2 +-
 drivers/firmware/efivars.c             |  4 +--
 drivers/firmware/iscsi_ibft_find.c     |  2 +-
 drivers/gpu/drm/radeon/radeon_device.c |  3 +-
 drivers/platform/x86/ibm_rtl.c         |  2 +-
 drivers/platform/x86/samsung-laptop.c  |  3 ++
 drivers/scsi/isci/init.c               |  2 +-
 include/linux/efi.h                    | 24 +++++++++++----
 init/main.c                            |  4 +--
 14 files changed, 80 insertions(+), 54 deletions(-)

-- 
1.7.11.7
