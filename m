From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 0/2] arm64/efi: adapt to UEFI 2.5 properties table changes
Date: Tue, 30 Jun 2015 12:17:21 +0200
Message-ID: <1435659443-17625-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org
Cc: leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

First of all, I am aware that it is not customary to send non-trivial series
during the merge window. However, since a parallel discussion is currently
taking place on the edk2-devel mailing list, I think it makes sense to make
an exception for this series.

Version 2.5 of the UEFI spec introduces a new Properties Table feature
that splits the memory regions covered by PE/COFF executable images
into regions with the appropriate permissions for the underlying segment
(i.e., RuntimeServicesCode/R-X for .text and RuntimeServiceData/rw- for
.data)

Unfortunately, this feature is built on the backwards incompatible assumption
that the OS always maps all RuntimeServicesCode and RuntimeServiceData regions
in a way that keeps adjacent code and data regions adjacent. Since this is
not what we are currently doing for arm64, some changes are required.

The first patch makes the mapping permission logic compliant with the spec,
by mapping all RuntimeServicesCode *and* RuntimeServicesData regions RWX,
(formerly, we were using RW- for data regions), unless any of the
EFI_MEMORY_RO and EFI_MEMORY_XP attributes are set, and the region is fully
aligned to the page size (which may not always be the case on 64k pages)

Then, in patch #2, we change the virtual remapping logic to keep adjacent
EFI_MEMORY_RUNTIME regions together. This requires us to sort the incoming
memory map, since the UEFI spec does not guarantee that it is sorted (although
it usually is).

This series applies on top of the patch that introduces the EFI_MEMORY_RO
region attribute, which can be found here:
http://article.gmane.org/gmane.linux.kernel.efi/5819

Ard Biesheuvel (2):
  arm64/efi: base UEFI mapping permissions on region attributes
  arm64/efi: don't pad between EFI_MEMORY_RUNTIME regions

 arch/arm64/kernel/efi.c                 | 32 +++++++----
 drivers/firmware/efi/libstub/arm-stub.c | 58 +++++++++++++++-----
 2 files changed, 64 insertions(+), 26 deletions(-)

-- 
1.9.1
