From: David Howells <dhowells@redhat.com>
Subject: [PATCH 19/30] scsi: Lock down the eata driver
Date: Thu,  9 Nov 2017 17:33:01 +0000
Message-ID: <151024878098.28329.8580788703224340862.stgit@warthog.procyon.org.uk>
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

When the kernel is running in secure boot mode, we lock down the kernel to
prevent userspace from modifying the running kernel image.  Whilst this
includes prohibiting access to things like /dev/mem, it must also prevent
access by means of configuring driver modules in such a way as to cause a
device to access or modify the kernel image.

The eata driver takes a single string parameter that contains a slew of
settings, including hardware resource configuration.  Prohibit use of the
parameter if the kernel is locked down.

Suggested-by: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Dario Ballabio <ballabio_dario@emc.com>
cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
cc: "Martin K. Petersen" <martin.petersen@oracle.com>
cc: linux-scsi@vger.kernel.org
---

 drivers/scsi/eata.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/eata.c b/drivers/scsi/eata.c
index 6501c330d8c8..72fceaa8f3da 100644
--- a/drivers/scsi/eata.c
+++ b/drivers/scsi/eata.c
@@ -1552,8 +1552,11 @@ static int eata2x_detect(struct scsi_host_template *tpnt)
 
 	tpnt->proc_name = "eata2x";
 
-	if (strlen(boot_options))
+	if (strlen(boot_options)) {
+		if (kernel_is_locked_down("Command line-specified device addresses, irqs and dma channels"))
+			return -EPERM;
 		option_setup(boot_options);
+	}
 
 #if defined(MODULE)
 	/* io_port could have been modified when loading as a module */
