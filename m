From: dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Subject: [patch 3/3 v2] Passing efi related data via setup_data
Date: Tue, 05 Nov 2013 16:29:50 +0800
Message-ID: <20131105083429.738992734@dhcp-16-126.nay.redhat.com>
References: <20131105082947.500512312@dhcp-16-126.nay.redhat.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline; filename=03-kexec-add-efi-setup-data.patch
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, horms-/R6kz+dDXgpPR4JQBCEnsQ@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

For supporting efi runtime, several efi physical addresses
fw_vendor, runtime, config tables, smbios and the whole runtime
mapping info need to be used in kexec kernel. Thus introduce
setup_data struct for passing these data.

collect the varialbes from /sys/firmware/efi/systab and
/sys/firmware/efi/efi-runtime-map

Tested on qemu+ovmf, dell laptop, lenovo laptop and HP workstation.

v1->v2:
HPA: use uint*_t instead of __uint*_t
Simon: indention fix; fix a memory leak
move offset change update to previous patch in setup header
only passing setup_data when the bzImage support efi boot
coding style

Signed-off-by: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 kexec/arch/i386/x86-linux-setup.c |  132 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 131 insertions(+), 1 deletion(-)

--- kexec-tools.orig/kexec/arch/i386/x86-linux-setup.c
+++ kexec-tools/kexec/arch/i386/x86-linux-setup.c
@@ -473,6 +473,134 @@ static void setup_efi_info(struct x86_li
 	get_bootparam(&real_mode->efi_info, offset, 32);
 }
 
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
+	struct efi_mem_descriptor map[0];
+};
+
+struct setup_data {
+	uint64_t next;
+	uint32_t type;
+	uint32_t len;
+	uint8_t data[0];
+} __attribute__((packed));
+
+static void _get_efi_value(char *line, const char *pattern, __uint64_t *val)
+{
+	char *s, *end;
+	s = strstr(line, pattern);
+	if (s)
+		*val = strtoull(s + strlen(pattern), &end, 16);
+}
+
+static void get_efi_value(struct efi_setup_data *esd)
+{
+	FILE *fp;
+	char line[1024];
+
+	fp = fopen("/sys/firmware/efi/systab", "r");
+	if (!fp)
+		return;
+
+	while (fgets(line, sizeof(line), fp) != 0) {
+		_get_efi_value(line, "fw_vendor=0x", &esd->fw_vendor);
+		_get_efi_value(line, "runtime=0x", &esd->runtime);
+		_get_efi_value(line, "config_tables=0x", &esd->tables);
+		_get_efi_value(line, "SMBIOS=0x", &esd->smbios);
+	}
+
+	fclose(fp);
+}
+
+static int get_efi_runtime_map(struct efi_setup_data **esd)
+{
+	DIR *dirp;
+	struct dirent *entry;
+	char filename[1024];
+	struct efi_mem_descriptor md;
+	int nr_maps = 0;
+
+	dirp = opendir("/sys/firmware/efi/efi-runtime-map");
+	while ((entry = readdir(dirp)) != NULL) {
+		sprintf(filename,
+			"/sys/firmware/efi/efi-runtime-map/%s",
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
+		*esd = realloc(*esd, sizeof(struct efi_setup_data) +
+			   (nr_maps + 1) * sizeof(struct efi_mem_descriptor));
+		*((*esd)->map + nr_maps) = md;
+		nr_maps++;
+	}
+
+	closedir(dirp);
+	return nr_maps;
+}
+
+static void setup_efi_setup_data(struct kexec_info *info,
+			struct x86_linux_param_header *real_mode)
+{
+	int nr_maps;
+	int64_t setup_data_paddr;
+	struct setup_data *sd;
+	struct efi_setup_data *esd;
+	int size, sdsize;
+	int has_efi = 0;
+
+	has_efi = access("/sys/firmware/efi/systab", F_OK);
+	if (has_efi < 0)
+		return;
+
+	esd = malloc(sizeof(struct efi_setup_data));
+	if (!esd)
+		return;
+	memset(esd, 0, sizeof(struct efi_setup_data));
+	get_efi_value(esd);
+	nr_maps = get_efi_runtime_map(&esd);
+	size = nr_maps * sizeof(struct efi_mem_descriptor) +
+		sizeof(struct efi_setup_data);
+	sd = malloc(sizeof(struct setup_data) + size);
+	if (!sd) {
+		free(esd);
+		return;
+	}
+
+	memset(sd, 0, sizeof(struct setup_data) + size);
+	sd->next = 0;
+	sd->type = 4;
+	sd->len = size;
+	memcpy(sd->data, esd, size);
+	free(esd);
+	sdsize = sd->len + sizeof(struct setup_data);
+	setup_data_paddr = add_buffer(info, sd, sdsize, sdsize, getpagesize(),
+					0x100000, ULONG_MAX, INT_MAX);
+
+	real_mode->setup_data = setup_data_paddr;
+}
+
+
 void setup_linux_system_parameters(struct kexec_info *info,
 				   struct x86_linux_param_header *real_mode)
 {
@@ -482,8 +610,10 @@ void setup_linux_system_parameters(struc
 
 	/* get subarch from running kernel */
 	setup_subarch(real_mode);
-	if (bzImage_support_efi_boot)
+	if (bzImage_support_efi_boot) {
 		setup_efi_info(real_mode);
+		setup_efi_setup_data(info, real_mode);
+	}
 	
 	/* Default screen size */
 	real_mode->orig_x = 0;
