From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [BUG] can't boot up: unable to handle kernel paging request at
 ffffffffff340003
Date: Tue, 11 Feb 2014 13:16:40 +0000
Message-ID: <20140211131640.GD2887@console-pimps.org>
References: <8738jr5t3e.fsf@redhat.com>
 <20140210175246.GB2887@console-pimps.org>
 <87mwhy8iaj.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <87mwhy8iaj.fsf-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Madper Xie <cxie-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Adam Williamson <awilliam-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 11 Feb, at 11:00:52AM, Madper Xie wrote:
> it doesn't help, seems the same panic output:

OK, thanks for testing so quickly.

> [    0.001341] BUG: unable to handle kernel paging request at ffffffffff340003
> [    0.008339] IP: [<ffffffff81a73794>] efi_bgrt_init+0x9d/0x133
> [    0.014111] PGD 28fb067 PUD 28fd067 PMD 2bef067 PTE 9376e01800000163

Thinking about this a bit harder that PTE is invalid because bits 52-63
are not zero, which is exactly the problem you were hitting prior to
-rc2, namely that the physical BGRT address is bogus.

Can you post the EFI memory map entries from a dmesg? I just want to
make sure that it really is the BGRT address that is broken and not
something else. Also, please post the ACPI: BGRT entry from your dmesg
too. Thanks.

-- 
Matt Fleming, Intel Open Source Technology Center
