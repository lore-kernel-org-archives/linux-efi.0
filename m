From: Matt Fleming <matt.fleming@intel.com>
Subject: Re: [RFC] efivars write(2) races
Date: Fri, 25 Jan 2013 12:50:21 +0000
Message-ID: <1359118221.2496.150.camel@mfleming-mobl1.ger.corp.intel.com>
References: <20130125002552.GC4503@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130125002552.GC4503@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, Jeremy Kerr <jeremy.kerr@canonical.com>, Lingzhu Xiang <lxiang@redhat.com>
List-Id: linux-efi@vger.kernel.org

On Fri, 2013-01-25 at 00:25 +0000, Al Viro wrote:
> 	1) process A does write() on efivars file, reaches ->get_variable(),
> gets newdatasize set, drops efivars->lock and loses CPU before an attempt to
> grab ->i_mutex.  process B comes and does the same thing, replacing the
> variable contents.  Then it grabs ->i_mutex, updates size, drops ->i_mutex
> and buggers off.  At which point A gets CPU back and proceeds to set size
> to whatever would be valid for its write.  Only the value is bogus now...

Crap, yes. We'll have to jiggle the locking rules around to fix this
one.

> 	2) what's to prevent EFI_NOT_FOUND being hit twice?  Bad things
> will obviously happen in that case...

I'm not sure which execution path will trigger this? Oh, if we're
spinning for the spinlock in efivarfs_unlink() while another process
does a delete via efivarfs_file_write()? Yeah, that's gonna cause some
tears.

Thanks, Al.
