From: "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v3 2/3] firmware_loader: fix positive return value being treat as error return
Date: Sat, 11 Apr 2015 03:40:43 +0800
Message-ID: <1428694844-7782-3-git-send-email-hock.leong.kweh@intel.com>
References: <1428694844-7782-1-git-send-email-hock.leong.kweh@intel.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1428694844-7782-1-git-send-email-hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Ong Boon Leong <boon.leong.ong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sam Protsenko <semen.protsenko-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Due to wait_for_completion_interruptible_timeout() will return
its remaining timeout jiffies value if timeout does not happen,
the error check code "if (ret)" will treat that as error return.
So, fixing the issue by re-assigning back a 'Zero' to the return
value when the wait is completed without timeout.

Signed-off-by: Kweh, Hock Leong <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/base/firmware_class.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index e03235d..b38975d 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -923,6 +923,8 @@ static int _request_firmware_load(struct firmware_priv *fw_priv,
 		mutex_lock(&fw_lock);
 		fw_load_abort(fw_priv);
 		mutex_unlock(&fw_lock);
+	} else {
+		retval = 0;
 	}
 
 	if (is_fw_load_aborted(buf))
-- 
1.7.9.5
