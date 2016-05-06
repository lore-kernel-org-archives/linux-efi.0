From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [GIT PULL 0/5] EFI changes for v4.7
Date: Fri,  6 May 2016 22:39:26 +0100
Message-ID: <1462570771-13324-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Borislav Petkov <bp@alien8.de>, Bryan O'Donoghue <pure.logic@nexus-software.ie>, Dan Carpenter <dan.carpenter@oracle.com>, Jeremy Compostella <jeremy.compostella@intel.com>, Jeremy Kerr <jk@ozlabs.org>, joeyli <jlee@suse.com>, Julia Lawall <Julia.Lawall@lip6.fr>, Kweh Hock Leong <hock.leong.kweh@intel.com>, Matthew Garrett <mjg59@srcf.ucam.org>, Peter Jones <pjones@redhat.com>, Saurabh Sengar <saurabh.truth@gmail.com>, Vaishali Thakkar <vaishali.thakkar@oracle.com>
List-Id: linux-efi@vger.kernel.org

Folks, this is the second pull request containing v4.7 material. The
commits are listed in priority order, with the first patch fixing an
oops in the EFI capsule code sitting in tip/efi/core, and the rest
being a compiler warning fix, static checker fix, and a couple of
cleanups.

The following changes since commit 0ec7ae928a9c19c2b7b8054507d5694a2597065e:

  efi: Remove unnecessary (and buggy) .memmap initialization from the Xen EFI driver (2016-04-29 11:06:15 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-next

for you to fetch changes up to 20948c1d9fdefa7acfaa84046f59adce9ef00f2e:

  efivarfs: Make efivarfs_file_ioctl static (2016-05-05 16:52:19 +0100)

----------------------------------------------------------------
 * Fix an oops in the EFI capsule code reported by the 0day bot
   because efi_capsule_pending() was grabbing a mutex in the emergency
   reboot path - Matt Fleming

 * Fix a compiler warning about excessive stack usage in the new efibc
   driver by kmalloc'ing the efivar_entry object - Jeremy Compostella

 * Dan Carpenter reported that it's potentially unsafe to pass the
   address of a pointer to the firmware in efi_capsule_supported().
   Instead we can skip the dynamic allocation entirely and put the
   capsule object on the stack - Matt Fleming

 * Simplify the locking in the efivars code by merging two of
   efivar_init()'s parameters into one - Julia Lawall

 * Cleanup efivarfs_file_ioctl by marking it as static since it has no
   external users - Peter Jones

----------------------------------------------------------------
Jeremy Compostella (1):
      efibc: Fix excessive stack footprint warning

Julia Lawall (1):
      efi: Merge boolean flag arguments

Matt Fleming (2):
      efi/capsule: Make efi_capsule_pending() lockless
      efi/capsule: Move 'capsule' to the stack in efi_capsule_supported()

Peter Jones (1):
      efivarfs: Make efivarfs_file_ioctl static

 drivers/firmware/efi/capsule.c | 65 ++++++++++++++++++++++++------------------
 drivers/firmware/efi/efibc.c   | 34 +++++++++++++++-------
 drivers/firmware/efi/efivars.c |  5 ++--
 drivers/firmware/efi/vars.c    | 23 +++++++--------
 fs/efivarfs/file.c             |  2 +-
 fs/efivarfs/super.c            |  3 +-
 include/linux/efi.h            |  3 +-
 7 files changed, 75 insertions(+), 60 deletions(-)
