From: Ricardo Neri <ricardo.neri-calderon-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [GIT PULL] EFI changes for next
Date: Mon, 05 Jan 2015 11:28:09 -0800
Message-ID: <1420486089.17206.35.camel@ranerica-desk01>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Fleming, Matt" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hi Matt,

Please pull the following changes for next. This includes a change in
the help text of EFI firmware Kconfig to update the URL of efibootgr.

It also renames the efi_guid_unparse to reflect better the behavior of
the function.

Thanks and BR,
Ricardo

The following changes since commit
b7392d2247cfe6771f95d256374f1a8e6a6f48d6:

  Linux 3.19-rc2 (2014-12-28 16:49:37 -0800)

are available in the git repository at:

  https://github.com/ricardon/efi.git tags/rneri-efi-next

for you to fetch changes up to 2364a022398a7cda70494cf53b1b529bf88830b0:

  efi: mv efi_guid_unparse -> efi_guid_to_str (2014-12-31 16:40:09
-0800)

----------------------------------------------------------------
Updates on EFI firmware Kconfig help text and a function rename

----------------------------------------------------------------
Borislav Petkov (1):
      efi: mv efi_guid_unparse -> efi_guid_to_str

Peter Jones (1):
      Update the URLs for efibootmgr.

 block/partitions/efi.c         | 2 +-
 drivers/firmware/efi/Kconfig   | 4 ++--
 drivers/firmware/efi/efi.c     | 4 ++--
 drivers/firmware/efi/efivars.c | 6 +++---
 fs/efivarfs/super.c            | 2 +-
 include/linux/efi.h            | 2 +-
 6 files changed, 10 insertions(+), 10 deletions(-)
