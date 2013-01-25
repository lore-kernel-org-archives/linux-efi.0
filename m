From: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Subject: [RFC] efivars write(2) races
Date: Fri, 25 Jan 2013 00:25:53 +0000
Message-ID: <20130125002552.GC4503@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

	1) process A does write() on efivars file, reaches ->get_variable(),
gets newdatasize set, drops efivars->lock and loses CPU before an attempt to
grab ->i_mutex.  process B comes and does the same thing, replacing the
variable contents.  Then it grabs ->i_mutex, updates size, drops ->i_mutex
and buggers off.  At which point A gets CPU back and proceeds to set size
to whatever would be valid for its write.  Only the value is bogus now...

	2) what's to prevent EFI_NOT_FOUND being hit twice?  Bad things
will obviously happen in that case...
