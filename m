From: "Luck, Tony" <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] efi: Add newline to cper DIMM location messages
Date: Mon, 27 Jan 2014 10:43:36 -0800
Message-ID: <52e6a8d812916d47b@agluck-desk.sc.intel.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Chen, Gong" <gong.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

We forgot the newline at the end of two messages. Add it.

Acked-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

---

diff --git a/drivers/firmware/efi/cper.c b/drivers/firmware/efi/cper.c
index 1491dd4f08f9..9f59f6ba271a 100644
--- a/drivers/firmware/efi/cper.c
+++ b/drivers/firmware/efi/cper.c
@@ -240,9 +240,9 @@ static void cper_print_mem(const char *pfx, const struct cper_sec_mem_err *mem)
 		const char *bank = NULL, *device = NULL;
 		dmi_memdev_name(mem->mem_dev_handle, &bank, &device);
 		if (bank != NULL && device != NULL)
-			printk("%s""DIMM location: %s %s", pfx, bank, device);
+			printk("%s""DIMM location: %s %s\n", pfx, bank, device);
 		else
-			printk("%s""DIMM DMI handle: 0x%.4x",
+			printk("%s""DIMM DMI handle: 0x%.4x\n",
 			       pfx, mem->mem_dev_handle);
 	}
 }
