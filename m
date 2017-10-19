From: David Howells <dhowells@redhat.com>
Subject: [PATCH 25/27] Lock down /proc/kcore
Date: Thu, 19 Oct 2017 15:53:42 +0100
Message-ID: <150842482228.7923.9630520914833154257.stgit@warthog.procyon.org.uk>
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

Disallow access to /proc/kcore when the kernel is locked down to prevent
access to cryptographic data.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/proc/kcore.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/proc/kcore.c b/fs/proc/kcore.c
index 45629f4b5402..176cf749e650 100644
--- a/fs/proc/kcore.c
+++ b/fs/proc/kcore.c
@@ -549,6 +549,8 @@ read_kcore(struct file *file, char __user *buffer, size_t buflen, loff_t *fpos)
 
 static int open_kcore(struct inode *inode, struct file *filp)
 {
+	if (kernel_is_locked_down("/proc/kcore"))
+		return -EPERM;
 	if (!capable(CAP_SYS_RAWIO))
 		return -EPERM;
 
