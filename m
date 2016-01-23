From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v3 0/4] x86/efi: use binary units when printing
Date: Sat, 23 Jan 2016 16:55:09 +0200
Message-ID: <1453560913-134672-1-git-send-email-andriy.shevchenko@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>, Matt Fleming <matt@codeblueprint.co.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, linux-efi@vger.kernel.org, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Andrew Morton <akpm@linux-foundation.org>, "linux-kernel @ vger . kernel . org" <linux-kernel@vger.kernel.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
List-Id: linux-efi@vger.kernel.org

The patch series exports the arrays of binary and decimal units as it's
described by IEC.

First user of it is EFI code which would print sizes and other values using
binary prefix.

James, is this now okay to you?

Matt, I suppose we need to update the stuff in your tree.

Since v2:
- address James comment (don't nail array size)
- fix a title and commit message for patch 3 to be in align with the change

Andy Shevchenko (3):
  lib/string_helpers: export string_units_{2,10} for others
  lib/string_helpers: fix indentation in few places
  x86/efi: Use proper units in efi_find_mirror()

Robert Elliott (1):
  x86/efi: print size in binary units in efi_print_memmap

 arch/x86/platform/efi/efi.c    | 27 ++++++++++++++++++---------
 include/linux/string_helpers.h |  3 +++
 lib/string_helpers.c           | 26 ++++++++++++++------------
 3 files changed, 35 insertions(+), 21 deletions(-)

-- 
2.7.0.rc3
