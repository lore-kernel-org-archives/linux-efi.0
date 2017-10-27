From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] EFI fixes
Date: Fri, 27 Oct 2017 21:10:47 +0200
Message-ID: <20171027191047.v6hqm7plm5uxf6xd@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Linus,

Please pull the latest efi-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git efi-urgent-for-linus

   # HEAD: 38fb6652229c2149e8694d57db442878fdf8a1bd efi/libstub/arm: Don't randomize runtime regions when CONFIG_HIBERNATION=y

Two fixes: an ARM fix for KASLR interaction with hibernation, plus an efi_test 
crash fix.

 Thanks,

	Ingo

------------------>
Ard Biesheuvel (1):
      efi/libstub/arm: Don't randomize runtime regions when CONFIG_HIBERNATION=y

Dan Carpenter (1):
      efi/efi_test: Prevent an Oops in efi_runtime_query_capsulecaps()


 drivers/firmware/efi/libstub/arm-stub.c | 3 ++-
 drivers/firmware/efi/test/efi_test.c    | 3 +++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/libstub/arm-stub.c b/drivers/firmware/efi/libstub/arm-stub.c
index 1cb2d1c070c3..a94601d5939e 100644
--- a/drivers/firmware/efi/libstub/arm-stub.c
+++ b/drivers/firmware/efi/libstub/arm-stub.c
@@ -238,7 +238,8 @@ unsigned long efi_entry(void *handle, efi_system_table_t *sys_table,
 
 	efi_random_get_seed(sys_table);
 
-	if (!nokaslr()) {
+	/* hibernation expects the runtime regions to stay in the same place */
+	if (!IS_ENABLED(CONFIG_HIBERNATION) && !nokaslr()) {
 		/*
 		 * Randomize the base of the UEFI runtime services region.
 		 * Preserve the 2 MB alignment of the region by taking a
diff --git a/drivers/firmware/efi/test/efi_test.c b/drivers/firmware/efi/test/efi_test.c
index 08129b7b80ab..41c48a1e8baa 100644
--- a/drivers/firmware/efi/test/efi_test.c
+++ b/drivers/firmware/efi/test/efi_test.c
@@ -593,6 +593,9 @@ static long efi_runtime_query_capsulecaps(unsigned long arg)
 	if (copy_from_user(&qcaps, qcaps_user, sizeof(qcaps)))
 		return -EFAULT;
 
+	if (qcaps.capsule_count == ULONG_MAX)
+		return -EINVAL;
+
 	capsules = kcalloc(qcaps.capsule_count + 1,
 			   sizeof(efi_capsule_header_t), GFP_KERNEL);
 	if (!capsules)
