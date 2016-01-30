From: Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/2] x86/efi: Enable restrictive mapping of EFI runtime
Date: Fri, 29 Jan 2016 17:04:38 -0800
Message-ID: <1454115880-6914-1-git-send-email-sai.praneeth.prakhya@intel.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Sai Praneeth <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, "Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>, Ricardo Neri <ricardo.neri-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ravi Shankar <ravi.v.shankar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Sai Praneeth <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

UEFI v2.5 specification introduced a new configuration table called 
EFI_PROPERTIES_TABLE. Currently it is only used to convey that UEFI 
runtime code and data sections of the executable image are separate. 
Patches ("x86/efi: Add support for EFI_MEMORY_RO attribute introduced 
by UEFIv2.5") and ("x86/efi: Add support for UEFIv2.5 Properties table")
and ("x86/efi: Introduce EFI_NX_PE_DATA bit and set it from properties 
table") have already added support for this feature and sets 
EFI_NX_PE_DATA bit if this feature is detected. The following two 
patches will update mappings of these runtime regions. Patch 1 is a 
prerequisite which modifies kernel_map_pages_pgd (), so that we could 
map regions as read/write or read-only. Patch 2 does the restrictive 
mapping for runtime regions. EFI runtime code regions are mapped 
read-only and EFI runtime data regions are mapped not executable.

Sai Praneeth (2):
  x86/mm/pageattr: Don't implicitly allow _PAGE_RW in
    kernel_map_pages_in_pgd()
  x86/efi: Map EFI_MEMORY_{XP,RO} memory region bits to EFI page tables

 arch/x86/include/asm/efi.h     |  2 +-
 arch/x86/mm/pageattr.c         |  3 +++
 arch/x86/platform/efi/efi.c    |  9 +++++--
 arch/x86/platform/efi/efi_64.c | 53 +++++++++++++++++++++++++++++++++++-------
 4 files changed, 56 insertions(+), 11 deletions(-)

Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Lee, Chun-Yi <jlee-IBi9RG/b67k@public.gmane.org>
Cc: Ricardo Neri <ricardo.neri-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Ravi Shankar <ravi.v.shankar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Signed-off-by: Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

-- 
2.1.4
