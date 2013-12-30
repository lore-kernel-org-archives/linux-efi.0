From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v4 4/4 update] Passing efi related data via setup_data
Date: Mon, 30 Dec 2013 15:16:56 +0800
Message-ID: <20131230071656.GB3827@dhcp-16-126.nay.redhat.com>
References: <1387533947-18210-1-git-send-email-dyoung@redhat.com>
 <1387533947-18210-5-git-send-email-dyoung@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1387533947-18210-5-git-send-email-dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, toshi.kani-VXdhtT5mjnY@public.gmane.org, matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org, greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, horms-/R6kz+dDXgpPR4JQBCEnsQ@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org


For supporting efi runtime, several efi physical addresses
fw_vendor, runtime, config tables, smbios and the whole runtime
mapping info need to be used in kexec kernel. Thus introduce
setup_data struct for passing these data.

collect the varialbes from /sys/firmware/efi/systab and
/sys/firmware/efi/runtime-map

Tested on qemu+ovmf, dell laptop, lenovo laptop and HP workstation.

v1->v2:
HPA: use uint*_t instead of __uint*_t
Simon: indention fix; fix a memory leak
move offset change update to previous patch in setup header
only passing setup_data when the bzImage support efi boot
Vivek: export a value in bzImage probe so it can be used
      to check if we should pass acpi_rsdp.
coding style

v2->v3:
code cleanup
bail out if efi mm desc_version != 1
bhe: define macro for SETUP_EFI
     break loop if find matched string in systab.

v3->v4:
update memmap in efi_info to the saved runtime map
So kernel side can iterate them as normal boot.

v4->v5:
simplify function get_efi_value(), add error handling
realloc error handling
move map[0] out of efi_setup_data since memmap addr is set in efi_info

Signed-off-by: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 kexec/arch/i386/x86-linux-setup.c | 218 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 215 insertions(+), 3 deletions(-)

diff --git a/kexec/arch/i386/x86-linux-setup.c b/kexec/arch/i386/x86-linux-setup.c
index 38bd9dd..5884f4d 100644
--- a/kexec/arch/i386/x86-linux-setup.c
+++ b/kexec/arch/i386/x86-linux-setup.c
@@ -36,6 +36,8 @@
 #include "x86-linux-setup.h"
 #include "../../kexec/kexec-syscall.h"
 
+#define SETUP_EFI	4
+
 void init_linux_parameters(struct x86_linux_param_header *real_mode)
 {
 	/* Fill in the values that are usually provided by the kernel. */
@@ -480,11 +482,221 @@ void setup_subarch(struct x86_linux_param_header *real_mode)
 	get_bootparam(&real_mode->hardware_subarch, offset, sizeof(uint32_t));
 }
 
