From: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: efi: make most efivarfs files immutable by default
Date: Mon,  8 Feb 2016 14:48:10 -0500
Message-ID: <1454960895-3473-1-git-send-email-pjones@redhat.com>
References: <20160204234211.GI2586@codeblueprint.co.uk>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160204234211.GI2586-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Hi,
Here's the latest version of my patch series to make efivarfs make files
be immutable by default unless they're on our whitelist.  As you might
expect, this version has a couple of differences from the previous one:

In patch 2/5:
- efivar_create_sysfs_entry() was reworked to use the length it computes
  instead of lots of calls to strlen(), and it doesn't have unused
  variables any more.
In 3/5:
- "len" was renamed to "data_size" for clarity, and we calculate the
  variable name's size correctly instead now.
In 4/5:
- The commit message was reworded based largely on mfleming's suggestions.
In 5/5:
- An old comment from a previous version was fixed to not be confusing.
- the inode lock is now taken when we're modifying inode metadata.

Thanks,
Peter
