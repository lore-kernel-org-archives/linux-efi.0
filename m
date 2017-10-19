From: David Howells <dhowells@redhat.com>
Subject: [PATCH 03/27] Enforce module signatures if the kernel is locked down
Date: Thu, 19 Oct 2017 15:50:55 +0100
Message-ID: <150842465546.7923.6762214527898273559.stgit@warthog.procyon.org.uk>
References: <150842463163.7923.11081723749106843698.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <150842463163.7923.11081723749106843698.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-security-module@vger.kernel.org
Cc: gnomes@lxorguk.ukuu.org.uk, linux-efi@vger.kernel.org, matthew.garrett@nebula.com, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, dhowells@redhat.com, jforbes@redhat.com
List-Id: linux-efi@vger.kernel.org

If the kernel is locked down, require that all modules have valid
signatures that we can verify.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 kernel/module.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/module.c b/kernel/module.c
index de66ec825992..3d9a3270c179 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2781,7 +2781,8 @@ static int module_sig_check(struct load_info *info, int flags)
 	}
 
 	/* Not having a signature is only an error if we're strict. */
-	if (err == -ENOKEY && !sig_enforce)
+	if (err == -ENOKEY && !sig_enforce &&
+	    !kernel_is_locked_down("Loading of unsigned modules"))
 		err = 0;
 
 	return err;
