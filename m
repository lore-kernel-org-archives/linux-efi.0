From: Jiri Bohac <jbohac@suse.cz>
Subject: [PATCH 08b/30] kexec_file: Restrict at runtime if the kernel is
 locked down
Date: Thu, 11 Jan 2018 13:02:56 +0100
Message-ID: <20180111120256.oymjgfbndbofasp5@dwarf.suse.cz>
References: <151024863544.28329.2436580122759221600.stgit@warthog.procyon.org.uk>
 <151024869793.28329.4817577607302613028.stgit@warthog.procyon.org.uk>
 <20180111115915.dejachty3l7fwpmf@dwarf.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180111115915.dejachty3l7fwpmf@dwarf.suse.cz>
Sender: owner-linux-security-module@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: linux-security-module@vger.kernel.org, gnomes@lxorguk.ukuu.org.uk, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, jforbes@redhat.com, Chun-Yi Lee <joeyli.kernel@gmail.com>
List-Id: linux-efi@vger.kernel.org

When KEXEC_VERIFY_SIG is not enabled, kernel should not load images through
kexec_file systemcall if the kernel is locked down unless IMA can be used
to validate the image.

Signed-off-by: Jiri Bohac <jbohac@suse.cz>

diff --git a/kernel/kexec_file.c b/kernel/kexec_file.c
--- a/kernel/kexec_file.c
+++ b/kernel/kexec_file.c
@@ -144,7 +144,13 @@ kimage_file_prepare_segments(struct kimage *image, int kernel_fd, int initrd_fd,
 		pr_debug("kernel signature verification successful.\n");
 #endif
 
-	if (sig_err && IS_ENABLED(CONFIG_KEXEC_SIG_FORCE)) {
+	/* Don't permit images to be loaded into trusted kernels without
+	 * a valid signature on them
+	 */
+	if (sig_err &&
+	    (IS_ENABLED(CONFIG_KEXEC_SIG_FORCE) ||
+	     (!is_ima_appraise_enabled() &&
+	      kernel_is_locked_down("kexec of unsigned images")))) {
 		ret = sig_err;
 		goto out;
 	}

-- 
Jiri Bohac <jbohac@suse.cz>
SUSE Labs, Prague, Czechia

