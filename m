From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 8/8] ACPI: Use recently introduced uuid_le_cmp_p{p}()
 helpers
Date: Fri, 21 Apr 2017 17:46:45 +0300
Message-ID: <20170421144645.45189-8-andriy.shevchenko@linux.intel.com>
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
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>
List-Id: linux-efi@vger.kernel.org

Recently introduced helpers take pointers to uuid_{be|le} instead of
reference.

Using them makes code less ugly.

Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/acpi/acpi_extlog.c | 2 +-
 drivers/acpi/apei/ghes.c   | 8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/acpi/acpi_extlog.c b/drivers/acpi/acpi_extlog.c
index 502ea4dc2080..45e299aefda7 100644
--- a/drivers/acpi/acpi_extlog.c
+++ b/drivers/acpi/acpi_extlog.c
@@ -169,7 +169,7 @@ static int extlog_print(struct notifier_block *nb, unsigned long val,
 	if (gdata->validation_bits & CPER_SEC_VALID_FRU_TEXT)
 		fru_text = gdata->fru_text;
 	sec_type = (uuid_le *)gdata->section_type;
-	if (!uuid_le_cmp(*sec_type, CPER_SEC_PLATFORM_MEM)) {
+	if (!uuid_le_cmp_p(sec_type, CPER_SEC_PLATFORM_MEM)) {
 		struct cper_sec_mem_err *mem = (void *)(gdata + 1);
 		if (gdata->error_data_length >= sizeof(*mem))
 			trace_extlog_mem_event(mem, err_seq, fru_id, fru_text,
diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index d0855c09f32f..f2a7ee26d45f 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -431,12 +431,13 @@ static void ghes_do_proc(struct ghes *ghes,
 {
 	int sev, sec_sev;
 	struct acpi_hest_generic_data *gdata;
+	uuid_le *sec_type;
 
 	sev = ghes_severity(estatus->error_severity);
 	apei_estatus_for_each_section(estatus, gdata) {
+		sec_type = (uuid_le *)gdata->section_type;
 		sec_sev = ghes_severity(gdata->error_severity);
-		if (!uuid_le_cmp(*(uuid_le *)gdata->section_type,
-				 CPER_SEC_PLATFORM_MEM)) {
+		if (!uuid_le_cmp_p(sec_type, CPER_SEC_PLATFORM_MEM)) {
 			struct cper_sec_mem_err *mem_err;
 			mem_err = (struct cper_sec_mem_err *)(gdata+1);
 			ghes_edac_report_mem_error(ghes, sev, mem_err);
@@ -445,8 +446,7 @@ static void ghes_do_proc(struct ghes *ghes,
 			ghes_handle_memory_failure(gdata, sev);
 		}
 #ifdef CONFIG_ACPI_APEI_PCIEAER
-		else if (!uuid_le_cmp(*(uuid_le *)gdata->section_type,
-				      CPER_SEC_PCIE)) {
+		else if (!uuid_le_cmp_p(sec_type, CPER_SEC_PCIE)) {
 			struct cper_sec_pcie *pcie_err;
 			pcie_err = (struct cper_sec_pcie *)(gdata+1);
 			if (sev == GHES_SEV_RECOVERABLE &&
-- 
2.11.0
