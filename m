From: kbuild test robot <lkp@intel.com>
Subject: [RFC PATCH] efi: debugfs_blob[] can be static
Date: Sun, 1 Apr 2018 08:12:05 +0800
Message-ID: <20180401001205.GA24604@lkp-wsm-ep2>
References: <20180331121944.8618-1-hdegoede@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180331121944.8618-1-hdegoede@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
Cc: kbuild-all@01.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, "Luis R . Rodriguez" <mcgrof@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Hans de Goede <hdegoede@redhat.com>, linux-kernel@vger.kernel.org, Peter Jones <pjones@redhat.com>, Dave Olsthoorn <dave@bewaar.me>, x86@kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org


Fixes: ac46fdb7891f ("efi: Export boot-services code and data as debugfs-blobs")
Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 efi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index fddc5f7..9f1b8e6 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -321,7 +321,7 @@ static inline int efivar_ssdt_load(void) { return 0; }
 
 #define EFI_DEBUGFS_MAX_BLOBS 32
 
-struct debugfs_blob_wrapper debugfs_blob[EFI_DEBUGFS_MAX_BLOBS];
+static struct debugfs_blob_wrapper debugfs_blob[EFI_DEBUGFS_MAX_BLOBS];
 
 static void __init efi_debugfs_init(void)
 {
