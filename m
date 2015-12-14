From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: [GIT PULL 0/4] EFI changes for v4.5
Date: Mon, 14 Dec 2015 18:26:49 +0000
Message-ID: <1450117613-15438-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alan Ott <alan-TH0P2DBAz1q9FHfhHBbuYA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>, Ravi Shankar <ravi.v.shankar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ricardo Neri <ricardo.neri-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Wendy Wang <wendy.wang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Folks,

Here's a couple of cleanups and a bug fix for the ACPI BGRT driver
triggered by the recent isolated EFI page table changes currently
sitting in tip.

The following changes since commit 8005c49d9aea74d382f474ce11afbbc7d7130bec:

  Linux 4.4-rc1 (2015-11-15 17:00:27 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-next

for you to fetch changes up to 50a0cb565246f20d59cdb161778531e4b19d35ac:

  x86/efi-bgrt: Fix kernel panic when mapping BGRT data (2015-12-14 15:24:24 +0000)

----------------------------------------------------------------
 * We don't need to carry our own formatting code in the esrt driver
   because the kobject API can do that for us - Rasmus Villemoes

 * Update the arm64 file paths in Documentation/efi-stub.txt to match
   the current tree - Alan Ott

 * Consistently preface all print statements with "efi" arch/x86 so
   that it's more obvious to users reporting problems which statements
   in the kernel log are relevant for EFI - Matt Fleming

 * Fix a boot crash in the ACPI BGRT driver and delete
   efi_lookup_mapped_addr() since it's useless now that the EFI
   mappings *only* exist in the 'efi_pgd' page table. Instead we
   always early_memremap() the BGRT memory - Sai Praneeth Prakhya

----------------------------------------------------------------
Alan Ott (1):
      doc: efi-stub.txt: Fix arm64 paths

Matt Fleming (1):
      x86/efi: Preface all print statements with efi* tag

Rasmus Villemoes (1):
      efi/esrt: Don't preformat name

Sai Praneeth (1):
      x86/efi-bgrt: Fix kernel panic when mapping BGRT data

 Documentation/efi-stub.txt       |  4 ++--
 arch/x86/platform/efi/efi-bgrt.c | 42 ++++++++++++++++------------------------
 arch/x86/platform/efi/efi_64.c   |  2 ++
 arch/x86/platform/efi/quirks.c   |  4 +++-
 drivers/firmware/efi/efi.c       | 32 ------------------------------
 drivers/firmware/efi/esrt.c      |  5 +----
 6 files changed, 25 insertions(+), 64 deletions(-)
