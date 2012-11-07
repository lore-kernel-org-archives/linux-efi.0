From: Thomas Renninger <trenn-l3A5Bk7waGM@public.gmane.org>
Subject: Do not allow MSR or Embedded Controller writes from userspace in secure boot case
Date: Wed,  7 Nov 2012 22:28:17 +0100
Message-ID: <1352323699-52400-1-git-send-email-trenn@suse.de>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jlee-IBi9RG/b67k@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Hi,

I have seen some patches in this area and I wonder whether MSR and EC write accesses from userspace got closed already.

If you can point me to a latest git tree where such patches get applied, I can double check before sending such stuff.
Afaik Matthew collects such patches, but I could not find a related git tree on git.kernel.org.

Anyway, if these make sense, feel free to queue them in an appropriate tree/branch.

   Thomas