-static void setup_efi_info(struct x86_linux_param_header *real_mode)
+struct efi_mem_descriptor {
+	uint32_t type;
+	uint32_t pad;
+	uint64_t phys_addr;
+	uint64_t virt_addr;
+	uint64_t num_pages;
+	uint64_t attribute;
+};
+
+struct efi_setup_data {
+	uint64_t fw_vendor;
+	uint64_t runtime;
+	uint64_t tables;
+	uint64_t smbios;
+	uint64_t reserved[8];
+};
+
+struct setup_data {
+	uint64_t next;
+	uint32_t type;
+	uint32_t len;
+	uint8_t data[0];
+} __attribute__((packed));
+
+static int get_efi_value(const char *filename,
+			const char *pattern, uint64_t *val)
+{
+	FILE *fp;
+	char line[1024], *s, *end;
+
+	fp = fopen(filename, "r");
+	if (!fp)
+		return 1;
+
+	while (fgets(line, sizeof(line), fp) != 0) {
+		s = strstr(line, pattern);
+		if (!s)
+			continue;
+		*val = strtoull(s + strlen(pattern), &end, 16);
+		if (*val == ULLONG_MAX) {
+			fclose(fp);
+			return 2;
+		}
+		break;
+	}
+
+	fclose(fp);
+	return 0;
+}
+
+static int get_efi_values(struct efi_setup_data *esd)
+{
+	int ret = 0;
+
+	ret = get_efi_value("/sys/firmware/efi/systab", "SMBIOS=0x",
+			    &esd->smbios);
+	ret |= get_efi_value("/sys/firmware/efi/fw_vendor", "0x",
+			     &esd->fw_vendor);
+	ret |= get_efi_value("/sys/firmware/efi/runtime", "0x",
+			     &esd->runtime);
+	ret |= get_efi_value("/sys/firmware/efi/config_table", "0x",
+			     &esd->tables);
+	return ret;
+}
+
+static int get_efi_runtime_map(struct efi_mem_descriptor **map)
+{
+	DIR *dirp;
+	struct dirent *entry;
+	char filename[1024];
+	struct efi_mem_descriptor md, *p = NULL;
+	int nr_maps = 0;
+
+	dirp = opendir("/sys/firmware/efi/runtime-map");
+	if (!dirp)
+		return 0;
+	while ((entry = readdir(dirp)) != NULL) {
+		sprintf(filename,
+			"/sys/firmware/efi/runtime-map/%s",
+			(char *)entry->d_name);
+		if (*entry->d_name == '.')
+			continue;
+		file_scanf(filename, "type", "0x%x", (unsigned int *)&md.type);
+		file_scanf(filename, "phys_addr", "0x%llx",
+			   (unsigned long long *)&md.phys_addr);
+		file_scanf(filename, "virt_addr", "0x%llx",
+			   (unsigned long long *)&md.virt_addr);
+		file_scanf(filename, "num_pages", "0x%llx",
+			   (unsigned long long *)&md.num_pages);
+		file_scanf(filename, "attribute", "0x%llx",
+			   (unsigned long long *)&md.attribute);
+		p = realloc(p, (nr_maps + 1) * sizeof(md));
+		if (!p)
+			goto err_out;
+
+		*(p + nr_maps) = md;
+		*map = p;
+		nr_maps++;
+	}
+
+	closedir(dirp);
+	return nr_maps;
+err_out:
+	if (map)
+		free(map);
+	closedir(dirp);
+	return 0;
+}
+
+struct efi_info {
+	uint32_t efi_loader_signature;
+	uint32_t efi_systab;
+	uint32_t efi_memdesc_size;
+	uint32_t efi_memdesc_version;
+	uint32_t efi_memmap;
+	uint32_t efi_memmap_size;
+	uint32_t efi_systab_hi;
+	uint32_t efi_memmap_hi;
+};
+
+/*
+ * setup_efi_data will collect below data and pass them to 2nd kernel.
+ * 1) SMBIOS, fw_vendor, runtime, config_table, they are passed via x86
+ *    setup_data.
+ * 2) runtime memory regions, set the memmap related fields in efi_info.
+ */
+static int setup_efi_data(struct kexec_info *info,
+			  struct x86_linux_param_header *real_mode)
+{
+	int64_t setup_data_paddr, memmap_paddr;
+	struct setup_data *sd;
+	struct efi_setup_data *esd;
+	struct efi_mem_descriptor *maps;
+	int nr_maps, size, sdsize, ret = 0;
+	struct efi_info *ei = (struct efi_info *)real_mode->efi_info;
+
+	ret = access("/sys/firmware/efi/systab", F_OK);
+	if (ret < 0)
+		goto out;
+
+	esd = malloc(sizeof(struct efi_setup_data));
+	if (!esd) {
+		ret = 1;
+		goto out;
+	}
+	memset(esd, 0, sizeof(struct efi_setup_data));
+	ret = get_efi_values(esd);
+	if (ret)
+		goto free_esd;
+	nr_maps = get_efi_runtime_map(&maps);
+	if (!nr_maps) {
+		ret = 2;
+		goto free_esd;
+	}
+	sd = malloc(sizeof(struct setup_data) + sizeof(*esd));
+	if (!sd) {
+		ret = 3;
+		goto free_maps;
+	}
+
+	memset(sd, 0, sizeof(struct setup_data) + sizeof(*esd));
+	sd->next = 0;
+	sd->type = SETUP_EFI;
+	sd->len = sizeof(*esd);
+	memcpy(sd->data, esd, sizeof(*esd));
+	free(esd);
+	sdsize = sd->len + sizeof(struct setup_data);
+	setup_data_paddr = add_buffer(info, sd, sdsize, sdsize, getpagesize(),
+					0x100000, ULONG_MAX, INT_MAX);
+	real_mode->setup_data = setup_data_paddr;
+
+	size = nr_maps * sizeof(struct efi_mem_descriptor);
+	memmap_paddr = add_buffer(info, maps, size, size, getpagesize(),
+					0x100000, ULONG_MAX, INT_MAX);
+	ei->efi_memmap = memmap_paddr;
+	ei->efi_memmap_size = size;
+	ei->efi_memdesc_size = sizeof(struct efi_mem_descriptor);
+
+	return 0;
+free_maps:
+	free(maps);
+free_esd:
+	free(esd);
+out:
+	return ret;
+}
+
+static int
+get_efi_mem_desc_version(struct x86_linux_param_header *real_mode)
+{
+	struct efi_info *ei = (struct efi_info *)real_mode->efi_info;
+
+	return ei->efi_memdesc_version;
+}
+
+static void setup_efi_info(struct kexec_info *info,
+			   struct x86_linux_param_header *real_mode)
 {
+	int ret, desc_version;
 	off_t offset = offsetof(typeof(*real_mode), efi_info);
 
-	get_bootparam(&real_mode->efi_info, offset, 32);
+	ret = get_bootparam(&real_mode->efi_info, offset, 32);
+	if (ret)
+		return;
+	desc_version = get_efi_mem_desc_version(real_mode);
+	if (desc_version != 1) {
+		fprintf(stderr,
+			"efi memory descriptor version %d is not supported!\n",
+			desc_version);
+		memset(&real_mode->efi_info, 0, 32);
+		return;
+	}
+	ret = setup_efi_data(info, real_mode);
+	if (ret)
+		memset(&real_mode->efi_info, 0, 32);
 }
 
 void setup_linux_system_parameters(struct kexec_info *info,
@@ -497,7 +709,7 @@ void setup_linux_system_parameters(struct kexec_info *info,
 	/* get subarch from running kernel */
 	setup_subarch(real_mode);
 	if (bzImage_support_efi_boot)
-		setup_efi_info(real_mode);
+		setup_efi_info(info, real_mode);
 	
 	/* Default screen size */
 	real_mode->orig_x = 0;
-- 
1.8.3.1
