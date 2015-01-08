From: Ricardo Neri <ricardo.neri-calderon-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [GIT PULL v2] EFI changes for next
Date: Wed, 07 Jan 2015 19:27:39 -0800
Message-ID: <54ADF92B.3010305@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Matt Domsch <Matt_Domsch-8PEkshWhKlo@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hi Matt,

This is the v2 of a pull request I submitted on Jan 5, 2015 
(http://article.gmane.org/gmane.linux.kernel.efi/5193).

If everything looks correct, please pull the following changes for next. 
I have also cc'ed the people involved in these changes so they can 
comment as well.

The details for the changes are detailed in the tag message.

Changes since v1:

  *Based pull request on the next branch of Matt's efi repository.
  *Prepended "efi:" to Peter's commit message and copied Matt Domsch.
  *Reworded Borislav's commit title to reflect better the contents of 
the patch.

Thanks and BR,
Ricardo

The following changes since commit 8266e31ed0fedb7ee16ebc86e80468f7cc1bbb4e:

   x86, ptdump: Add section for EFI runtime services (2014-11-11 
22:28:57 +0000)

are available in the git repository at:

    https://github.com/ricardon/efi.git tags/rneri-efi-next

for you to fetch changes up to 26e022727f5e88c6e5054e14d954425deacbe56a:

   efi: Rename efi_guid_unparse to efi_guid_to_str (2015-01-07 19:07:44 
-0800)

----------------------------------------------------------------
Updates included:

  *Rename the function efi_guid_unparse to reflect better its behavior. 
- Borislav Petkov

  *Update the EFI firmware Kconfig help with the URL of efibootmgr. - 
Peter Jones

----------------------------------------------------------------
Borislav Petkov (1):
       efi: Rename efi_guid_unparse to efi_guid_to_str

Peter Jones (1):
       efi: Update the URLs for efibootmgr

  block/partitions/efi.c         | 2 +-
  drivers/firmware/efi/Kconfig   | 4 ++--
  drivers/firmware/efi/efi.c     | 4 ++--
  drivers/firmware/efi/efivars.c | 6 +++---
  fs/efivarfs/super.c            | 2 +-
  include/linux/efi.h            | 2 +-
  6 files changed, 10 insertions(+), 10 deletions(-)
