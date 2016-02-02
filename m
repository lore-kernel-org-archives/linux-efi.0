From: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Preventing "rm -rf /sys/firmware/efi/efivars/" from damage
Date: Tue,  2 Feb 2016 17:33:01 -0500
Message-ID: <1454452386-27709-1-git-send-email-pjones@redhat.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Hi everybody,
Here's a patchset to make all the variables in efivarfs that aren't well
known to be reasonably safe to delete be immutable by default.

This should alleviate the danger of somebody accidentally using "rm" to
remove some proprietary file that turns out to be important to the
platform, which for some reason it also can't regenerate during POST.

In all cases this is just preventing the user from accidentally
triggering a major security problem with their underlying firmware, but
stopping accidents isn't a bad thing.  These firmwares still need CVEs
and updates to fix them.  Maybe using ESRT and fwupd :)

Thanks.
