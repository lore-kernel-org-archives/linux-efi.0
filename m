From: David Howells <dhowells@redhat.com>
Subject: [PATCH 04/24] Enforce module signatures if the kernel is locked down
Date: Wed, 05 Apr 2017 21:15:03 +0100
Message-ID: <149142330358.5101.11872619513155932508.stgit@warthog.procyon.org.uk>
References: <149142326734.5101.4596394505987813763.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <149142326734.5101.4596394505987813763.stgit@warthog.procyon.org.uk>
Sender: owner-linux-security-module@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: gnomes@lxorguk.ukuu.org.uk, linux-efi@vger.kernel.org, matthew.garrett@nebula.com, gregkh@linuxfoundation.org, dhowells@redhat.com, linux-security-module@vger.kernel.org, keyrings@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

If the kernel is locked down, require that all modules have valid
signatures that we can verify.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 kernel/module.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/module.c b/kernel/module.c
index 7eba6dea4f41..3331f2eb9b93 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2756,7 +2756,7 @@ static int module_sig_check(struct load_info *info, int flags)
 	}
 
 	/* Not having a signature is only an error if we're strict. */
-	if (err == -ENOKEY && !sig_enforce)
+	if (err == -ENOKEY && !sig_enforce && !kernel_is_locked_down())
 		err = 0;
 
 	return err;

