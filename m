From: David Howells <dhowells@redhat.com>
Subject: [PATCH 19/27] scsi: Lock down the eata driver
Date: Thu, 19 Oct 2017 15:52:57 +0100
Message-ID: <150842477698.7923.15570916285929038112.stgit@warthog.procyon.org.uk>
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
