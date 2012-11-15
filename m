From: Matt Fleming <matt@console-pimps.org>
Subject: [GIT PULL] EFI changes for v3.8 - part 2
Date: Thu, 15 Nov 2012 21:20:52 +0000
Message-ID: <1353014452.2977.73.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

Hi guys,

The following changes since commit 5d6d578c170bb280db5d4779f666e456f4f82ec5:

  x86, efi: Check table header length in efi_bgrt_init() (2012-11-14 08:49:34 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-for-3.8-v2

for you to fetch changes up to e83af1f18c78c7b6aa720beecc927ecc8afd3647:

  efivarfs: Make efivarfs_fill_super() static (2012-11-15 20:08:13 +0000)

----------------------------------------------------------------
EFI updates for v3.8 - part 2

Just one small commit that fixes a sparse warning.

----------------------------------------------------------------
Matt Fleming (1):
      efivarfs: Make efivarfs_fill_super() static

 drivers/firmware/efivars.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
Matt Fleming, Intel Open Source Technology Center
