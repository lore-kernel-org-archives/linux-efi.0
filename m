From: Roy Franz <roy.franz@linaro.org>
Subject: [PATCH V2 ] Improve EFI stub command line conversion
Date: Sat, 28 Sep 2013 10:32:56 -0700
Message-ID: <1380389577-27039-1-git-send-email-roy.franz@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, matt.fleming@intel.com, linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk
Cc: msalter@redhat.com, hpa@zytor.com, Roy Franz <roy.franz@linaro.org>
List-Id: linux-efi@vger.kernel.org

Improve the conversion of the UTF-16 EFI command line
to UTF-8 for passing to the kernel.

Depends on series:
[PATCH V4 0/6] ADD ARM EFI stub

Changes from V1:
* Fix loop limit when processing UTF-16 EFI command line
* Break out from series: [PATCH V5 00/18] ARM EFI stub common code
* Now includes caller fixup in ARM EFI stub.

H. Peter Anvin (1):
  Improve EFI stub command line conversion

 arch/arm/boot/compressed/efi-stub.c    |    2 +-
 arch/x86/boot/compressed/eboot.c       |    3 +-
 drivers/firmware/efi/efi-stub-helper.c |   93 ++++++++++++++++++++++++--------
 3 files changed, 72 insertions(+), 26 deletions(-)

-- 
1.7.10.4
