From: David Howells <dhowells@redhat.com>
Subject: [PATCH 08/27] hibernate: Disable when the kernel is locked down
Date: Thu, 19 Oct 2017 15:51:34 +0100
Message-ID: <150842469486.7923.10376463083069013490.stgit@warthog.procyon.org.uk>
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

From: Josh Boyer <jwboyer@fedoraproject.org>

There is currently no way to verify the resume image when returning
from hibernate.  This might compromise the signed modules trust model,
so until we can work with signed hibernate images we disable it when the
kernel is locked down.

Signed-off-by: Josh Boyer <jwboyer@fedoraproject.org>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: linux-pm@vger.kernel.org
---

 kernel/power/hibernate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index a5c36e9c56a6..f2eafefeec50 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -70,7 +70,7 @@ static const struct platform_hibernation_ops *hibernation_ops;
 
 bool hibernation_available(void)
 {
-	return (nohibernate == 0);
+	return nohibernate == 0 && !kernel_is_locked_down("Hibernation");
 }
 
 /**
