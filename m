From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] x86/efi: Add EFI framebuffer earlyprintk support
Date: Thu, 10 Oct 2013 19:45:21 +0200
Message-ID: <20131010174521.GA27218@gmail.com>
References: <1381423261-30566-1-git-send-email-matt@console-pimps.org>
 <20131010172844.GA26430@gmail.com>
 <20131010173710.GA18821@fenchurch.internal.datastacks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20131010173710.GA18821@fenchurch.internal.datastacks.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Jones <pjones@redhat.com>
Cc: Matt Fleming <matt@console-pimps.org>, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
List-Id: linux-efi@vger.kernel.org


* Peter Jones <pjones@redhat.com> wrote:

> On Thu, Oct 10, 2013 at 07:28:44PM +0200, Ingo Molnar wrote:
> > 
> > Is a non-32-bit framebuffer a possibility? If yes then it might be nice to 
> > emit an informative printk() here, so that users who try to enable EFI 
> > early-printk can at least see why it's not working. (Assuming they get to 
> > look at regular printk output, on a safe/working kernel.)
> 
> Not really - the spec allows RGBx, BGRx, and for custom bit masks, but
> they're define like:
> 
> typedef struct {
> 	UINT32 RedMask;
> 	UINT32 GreenMask;
> 	UINT32 BlueMask;
> 	UINT32 ReservedMask;
> } EFI_PIXEL_BITMASK;

Hm, that structure does not show up anywhere in the kernel that I can see.

How are those mask values to be interpreted? As regular bitmasks? Are bits 
in the masks set to 1 consecutively, starting from bit 0?

Also, the main question would be, what is the typical value for 
si->lfb_depth. 32 on almost all EFI systems? All around the map? Depends 
on what graphics state the EFI bootloader passes us?

Thanks,

	Ingo
