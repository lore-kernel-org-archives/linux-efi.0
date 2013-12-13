From: Davidlohr Bueso <davidlohr-VXdhtT5mjnY@public.gmane.org>
Subject: [PATCH] MAINTAINERS: add myself as gpt maintainer
Date: Fri, 13 Dec 2013 10:05:29 -0800
Message-ID: <1386957929.2867.6.camel@buesod1.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Matt Domsch <Matt_Domsch-8PEkshWhKlo@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Davidlohr Bueso <davidlohr-VXdhtT5mjnY@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Davidlohr Bueso <davidlohr-VXdhtT5mjnY@public.gmane.org>

Add a new entry for the GPT standard. Any future changes will now be routed
through linux-efi.

Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: Matt Domsch <Matt_Domsch-8PEkshWhKlo@public.gmane.org>
Signed-off-by: Davidlohr Bueso <davidlohr-VXdhtT5mjnY@public.gmane.org>
---
This was discussed offline and both Matts are fine with me maintaining this.

 MAINTAINERS | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 4afcfb4..cf41aa5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3834,6 +3834,12 @@ T:	git git://linuxtv.org/media_tree.git
 S:	Maintained
 F:	drivers/media/usb/gspca/
 
+GUID PARTITION TABLE (GPT)
+M:	Davidlohr Bueso <davidlohr-VXdhtT5mjnY@public.gmane.org>
+L:	linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
+S:	Maintained
+F:	block/partitions/efi.*
+
 STK1160 USB VIDEO CAPTURE DRIVER
 M:	Ezequiel Garcia <elezegarcia-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
 L:	linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
-- 
1.8.1.4
