From: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Subject: [PATCH] efi: Free existing memory map before installing new memory map
Date: Mon, 25 Jun 2018 19:41:32 -0700
Message-ID: <1529980892-11833-1-git-send-email-sai.praneeth.prakhya@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Sai Praneeth <sai.praneeth.prakhya@intel.com>, Lee Chun-Yi <jlee@suse.com>, Borislav Petkov <bp@alien8.de>, Dave Young <dyoung@redhat.com>, Laszlo Ersek <lersek@redhat.com>, Bhupesh Sharma <bhsharma@redhat.com>, Ricardo Neri <ricardo.neri@intel.com>, Ravi Shankar <ravi.v.shankar@intel.com>, Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

From: Sai Praneeth <sai.praneeth.prakhya@intel.com>

efi_memmap_install(), unmaps the existing memory map and installs the
new memory map but doesn't free the memory allocated to the existing
memory map. Fortunately, the details about the existing memory map are
stored in efi.memmap. Hence, use them to free the memory.

Signed-off-by: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Reported-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Lee Chun-Yi <jlee@suse.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Young <dyoung@redhat.com>
Cc: Laszlo Ersek <lersek@redhat.com>
Cc: Bhupesh Sharma <bhsharma@redhat.com>
Cc: Ricardo Neri <ricardo.neri@intel.com>
Cc: Ravi Shankar <ravi.v.shankar@intel.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---

Note: Patch based on efi tree @https://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git

 drivers/firmware/efi/memmap.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/firmware/efi/memmap.c b/drivers/firmware/efi/memmap.c
index 678e85704054..68b27b14fe94 100644
--- a/drivers/firmware/efi/memmap.c
+++ b/drivers/firmware/efi/memmap.c
@@ -229,6 +229,9 @@ int __init efi_memmap_install(phys_addr_t addr, unsigned int nr_map)
 
 	efi_memmap_unmap();
 
+	/* Free the memory allocated to the existing memory map */
+	efi_memmap_free(efi.memmap.phys_map, efi.memmap.nr_map, efi.memmap.late);
+
 	data.phys_map = addr;
 	data.size = efi.memmap.desc_size * nr_map;
 	data.desc_version = efi.memmap.desc_version;
-- 
2.7.4
