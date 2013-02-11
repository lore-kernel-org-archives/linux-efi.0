From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: [PATCH 0/2] efivarfs patch queue
Date: Mon, 11 Feb 2013 14:28:53 +0000
Message-ID: <1360592935-26026-1-git-send-email-matt@console-pimps.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

I've queued up the following fixes in the 'next' branch of the EFI
tree. Both bugs were reported by Lingzhu Xiang and are caused by a
lack of filename validation in efivarfs.

Matt Fleming (2):
  efivarfs: Validate filenames much more aggressively
  efivarfs: guid part of filenames are case-insensitive

 drivers/firmware/efivars.c | 156 +++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 150 insertions(+), 6 deletions(-)

-- 
1.7.11.7
