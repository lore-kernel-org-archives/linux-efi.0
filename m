From: Dave Young <dyoung@redhat.com>
Subject: [PATCH 0/4] efi/x86: move efi bgrt init code to early init
Date: Thu, 12 Jan 2017 17:41:18 +0800
Message-ID: <20170112094118.815108042@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, dyoung@redhat.com, x86@kernel.org, Nicolai Stange <nicstange@gmail.com>, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, hpa@zytor.com, Dan Williams <dan.j.williams@intel.com>, mika.penttila@nextfour.com, bhsharma@redhat.com
List-Id: linux-efi@vger.kernel.org

Hi,

Here is a patchset to move efi_bgrt_init to early code so that we can still use memblock api.

Appreciated for comments and review.

Diffstat:

 arch/x86/kernel/acpi/boot.c      |   12 +++++++++++
 arch/x86/platform/efi/efi-bgrt.c |   42
+++++++++++++--------------------------
 arch/x86/platform/efi/efi.c      |   26 ++++--------------------
 arch/x86/platform/efi/quirks.c   |    2 -
 drivers/acpi/bgrt.c              |   21 +++++++++++++------
 drivers/firmware/efi/fake_mem.c  |    3 +-
 drivers/firmware/efi/memmap.c    |   24 +++++++++++++++++++++-
 include/linux/efi-bgrt.h         |    7 ++----
 include/linux/efi.h              |    4 +--
 init/main.c                      |    1 
 10 files changed, 78 insertions(+), 64 deletions(-)

Thanks
Dave
