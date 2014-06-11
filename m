From: Alex Thorlton <athorlton@sgi.com>
Subject: Re: [RFC] Best place/method to determine BIOS version?
Date: Wed, 11 Jun 2014 12:30:22 -0500
Message-ID: <20140611173022.GD3275@sgi.com>
References: <20140609200017.GD2700@sgi.com>
 <20140611085548.GB26290@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140611085548.GB26290@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@console-pimps.org>
Cc: Alex Thorlton <athorlton@sgi.com>, Linux EFI <linux-efi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>, Russ Anderson <rja@sgi.com>
List-Id: linux-efi@vger.kernel.org

On Wed, Jun 11, 2014 at 09:55:48AM +0100, Matt Fleming wrote:
> Can't you use either early_ioremap() or ioremap() (depending on when you
> want to access the physical address), perhaps coupled with
> efi_call_phys()?

I had actually tried that exact approach, but I think the problem is
that I need to remap both the function code, and the data that it needs
to access, and the pointers get clobbered in that process.  The pointers
work fine in direct physical mode, and they work fine after being mapped
into the EFI page table in virtual mode, but I think there's some magic
in there that helps fix them up when set_virtual_address_map is called,
which isn't getting done when I try to remap manually.

I'll look into this approach a bit more to be absolutely sure that it
won't work, but I hadn't had any luck so far.

- Alex
