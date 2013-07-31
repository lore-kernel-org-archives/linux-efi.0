From: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Subject: Re: Corrupted EFI region
Date: Wed, 31 Jul 2013 22:54:23 +0100
Message-ID: <20130731215423.GA2628@srcf.ucam.org>
References: <20130731205431.GG4724@pd.tnic>
 <20130731205858.GA1678@srcf.ucam.org>
 <20130731215130.GA6087@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130731215130.GA6087-fF5Pk5pvG8Y@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Jul 31, 2013 at 11:51:30PM +0200, Borislav Petkov wrote:

> But the problem is, something messes up the upper boundary of the region
> and it is an EFI_BOOT_SERVICES_DATA region which we need for the runtime
> services mapping and if we can't map it properly, we're probably going
> to miss functionality or not have runtime at all.

"Easiest" way around this would probably be to stash the address map 
after ExitBootServices() and compare it at SetVirtualAddressMap() time, 
then take the widest boundaries and trim the e820 map to match. This is 
obviously dependent upon the system not allocating anything further 
after that, but it seems safest. The worst case is finding the firmware 
writing over bits of the kernel.

-- 
Matthew Garrett | mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org
