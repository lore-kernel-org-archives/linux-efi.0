From: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/3] efi: add firmware version information to sysfs
Date: Tue,  6 Sep 2016 11:51:10 -0400
Message-ID: <1473177071-11791-2-git-send-email-pjones@redhat.com>
References: <20160905120006.GA27048@wunner.de>
 <1473177071-11791-1-git-send-email-pjones@redhat.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1473177071-11791-1-git-send-email-pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

This adds the EFI Spec version from the system table to sysfs as
/sys/firmware/efi/spec_version .

Userland tools need this information in order to work around
specification deficiencies in 2.4 and earlier firmwares.  Specifically,
UEFI 2.4 and 2.5+ treat management of BootOrder very differently (See
UEFI 2.4 section 3.1.1 vs UEFI 2.5 section 3.1), which means on older
firmware we'll want to work around BDS's boot order management by adding
fwupdate entries to BootOrder.  We'd prefer not to do this on newer
firmware, as it is both non-sensical in terms of what it expresses, and
it results in more relatively failure prone flash writes.

Signed-off-by: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 Documentation/ABI/testing/sysfs-firmware-efi |  6 +++
 drivers/firmware/efi/efi.c                   | 66 ++++++++++++++++++++++++++++
 2 files changed, 72 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-firmware-efi b/Documentation/ABI/testing/sysfs-firmware-efi
index e794eac..4eec7c2 100644
--- a/Documentation/ABI/testing/sysfs-firmware-efi
+++ b/Documentation/ABI/testing/sysfs-firmware-efi
@@ -28,3 +28,9 @@ Description:	Displays the physical addresses of all EFI Configuration
 		versions are always printed first, i.e. ACPI20 comes
 		before ACPI.
 Users:		dmidecode
+
+What:		/sys/firmware/efi/spec_version
+Date:		August 2016
+Contact:	linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
+Description:	Displays the UEFI Specification revision the firmware claims to
+		be based upon.
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 5a2631a..c7cdd3f 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -141,11 +141,76 @@ static ssize_t fw_platform_size_show(struct kobject *kobj,
 	return sprintf(buf, "%d\n", efi_enabled(EFI_64BIT) ? 64 : 32);
 }
 
+static ssize_t spec_version_show(struct kobject *kobj,
+				 struct kobj_attribute *attr,
+				 char *buf)
+{
+	u16 major, minor;
+	ssize_t rc;
+
+	if (!buf)
+		return -EINVAL;
+
+	/* The spec says:
+	 *  The revision of the EFI Specification to which this table
+	 *  conforms. The upper 16 bits of this field contain the major
+	 *  revision value, and the lower 16 bits contain the minor revision
+	 *  value. The minor revision values are binary coded decimals and are
+	 *  limited to the range of 00..99.
+	 *
+	 *  When printed or displayed UEFI spec revision is referred as (Major
+	 *  revision).(Minor revision upper decimal).(Minor revision lower
+	 *  decimal) or (Major revision).(Minor revision upper decimal) in
+	 *  case Minor revision lower decimal is set to 0. For example:
+	 *
+	 *  A specification with the revision value ((2<<16) | (30)) would be
+	 *  referred as 2.3;
+	 *  A specification with the revision value ((2<<16) | (31)) would be
+	 *  referred as 2.3.1
+	 *
+	 * Then later it says:
+	 *  Related Definitions
+	 *   #define EFI_SYSTEM_TABLE_SIGNATURE 0x5453595320494249
+	 *   #define EFI_2_40_SYSTEM_TABLE_REVISION ((2<<16) | (40))
+	 *   #define EFI_2_31_SYSTEM_TABLE_REVISION ((2<<16) | (31))
+	 *   #define EFI_2_30_SYSTEM_TABLE_REVISION ((2<<16) | (30))
+	 *   #define EFI_2_20_SYSTEM_TABLE_REVISION ((2<<16) | (20))
+	 *   #define EFI_2_10_SYSTEM_TABLE_REVISION ((2<<16) | (10))
+	 *   #define EFI_2_00_SYSTEM_TABLE_REVISION ((2<<16) | (00))
+	 *   #define EFI_1_10_SYSTEM_TABLE_REVISION ((1<<16) | (10))
+	 *   #define EFI_1_02_SYSTEM_TABLE_REVISION ((1<<16) | (02))
+	 *   #define EFI_SPECIFICATION_VERSION EFI_SYSTEM_TABLE_REVISION
+	 *   #define EFI_SYSTEM_TABLE_REVISION EFI_2_40_SYSTEM_TABLE_REVISION
+	 *
+	 * (Apparently this bit of the spec failed to get updated for 2.5
+	 * and 2.6; UefiSpec.h in Tiano has been updated, though.)
+	 *
+	 * This of course does not match the description above at all, but it
+	 * does match the code in Tiano.  So we decode it Tiano's way.
+	 */
+	major = (efi.spec_version & 0xffff0000) >> 16;
+	minor = (efi.spec_version & 0x0000ffff);
+
+	if ((minor % 10) == 0)
+		rc = sprintf(buf, "%u.%u", major, minor / 10);
+	else
+		rc = sprintf(buf, "%u.%u.%u", major, minor / 10, minor % 10);
+
+	if (rc < 0) {
+		char *str;
+
+		str = strcpy(buf, "(unknown)");
+		return str - buf;
+	}
+	return rc;
+}
+
 static struct kobj_attribute efi_attr_fw_vendor = __ATTR_RO(fw_vendor);
 static struct kobj_attribute efi_attr_runtime = __ATTR_RO(runtime);
 static struct kobj_attribute efi_attr_config_table = __ATTR_RO(config_table);
 static struct kobj_attribute efi_attr_fw_platform_size =
 	__ATTR_RO(fw_platform_size);
+static struct kobj_attribute efi_attr_spec_version = __ATTR_RO(spec_version);
 
 static struct attribute *efi_subsys_attrs[] = {
 	&efi_attr_systab.attr,
@@ -153,6 +218,7 @@ static struct attribute *efi_subsys_attrs[] = {
 	&efi_attr_runtime.attr,
 	&efi_attr_config_table.attr,
 	&efi_attr_fw_platform_size.attr,
+	&efi_attr_spec_version.attr,
 	NULL,
 };
 
-- 
2.7.4
