From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 0/3] arm64/efi: improve TEXT_OFFSET handling
Date: Tue, 29 Jul 2014 12:49:07 +0200
Message-ID: <1406630950-32432-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Cc: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

This is mostly a resend of patches that were circulated a week or 2 ago to
address boot failures that were observed on platforms where the base of DRAM
is occupied by firmware or by UEFI itself.

TEXT_OFFSET is somewhat of a historical artefact, and with Mark Rutland's
patches already queued for 3.17, the region below TEXT_OFFSET is actually no
longer used for early page tables etc. and the intention in the long term is
to get rid of TEXT_OFFSET completely, i.e., set it to 0

The new TEXT_OFFSET fuzzing option (which is recommended for distribution
kernels) already has the potential to break some platforms (such as APM Mustang
booting from UEFI) that assume the value of TEXT_OFFSET is large enough to allow
a small portion of memory at the base of DRAM to be reserved for things like the
SMP holding pen. If the dice roll that produces TEXT_OFFSET happens to be too
low, the kernel will currently fail to boot.

This problem, and other potential issues where the base of DRAM may not be
vacant for the kernel, are addressed by patch #3. This may result in up to 2
megabytes of memory at the low end being wasted, but with TEXT_OFFSET being set
to zero eventually, this cannot be avoided anyway.

Patch #1 was suggested by Mark to fix a failure on APM Mustang identified by
Mark Salter in bringing up the secondaries when the kernel is loaded higher than
the base of DRAM. This may happen after patch #3 is applied, and instead of
aborting, the Image is loaded 2 megs + TEXT_OFFSET bytes above the base of DRAM
rather than just TEXT_OFFSET bytes. Unfortunately, I have not been able to test
this patch myself, so if anyone is in a position to test these patches on a
UEFI APM Mustang, that would be highly appreciated.

Patch #2 ensures that the allocation done by the PE/COFF loader is large enough
so that it can be executed in place. The likelihood of this occurring is not
clear: Tianocore/EDK2 tends to load Image fairly high in memory, but a UEFI
enhanced GRUB or any other arm64 boot protocol aware intermediate loader may
well decide to put the Image in the right place before the stub is executed.

Patch #3 changes the relocation logic so that the Image is relocated to the
lowest available 2 meg boundary + TEXT_OFFSET. This eliminates a failure mode
where we used to abort if the kernel cannot be loaded at its optimal offset, and
moves always moves Image to a suitable location regardless of the existence of
low reservations or the value of TEXT_OFFSET.

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
