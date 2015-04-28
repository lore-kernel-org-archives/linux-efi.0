From: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: ESRT support
Date: Tue, 28 Apr 2015 18:44:30 -0400
Message-ID: <1430261071-14005-1-git-send-email-pjones@redhat.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hi,
As promised, now that the UEFI 2.5 spec is out and ESRT is a real thing,
here's the follow-up email to this one is the patch to support it.

It handles the version of the firmware table that's in the spec, and has
been tested to work on development platforms from two firmware vendors, as
well as with an ESRT implementation running under OVMF (i.e.  Qemu+KVM) on
both x86_64 and i686, which you can find here:

https://github.com/vathpela/edk2/tree/fake-capsule
