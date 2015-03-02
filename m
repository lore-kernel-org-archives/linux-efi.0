From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [GIT PULL] EFI urgent fixes
Date: Mon, 2 Mar 2015 12:51:04 +0000
Message-ID: <20150302125104.GC24476@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>, Yinghai Lu <yinghai@kernel.org>, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

Folks, please pull the following urgent changes.

The following changes since commit 43a9f69692b232d1c64c913a27507eb14a1c47fd:

  Revert "efi/libstub: Call get_memory_map() to obtain map and desc sizes" (2015-02-18 11:38:13 +0000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-urgent

for you to fetch changes up to 6d9ff473317245e3e5cd9922b4520411c2296388:

  firmware: dmi_scan: Fix dmi_len type (2015-02-24 18:54:17 +0000)

----------------------------------------------------------------
 * Fix regression in DMI sysfs code for handling "End of Table" entry
   and a type bug that could lead to integer overflow - Ivan Khoronzhuk

 * Fix boundary checking in efi_high_alloc() which can lead to memory
   corruption in the EFI boot stubs - Yinghai Lu

----------------------------------------------------------------
Ivan Khoronzhuk (2):
      firmware: dmi_scan: Fix dmi scan to handle "End of Table" structure
      firmware: dmi_scan: Fix dmi_len type

Yinghai Lu (1):
      efi/libstub: Fix boundary checking in efi_high_alloc()

 drivers/firmware/dmi_scan.c                    | 17 +++++++++--------
 drivers/firmware/efi/libstub/efi-stub-helper.c |  8 ++++----
 2 files changed, 13 insertions(+), 12 deletions(-)

-- 
Matt Fleming, Intel Open Source Technology Center
