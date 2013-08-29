From: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: EFI mode after running kexec
Date: Wed, 28 Aug 2013 19:26:32 -0700
Message-ID: <20130829022632.GA26862@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Hi all,

I've been messing with UEFI booting a kernel and then later on, using
kexec to boot another kernel, and noticed that the kexec'ed kernel is
not really in EFI mode, although the EFI framebuffer seems present and
able to be used.

Is this to be expected?  I'd think that the EFI framebuffer wouldn't be
around anymore.  Odds are this is a BIOS bug, given that the machine I'm
using is a really old UEFI mode (i.e. before secure boot mode ever
showed up), but should it work this way?

And, to get kexec to run the kernel in EFI mode, would require kexec to
treat the kernel as a EFI binary and run it that way, instead of the
"normal" way it currently is, right?

thanks,

greg k-h
