From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 7/8] efi: Use recently introduced uuid_le_cmp_p{p}() helpers
Date: Fri, 21 Apr 2017 17:46:44 +0300
Message-ID: <20170421144645.45189-7-andriy.shevchenko@linux.intel.com>
References: <20170421144645.45189-1-andriy.shevchenko@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20170421144645.45189-1-andriy.shevchenko@linux.intel.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Mika Westerberg <mika.westerberg@linux.intel.com>, alsa-devel@alsa-project.org, linux-input@vger.kernel.org, kvm@vger.kernel.org, devel@linuxdriverproject.org, linux-efi@vger.kernel.org, linux-acpi@vger.kernel.org
Cc: Matt Fleming <matt@codeblueprint.co.uk>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

Recently introduced helpers take pointers to uuid_{be|le} instead of
reference.

Using them makes code less ugly.

Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/firmware/efi/cper.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/firmware/efi/cper.c b/drivers/firmware/efi/cper.c
index d42537425438..7735b0f0ea90 100644
--- a/drivers/firmware/efi/cper.c
+++ b/drivers/firmware/efi/cper.c
@@ -402,14 +402,14 @@ static void cper_estatus_print_section(
 		printk("%s""fru_text: %.20s\n", pfx, gdata->fru_text);
 
 	snprintf(newpfx, sizeof(newpfx), "%s%s", pfx, INDENT_SP);
-	if (!uuid_le_cmp(*sec_type, CPER_SEC_PROC_GENERIC)) {
+	if (!uuid_le_cmp_p(sec_type, CPER_SEC_PROC_GENERIC)) {
 		struct cper_sec_proc_generic *proc_err = (void *)(gdata + 1);
 		printk("%s""section_type: general processor error\n", newpfx);
 		if (gdata->error_data_length >= sizeof(*proc_err))
 			cper_print_proc_generic(newpfx, proc_err);
 		else
 			goto err_section_too_small;
-	} else if (!uuid_le_cmp(*sec_type, CPER_SEC_PLATFORM_MEM)) {
+	} else if (!uuid_le_cmp_p(sec_type, CPER_SEC_PLATFORM_MEM)) {
 		struct cper_sec_mem_err *mem_err = (void *)(gdata + 1);
 		printk("%s""section_type: memory error\n", newpfx);
 		if (gdata->error_data_length >=
@@ -418,7 +418,7 @@ static void cper_estatus_print_section(
 				       gdata->error_data_length);
 		else
 			goto err_section_too_small;
-	} else if (!uuid_le_cmp(*sec_type, CPER_SEC_PCIE)) {
+	} else if (!uuid_le_cmp_p(sec_type, CPER_SEC_PCIE)) {
 		struct cper_sec_pcie *pcie = (void *)(gdata + 1);
 		printk("%s""section_type: PCIe error\n", newpfx);
 		if (gdata->error_data_length >= sizeof(*pcie))
-- 
2.11.0
