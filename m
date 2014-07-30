From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 0/3 v2] arm64/efi: improve TEXT_OFFSET handling
Date: Wed, 30 Jul 2014 12:59:01 +0200
Message-ID: <1406717944-24725-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org
Cc: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Resending this series sent out yesterday with only minor changes and acks etc
added.

In summary: patch #3 relaxes the requirements imposed by the EFI stub on where
Image may be loaded, but this breaks APM Mustang (if booting via UEFI) if patch
#1 does not go in first. Patch #2 prevents potential boot issues when Image is
loaded such that the stub does not have to relocate it.

@Will: as discussed on the list yesterday, these patches should be kept in
sequence when going upstream, so it is best to take them through a single tree.
However, patch #3 will not apply cleanly to the arm64 tree until after 3.16-rc1
is released as it depends on a trivial change going in through x86/tip [efi].
[https://git.kernel.org/cgit/linux/kernel/git/mfleming/efi.git/commit/?h=next&id=6091c9c447370c4717ec9975813c874af490eb36]

If you are ok with these patches, how would you like to proceed? Patches #1 and
#2 could go in straight away (through arm64), and I can send Catalin and you a
gentle reminder once -rc1 is released to take #3? Or instead, ack them and ask
Matt to queue them for 3.17-late? It would be nice if this makes 3.17 as it
fixes actual boot problems on hardware that is under development.

Changes in v2:
- add (__force void *) cast to patch #1, as suggested in LAKML discussion
- add tested-by/acked-by lines
- rebased patch #3 onto efi-next

Mark Rutland (1):
  arm64: spin-table: handle unmapped cpu-release-addrs

Ard Biesheuvel (2):
  arm64/efi: efistub: cover entire static mem footprint in PE/COFF .text
  arm64/efi: efistub: don't abort if base of DRAM is occupied

 arch/arm64/kernel/efi-stub.c       | 18 ++++++------------
 arch/arm64/kernel/head.S           |  6 +++---
 arch/arm64/kernel/smp_spin_table.c | 21 ++++++++++++++++-----
 3 files changed, 25 insertions(+), 20 deletions(-)

-- 
1.8.3.2
