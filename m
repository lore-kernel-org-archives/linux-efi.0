From: Geliang Tang <geliangtang@gmail.com>
Subject: [PATCH] pstore: set ecc_notice_size to zero
Date: Thu,  2 Jun 2016 13:17:03 +0800
Message-ID: <ca5ede6ead67d9f805748394c37f06e174543bd3.1464844327.git.geliangtang@gmail.com>
Return-path: <linux-acpi-owner@vger.kernel.org>
Sender: linux-acpi-owner@vger.kernel.org
To: Anton Vorontsov <anton@enomsg.org>, Colin Cross <ccross@android.com>, Kees Cook <keescook@chromium.org>, Tony Luck <tony.luck@intel.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>
Cc: Geliang Tang <geliangtang@gmail.com>, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

Since a @ecc_notice_size parameter has been added in pstore_info.read(),
this patch sets this parameter to zero in efi_pstore_read() and
erst_reader().

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
---
 drivers/acpi/apei/erst.c          | 1 +
 drivers/firmware/efi/efi-pstore.c | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/drivers/acpi/apei/erst.c b/drivers/acpi/apei/erst.c
index 3024edf..f096ab3 100644
--- a/drivers/acpi/apei/erst.c
+++ b/drivers/acpi/apei/erst.c
@@ -1035,6 +1035,7 @@ skip:
 	memcpy(*buf, rcd->data, len - sizeof(*rcd));
 	*id = record_id;
 	*compressed = false;
+	*ecc_notice_size = 0;
 	if (uuid_le_cmp(rcd->sec_hdr.section_type,
 			CPER_SECTION_TYPE_DMESG_Z) == 0) {
 		*type = PSTORE_TYPE_DMESG;
diff --git a/drivers/firmware/efi/efi-pstore.c b/drivers/firmware/efi/efi-pstore.c
index cd8c35f..d5903ea 100644
--- a/drivers/firmware/efi/efi-pstore.c
+++ b/drivers/firmware/efi/efi-pstore.c
@@ -34,6 +34,7 @@ struct pstore_read_data {
 	int *count;
 	struct timespec *timespec;
 	bool *compressed;
+	ssize_t *ecc_notice_size;
 	char **buf;
 };
 
@@ -69,6 +70,7 @@ static int efi_pstore_read_func(struct efivar_entry *entry, void *data)
 			*cb_data->compressed = true;
 		else
 			*cb_data->compressed = false;
+		*cb_data->ecc_notice_size = 0;
 	} else if (sscanf(name, "dump-type%u-%u-%d-%lu",
 		   cb_data->type, &part, &cnt, &time) == 4) {
 		*cb_data->id = generic_id(time, part, cnt);
@@ -76,6 +78,7 @@ static int efi_pstore_read_func(struct efivar_entry *entry, void *data)
 		cb_data->timespec->tv_sec = time;
 		cb_data->timespec->tv_nsec = 0;
 		*cb_data->compressed = false;
+		*cb_data->ecc_notice_size = 0;
 	} else if (sscanf(name, "dump-type%u-%u-%lu",
 			  cb_data->type, &part, &time) == 3) {
 		/*
@@ -88,6 +91,7 @@ static int efi_pstore_read_func(struct efivar_entry *entry, void *data)
 		cb_data->timespec->tv_sec = time;
 		cb_data->timespec->tv_nsec = 0;
 		*cb_data->compressed = false;
+		*cb_data->ecc_notice_size = 0;
 	} else
 		return 0;
 
@@ -221,6 +225,7 @@ static ssize_t efi_pstore_read(u64 *id, enum pstore_type_id *type,
 	data.count = count;
 	data.timespec = timespec;
 	data.compressed = compressed;
+	data.ecc_notice_size = ecc_notice_size;
 	data.buf = buf;
 
 	*data.buf = kzalloc(EFIVARS_DATA_SIZE_MAX, GFP_KERNEL);
-- 
1.9.1

