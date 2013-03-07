From: Maarten Lankhorst <maarten.lankhorst-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: [PATCH] efivarfs: loosen restriction on valid names
Date: Thu, 07 Mar 2013 16:06:38 +0100
Message-ID: <5138ACFE.30701@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Commit da27a2438 (efivarfs: guid part of filenames are case-insensitive) fails to boot,
because the kernel creates files in the form of dump-type-x-y-z-GUID. Since the kernel already
created files in this form, these type of files obviously exist, so the right course of action
is to relax the restriction in efivarfs_valid_name.

Signed-off-by: Maarten Lankhorst <maarten.lankhorst-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [3.8]
---

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index 8bcb595..3ee1882 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -921,8 +921,8 @@ static bool efivarfs_valid_name(const char *str, int len)
 	if (len < GUID_LEN + 2)
 		return false;
 
-	/* GUID should be right after the first '-' */
-	if (s - 1 != strchr(str, '-'))
+	/* GUID should be prefixed with - */
+	if (s[-1] != '-')
 		return false;
 
 	/*
