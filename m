From: David Howells <dhowells@redhat.com>
Subject: [PATCH 20/27] Prohibit PCMCIA CIS storage when the kernel is locked
 down
Date: Thu, 19 Oct 2017 15:53:04 +0100
Message-ID: <150842478444.7923.5111743275510836636.stgit@warthog.procyon.org.uk>
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

Prohibit replacement of the PCMCIA Card Information Structure when the
kernel is locked down.

Suggested-by: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: linux-pcmcia@lists.infradead.org
---

 drivers/pcmcia/cistpl.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/pcmcia/cistpl.c b/drivers/pcmcia/cistpl.c
index 55ef7d1fd8da..b7a0e42eeb25 100644
--- a/drivers/pcmcia/cistpl.c
+++ b/drivers/pcmcia/cistpl.c
@@ -1578,6 +1578,9 @@ static ssize_t pccard_store_cis(struct file *filp, struct kobject *kobj,
 	struct pcmcia_socket *s;
 	int error;
 
+	if (kernel_is_locked_down("Direct PCMCIA CIS storage"))
+		return -EPERM;
+
 	s = to_socket(container_of(kobj, struct device, kobj));
 
 	if (off)
