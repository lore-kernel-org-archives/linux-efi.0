From: David Howells <dhowells@redhat.com>
Subject: [PATCH 08/30] kexec_file: Restrict at runtime if the kernel is locked down
Date: Thu,  9 Nov 2017 17:31:38 +0000
Message-ID: <151024869793.28329.4817577607302613028.stgit@warthog.procyon.org.uk>
References: <151024863544.28329.2436580122759221600.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <151024863544.28329.2436580122759221600.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-security-module@vger.kernel.org
Cc: gnomes@lxorguk.ukuu.org.uk, linux-efi@vger.kernel.org, dhowells@redhat.com, linux-kernel@vger.kernel.org, jforbes@redhat.com
List-Id: linux-efi@vger.kernel.org

From: Chun-Yi Lee <joeyli.kernel@gmail.com>

When KEXEC_VERIFY_SIG is not enabled, kernel should not load images through
kexec_file systemcall if the kernel is locked down unless IMA can be used
to validate the image.

This code was showed in Matthew's patch but not in git:
https://lkml.org/lkml/2015/3/13/778

Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Signed-off-by: Chun-Yi Lee <jlee@suse.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: James Morris <james.l.morris@oracle.com>
cc: kexec@lists.infradead.org
---

 kernel/kexec_file.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/kernel/kexec_file.c b/kernel/kexec_file.c
index 9f48f4412297..3ba28fc3fab0 100644
--- a/kernel/kexec_file.c
+++ b/kernel/kexec_file.c
@@ -255,6 +255,14 @@ SYSCALL_DEFINE5(kexec_file_load, int, kernel_fd, int, initrd_fd,
 	if (!capable(CAP_SYS_BOOT) || kexec_load_disabled)
 		return -EPERM;
 
+	/* Don't permit images to be loaded into trusted kernels if we're not
+	 * going to verify the signature on them
+	 */
+	if (!IS_ENABLED(CONFIG_KEXEC_VERIFY_SIG) &&
+	    !is_ima_appraise_enabled() &&
+	    kernel_is_locked_down("kexec of unsigned images"))
+		return -EPERM;
+
 	/* Make sure we have a legal set of flags */
 	if (flags != (flags & KEXEC_FILE_FLAGS))
 		return -EINVAL;
