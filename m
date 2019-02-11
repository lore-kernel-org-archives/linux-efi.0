From: bsz@semihalf.com
Subject: [PATCH 0/5] Add support for TPM event log 2.0 on EFI/ARM
Date: Mon, 11 Feb 2019 15:30:47 +0100
Message-ID: <20190211143052.3128-1-bsz@semihalf.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org, peterhuewe@gmx.de, jarkko.sakkinen@linux.intel.com, ard.biesheuvel@linaro.org
Cc: tweek@google.com, mingo@kernel.org, hdegoede@redhat.com, leif.lindholm@linaro.org, mw@semihalf.com, Bartosz Szczepanek <bsz@semihalf.com>
List-Id: linux-efi@vger.kernel.org

From: Bartosz Szczepanek <bsz@semihalf.com>

These few patches introduce support for retrieving TPM event log in 2.0
format from EFI structures. Since 2.0 format involves dynamically-sized
records, some more computation is needed. Function responsible for this
has already been in kernel (calc_tpm2_event_size) - it was moved to
library, so it can be used from both EFI stub and device drivers.
Signature is slightly altered, as explained in one of the commits.

EFI stub was enhanced to call EFI GetEventLog function asking for 2.0
event log. If found, it's installed in configuration table similarily
to TPM 1.2 log. In case 2.0 log is not available, it falls back to 1.2
log.

Call to efi_retrieve_tpm2_eventlog() is added at ARM efi_entry to enable
TPM functionality on ARM / ARM64 platforms.

It was tested on two platforms - ARM64 and x86_64, both EFI-based and
equipped with TPM 2.0 module.

Bartosz Szczepanek (5):
  tpm: Copy calc_tpm2_event_size() to TPM library
  tpm: Change calc_tpm2_event_size signature
  tpm: Use library version of calc_tpm2_event_size in sysfs code
  efi/libstub/tpm: Retrieve TPM event log in 2.0 format
  efi/arm: Retrieve TPM event log at efi_entry

 drivers/char/tpm/eventlog/tpm2.c        |  89 +++++---------------------
 drivers/firmware/efi/libstub/Makefile   |   3 +-
 drivers/firmware/efi/libstub/arm-stub.c |   1 +
 drivers/firmware/efi/libstub/tpm.c      | 107 +++++++++++++++++++++++++++++++-
 include/linux/tpm_eventlog.h            |   3 +
 lib/Makefile                            |   2 +
 lib/tpm.c                               |  78 +++++++++++++++++++++++
 7 files changed, 208 insertions(+), 75 deletions(-)
 create mode 100644 lib/tpm.c

-- 
2.14.4
