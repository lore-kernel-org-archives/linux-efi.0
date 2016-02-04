From: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: efivarfs immutable files patch set.
Date: Thu,  4 Feb 2016 10:34:29 -0500
Message-ID: <1454600074-14854-1-git-send-email-pjones@redhat.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Hi Matt,
The next few emails are the latest (and hopefully final) version of my
efivarfs immutability patch set, all shiny and chrome.  This version
has:

- everything you and I talked about fixed
- *probably* that oops you saw fixed - at least there was one oops in
  that patch that is fixed.
- everything fixed that Leif Lindholm noticed 
- everything fixed Joey Li noticed
- an inode locking error Mateusz Guzik noticed
- a bug where from _create() we were including the guid in the name, so
  the check for is_removable failed.

Also it seems to work for Joey, Leif, and I.  So please go ahead and
throw it on your test server and whatnot.  If all goes well, I'll send
you a version against Linus' v4.4 for stable, based on just the last two
patches.  (I'm testing that one now.)

Thanks!
