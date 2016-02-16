From: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/2] make efivarfs files immutable by default (for stable)
Date: Tue, 16 Feb 2016 11:09:41 -0500
Message-ID: <1455638983-30455-1-git-send-email-pjones@redhat.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hi Matt,
Here's a version of the immutable efivarfs patch set for stable.  It
keeps most of the unicode problems we've already got, and just changes
our matching so we can match guids correctly, and then adds the
immutability bits and the whitelist.  I went ahead and folded the pstore
bits in to the second patch, as well.

This is against the 'v4.4' tag in git.  I've built all of the touched
.c files in that tree, but not actually built and run a full kernel.

The differences are roughly:
1) none of the unicode cleanup so we've got a couple of open coded
   ucs2->utf8 loops that don't handle half of the UCS-2 codepoints
2) because of that, in this version, for some functions we're passing in
   the variable name in both character sets.
3) if we see something like L"Boot\x0130000" as an EFI variable name in
   the global guidspace, we will treat it exactly like L"Boot0000" in
   terms of validation and the immutable flag.  I don't think this is a
   big risk, but who knows, maybe some firmware bricks itself if you
   delete high-byte-set UCS-2 names.  Note that this property is only
   true in the case where the matching rule is a glob.
   I'm still reasonably sure the bug we're actually seeing is about UEFI
   driver initialization not being able to recreate data in pre-existing
   variables.
4) v4.4 doesn't have inode_lock() and inode_unlock(), so that code is
   using mutex_lock() and mutex_unlock() instead.

Thanks,
Peter
