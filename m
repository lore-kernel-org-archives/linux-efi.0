From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v4 2/4] Add function get_bootparam
Date: Fri, 20 Dec 2013 18:05:45 +0800
Message-ID: <1387533947-18210-3-git-send-email-dyoung@redhat.com>
References: <1387533947-18210-1-git-send-email-dyoung@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
In-Reply-To: <1387533947-18210-1-git-send-email-dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/kexec/>
List-Post: <mailto:kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=subscribe>
Sender: "kexec" <kexec-bounces-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Errors-To: kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
To: kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, toshi.kani-VXdhtT5mjnY@public.gmane.org, matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org, greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, horms-/R6kz+dDXgpPR4JQBCEnsQ@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Not only setup_subarch will get data from debugfs file
boot_params/data, later code for adding efi_info will
also need do same thing. Thus add a common function here
for later use.

v1->v2: make get_bootparam() static
v2->v3: return error code when get_bootparam fails because
        later patch to collect efi runtime maps will not
        necessary if get_bootparam fails.
	switch to use /sys/kernel/boot_params if possible.
	return error code for later use in setup_efi_info.

Signed-off-by: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 kexec/arch/i386/x86-linux-setup.c | 42 +++++++++++++++++++++++++++++----------
 1 file changed, 31 insertions(+), 11 deletions(-)

diff --git a/kexec/arch/i386/x86-linux-setup.c b/kexec/arch/i386/x86-linux-setup.c
index 454fad6..7b4c65d 100644
--- a/kexec/arch/i386/x86-linux-setup.c
+++ b/kexec/arch/i386/x86-linux-setup.c
@@ -436,28 +436,48 @@ char *find_mnt_by_fsname(char *fsname)
 	return mntdir;
 }
 
-void setup_subarch(struct x86_linux_param_header *real_mode)
+static int get_bootparam(void *buf, off_t offset, size_t size)
 {
 	int data_file;
-	const off_t offset = offsetof(typeof(*real_mode), hardware_subarch);
-	char *debugfs_mnt;
+	char *debugfs_mnt, *sysfs_mnt;
 	char filename[PATH_MAX];
+	int err, has_sysfs_params = 0;
+
+	sysfs_mnt = find_mnt_by_fsname("sysfs");
+	if (sysfs_mnt) {
+		snprintf(filename, PATH_MAX, "%s/%s", sysfs_mnt,
+			"kernel/boot_params/data");
+		free(sysfs_mnt);
+		err = access(filename, F_OK);
+		if (!err)
+			has_sysfs_params = 1;
+	}
 
-	debugfs_mnt = find_mnt_by_fsname("debugfs");
-	if (!debugfs_mnt)
-		return;
-	snprintf(filename, PATH_MAX, "%s/%s", debugfs_mnt, "boot_params/data");
-	filename[PATH_MAX-1] = 0;
-	free(debugfs_mnt);
+	if (!has_sysfs_params) {
+		debugfs_mnt = find_mnt_by_fsname("debugfs");
+		if (!debugfs_mnt)
+			return 1;
+		snprintf(filename, PATH_MAX, "%s/%s", debugfs_mnt,
+				"boot_params/data");
+		free(debugfs_mnt);
+	}
 
 	data_file = open(filename, O_RDONLY);
 	if (data_file < 0)
-		return;
+		return 1;
 	if (lseek(data_file, offset, SEEK_SET) < 0)
 		goto close;
-	read(data_file, &real_mode->hardware_subarch, sizeof(uint32_t));
+	read(data_file, buf, size);
 close:
 	close(data_file);
+	return 0;
+}
+
+void setup_subarch(struct x86_linux_param_header *real_mode)
+{
+	off_t offset = offsetof(typeof(*real_mode), hardware_subarch);
+
+	get_bootparam(&real_mode->hardware_subarch, offset, sizeof(uint32_t));
 }
 
 void setup_linux_system_parameters(struct kexec_info *info,
-- 
1.8.3.1
