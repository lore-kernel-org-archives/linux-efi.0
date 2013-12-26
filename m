From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: split efi systab in sysfs
Date: Thu, 26 Dec 2013 09:53:08 +0800
Message-ID: <20131226015308.GA3750@dhcp-16-126.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org
Cc: greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Hi, Matt and Peter

Currently /sys/firmware/efi/systab contains multi-lines for efi systab
entries. As previous discussion with Greg, this is not a good in sysfs.
I wonder if there's other users for this file except kexec-tools.

If kexec-tools is the only user, maybe I can split it as several files.
In kexec-tools just use /sys/firmware/efi/"$entry_name" and if $entry_name
does not exist then switch to old systab file. 

Thanks
Dave
