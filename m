From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: [PATCH 00/20] EFI changes for v3.8
Date: Fri, 26 Oct 2012 08:51:43 +0100
Message-ID: <1351237923-10313-1-git-send-email-matt@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Andy Whitcroft <apw-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Jan Beulich <JBeulich-IBi9RG/b67k@public.gmane.org>, Chun-Yi Lee <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

I've got the following patches queued up on my next branch for the
v3.8 merge window. The patches are available at,

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git next

The main changes are,

    * A new EFI variable filesystem, efivarfs, which addresses the
      shortcomings of the old sysfs EFI variable code.

    * We now switch to a 1:1 mapped pagetable for all virtual EFI
      calls. This is actually a workaround for an ASUS firmware bug
      which expects the physical mapping to still be around at
      runtime.

    * Because of the above fix Jan's patch to use EFI for the platform
      wall clock can be re-applied (it was originally reverted because
      it broke some ASUS machines).

Andy Whitcroft (5):
  efivarfs: efivarfs_file_read ensure we free data in error paths
  efivarfs: efivarfs_create() ensure we drop our reference on inode on
    error
  efivarfs: efivarfs_fill_super() fix inode reference counts
  efivarfs: efivarfs_fill_super() ensure we free our temporary name
  efivarfs: efivarfs_fill_super() ensure we clean up correctly on error

Jan Beulich (1):
  x86-64/efi: Use EFI to deal with platform wall clock (again)

Jeremy Kerr (3):
  efi: Handle deletions and size changes in efivarfs_write_file
  efivarfs: Implement exclusive access for {get,set}_variable
  efi: Clarify GUID length calculations

Lee, Chun-Yi (1):
  efi: add efivars kobject to efi sysfs folder

Matt Fleming (8):
  efivarfs: Add documentation for the EFI variable filesystem
  x86, mm: Include the entire kernel memory map in trampoline_pgd
  x86, efi: 1:1 pagetable mapping for virtual EFI calls
  efivarfs: Return an error if we fail to read a variable
  efivarfs: Replace magic number with sizeof(attributes)
  efivarfs: Add unique magic number
  efivarfs: Make 'datasize' unsigned long
  efivarfs: Return a consistent error when efivarfs_get_inode() fails

Matthew Garrett (1):
  efi: Add support for a UEFI variable filesystem

Xiaoyan Zhang (1):
  x86/kernel: remove tboot 1:1 page table creation code

 Documentation/filesystems/00-INDEX     |   2 +
 Documentation/filesystems/efivarfs.txt |  16 ++
 arch/x86/include/asm/efi.h             |  28 +-
 arch/x86/kernel/tboot.c                |  78 +-----
 arch/x86/mm/init_64.c                  |   9 +-
 arch/x86/mm/ioremap.c                  | 105 +++++++
 arch/x86/mm/pageattr.c                 |  10 +-
 arch/x86/platform/efi/efi.c            |  30 +-
 arch/x86/platform/efi/efi_64.c         |  15 +
 arch/x86/realmode/init.c               |  17 +-
 drivers/firmware/efivars.c             | 487 ++++++++++++++++++++++++++++++++-
 include/linux/efi.h                    |   8 +-
 include/uapi/linux/magic.h             |   1 +
 init/main.c                            |   8 +-
 14 files changed, 687 insertions(+), 127 deletions(-)
 create mode 100644 Documentation/filesystems/efivarfs.txt

-- 
1.7.11.7
