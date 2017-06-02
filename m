From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 05/13] efi/capsule: Adjust return type of efi_capsule_setup_info
Date: Fri,  2 Jun 2017 13:51:59 +0000
Message-ID: <20170602135207.21708-6-ard.biesheuvel@linaro.org>
References: <20170602135207.21708-1-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170602135207.21708-1-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

From: Jan Kiszka <jan.kiszka@siemens.com>

We actually expect int at the caller and never return any size
information.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Reviewed-by: Matt Fleming <matt@codeblueprint.co.uk>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/firmware/efi/capsule-loader.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efi/capsule-loader.c b/drivers/firmware/efi/capsule-loader.c
index 3fb91e1597a9..37d3f6ec2d28 100644
--- a/drivers/firmware/efi/capsule-loader.c
+++ b/drivers/firmware/efi/capsule-loader.c
@@ -53,8 +53,8 @@ static void efi_free_all_buff_pages(struct capsule_info *cap_info)
  * @kbuff: a mapped first page buffer pointer
  * @hdr_bytes: the total received number of bytes for efi header
  **/
-static ssize_t efi_capsule_setup_info(struct capsule_info *cap_info,
-				      void *kbuff, size_t hdr_bytes)
+static int efi_capsule_setup_info(struct capsule_info *cap_info,
+				  void *kbuff, size_t hdr_bytes)
 {
 	efi_capsule_header_t *cap_hdr;
 	size_t pages_needed;
-- 
2.9.3
