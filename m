From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 075/192] efi: cper: Fix possible out-of-bounds access
Date: Wed, 27 Mar 2019 14:08:27 -0400
Message-ID: <20190327181025.13507-75-sashal@kernel.org>
References: <20190327181025.13507-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190327181025.13507-1-sashal@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Ross Lagerwall <ross.lagerwall@citrix.com>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Sasha Levin <sashal@kernel.org>, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

From: Ross Lagerwall <ross.lagerwall@citrix.com>

[ Upstream commit 45b14a4ffcc1e0b5caa246638f942cbe7eaea7ad ]

When checking a generic status block, we iterate over all the generic
data blocks. The loop condition only checks that the start of the
generic data block is valid (within estatus->data_length) but not the
whole block. Because the size of data blocks (excluding error data) may
vary depending on the revision and the revision is contained within the
data block, ensure that enough of the current data block is valid before
dereferencing any members otherwise an out-of-bounds access may occur if
estatus->data_length is invalid.

This relies on the fact that struct acpi_hest_generic_data_v300 is a
superset of the earlier version.  Also rework the other checks to avoid
potential underflow.

Signed-off-by: Ross Lagerwall <ross.lagerwall@citrix.com>
Acked-by: Borislav Petkov <bp@suse.de>
Tested-by: Tyler Baicar <baicar.tyler@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/cper.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/firmware/efi/cper.c b/drivers/firmware/efi/cper.c
index a7902fccdcfa..6090d25dce85 100644
--- a/drivers/firmware/efi/cper.c
+++ b/drivers/firmware/efi/cper.c
@@ -546,19 +546,24 @@ EXPORT_SYMBOL_GPL(cper_estatus_check_header);
 int cper_estatus_check(const struct acpi_hest_generic_status *estatus)
 {
 	struct acpi_hest_generic_data *gdata;
-	unsigned int data_len, gedata_len;
+	unsigned int data_len, record_size;
 	int rc;
 
 	rc = cper_estatus_check_header(estatus);
 	if (rc)
 		return rc;
+
 	data_len = estatus->data_length;
 
 	apei_estatus_for_each_section(estatus, gdata) {
-		gedata_len = acpi_hest_get_error_length(gdata);
-		if (gedata_len > data_len - acpi_hest_get_size(gdata))
+		if (sizeof(struct acpi_hest_generic_data) > data_len)
+			return -EINVAL;
+
+		record_size = acpi_hest_get_record_size(gdata);
+		if (record_size > data_len)
 			return -EINVAL;
-		data_len -= acpi_hest_get_record_size(gdata);
+
+		data_len -= record_size;
 	}
 	if (data_len)
 		return -EINVAL;
-- 
2.19.1
