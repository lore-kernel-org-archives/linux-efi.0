From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: [GIT PULL] EFI changes for v4.2
Date: Sun, 31 May 2015 17:25:59 +0100
Message-ID: <20150531162559.GA6826@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Hi folks,

Please pull the following new material for v4.2. The most interesting
change is support for the EFI System Resource Table contributed by Peter
Jones. ESRT is new in the UEFI 2.5 specification (released April 2015)
and is used by Fedora's fwupdate tool when performing firmware updates.

The following changes since commit b787f68c36d49bb1d9236f403813641efa74a031:

  Linux 4.1-rc1 (2015-04-26 17:59:10 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-next

for you to fetch changes up to c208358c2cc832eeb5b341a465eee30be19cd5a0:

  efi: Add 'systab' information to Documentation/ABI (2015-05-27 15:40:20 +0100)

----------------------------------------------------------------
 * Use idiomatic negative error values in efivar_create_sysfs_entry()
   instead of returning '1' to indicate error - Dan Carpenter

 * New support to expose the EFI System Resource Tables in sysfs, which
   provides information for performing firmware updates - Peter Jones

 * Documentation cleanup in the EFI handover protocol section which
   falsely claimed that 'cmdline_size' needed to be filled out by the
   boot loader - Alex Smith

 * Align the order of SMBIOS tables in /sys/firmware/efi/systab to match
   the way that we do things for ACPI and add documentation to
   Documentation/ABI - Jean Delvare

----------------------------------------------------------------
Alex Smith (1):
      x86, doc: Remove cmdline_size from list of fields to be filled in for EFI handover

Dan Carpenter (1):
      efi: efivar_create_sysfs_entry() should return negative error codes

Jean Delvare (1):
      efi: dmi: List SMBIOS3 table before SMBIOS table

Matt Fleming (1):
      efi: Add 'systab' information to Documentation/ABI

Peter Jones (2):
      efi: Add esrt support
      efi/esrt: Fix some compiler warnings

 Documentation/ABI/testing/sysfs-firmware-efi      |  10 +
 Documentation/ABI/testing/sysfs-firmware-efi-esrt |  81 ++++
 Documentation/x86/boot.txt                        |   1 -
 arch/x86/platform/efi/efi.c                       |   2 +
 drivers/firmware/efi/Makefile                     |   2 +-
 drivers/firmware/efi/efi.c                        |  91 ++++-
 drivers/firmware/efi/efivars.c                    |  11 +-
 drivers/firmware/efi/esrt.c                       | 471 ++++++++++++++++++++++
 include/linux/efi.h                               |   8 +
 9 files changed, 667 insertions(+), 10 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-firmware-efi-esrt
 create mode 100644 drivers/firmware/efi/esrt.c

-- 
Matt Fleming, Intel Open Source Technology Center
