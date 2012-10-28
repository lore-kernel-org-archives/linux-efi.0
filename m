From: Jeremy Kerr <jk-mnsaURCQ41sdnm+yROfE0A@public.gmane.org>
Subject: [PATCH] efivars: disable seeking on efivarfs files
Date: Sun, 28 Oct 2012 22:53:08 +0100
Message-ID: <1351461188.69188.706774060048.1.gpush@pororo>
References: <<1351248303.5303.60.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <<1351248303.5303.60.camel-ZqTwcBeJ+wsBof6jY8KHXm7IUlhRatedral2JQCrhuEAvxtiuMwx3w@public.gmane.org>>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Whitcroft <apw-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Jan Beulich <JBeulich-IBi9RG/b67k@public.gmane.org>, Chun-Yi Lee <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Use no_llseek as the llseek callback for efivarfs files, as we don't
support writes to arbitrary locations.

Signed-off-by: Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

---
 drivers/firmware/efivars.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index 73f22d1..a162649 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -847,7 +847,7 @@ static const struct file_operations efivarfs_file_operations = {
 	.open	= efivarfs_file_open,
 	.read	= efivarfs_file_read,
 	.write	= efivarfs_file_write,
-	.llseek	= default_llseek,
+	.llseek	= no_llseek,
 };
 
 static struct inode *efivarfs_get_inode(struct super_block *sb,
