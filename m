From: Dave Young <dyoung@redhat.com>
Subject: [PATCH V2 0/4] efi/x86: move efi bgrt init code to early init
Date: Mon, 16 Jan 2017 10:45:54 +0800
Message-ID: <20170116024554.461236678@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, dyoung@redhat.com, x86@kernel.org, Nicolai Stange <nicstange@gmail.com>, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, hpa@zytor.com, Dan Williams <dan.j.williams@intel.com>, mika.penttila@nextfour.com, bhsharma@redhat.com
List-Id: linux-efi@vger.kernel.org

Hi,

Here the the update of the series for moving bgrt init code to early init.

Main changes is:
- Move the 1st patch to the last because it does not block the 2nd patch
any more with Peter's patch to prune invlid memmap entries:
https://git.kernel.org/cgit/linux/kernel/git/efi/efi.git/commit/?h=next&id=b2a91
a35445229
But it is still tood to have since efi_mem_reserve only cares about boot related
mem ranges.

- Other comments about code itself, details please the the patches themselves.

 arch/x86/include/asm/efi.h       |    1 
 arch/x86/kernel/acpi/boot.c      |   12 +++++++
 arch/x86/platform/efi/efi-bgrt.c |   59 ++++++++++++++++-----------------------
 arch/x86/platform/efi/efi.c      |   26 +++--------------
 arch/x86/platform/efi/quirks.c   |    2 -
 drivers/acpi/bgrt.c              |   28 +++++++++++++-----
 drivers/firmware/efi/fake_mem.c  |    3 +
 drivers/firmware/efi/memmap.c    |   22 +++++++++++++-
 include/linux/efi-bgrt.h         |    7 +---
 include/linux/efi.h              |    5 +--
 init/main.c                      |    1 
 11 files changed, 92 insertions(+), 74 deletions(-)

Thanks
Dave
