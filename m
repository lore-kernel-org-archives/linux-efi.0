From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: [GIT PULL] EFI runtime mapping work for v3.14
Date: Fri, 8 Nov 2013 10:57:19 +0000
Message-ID: <20131108105719.GB2318@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Folks, could you queue up the following for the v3.14 merge window? It
would be good to get these patches into linux-next for a full release
cycle of testing. They pass all of my tests.

The following changes since commit 72548e836b0c4abbb652e791dee9c91203a9a4c6:

  x86/efi: Add EFI framebuffer earlyprintk support (2013-10-28 18:09:58 +0000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-next

for you to fetch changes up to ee41143027706d9f342dfe05487a00b20887fde7:

  x86/efi: Check krealloc return value (2013-11-02 11:09:36 +0000)

----------------------------------------------------------------
 * New static EFI runtime services virtual mapping layout which is
   groundwork for kexec support on EFI - Borislav Petkov

----------------------------------------------------------------
Borislav Petkov (11):
      x86/efi: Simplify EFI_DEBUG
      x86/mm/pageattr: Lookup address in an arbitrary PGD
      x86/mm/pageattr: Add a PGD pagetable populating function
      x86/mm/pageattr: Add a PUD pagetable populating function
      x86/mm/pageattr: Add a PMD pagetable populating function
      x86/mm/pageattr: Add a PTE pagetable populating function
      x86/mm/pageattr: Add a PUD error unwinding path
      x86/mm/pageattr: Add last levels of error path
      x86/mm/cpa: Map in an arbitrary pgd
      x86/efi: Runtime services virtual mapping
      x86/efi: Check krealloc return value

 Documentation/kernel-parameters.txt  |   6 +
 Documentation/x86/x86_64/mm.txt      |   7 +
 arch/x86/include/asm/efi.h           |  64 +++--
 arch/x86/include/asm/pgtable_types.h |   3 +-
 arch/x86/mm/pageattr.c               | 461 +++++++++++++++++++++++++++++++++--
 arch/x86/platform/efi/efi.c          | 111 ++++++---
 arch/x86/platform/efi/efi_32.c       |   9 +-
 arch/x86/platform/efi/efi_64.c       | 109 +++++++++
 arch/x86/platform/efi/efi_stub_64.S  |  54 ++++
 include/linux/efi.h                  |   1 +
 10 files changed, 755 insertions(+), 70 deletions(-)

-- 
Matt Fleming, Intel Open Source Technology Center
