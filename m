From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: EFI: Stash ROMs if they're not in the PCI BAR
Date: Wed, 20 Mar 2013 12:09:57 +0300
Message-ID: <20130320090957.GA9189@mwanda>
References: <20130315082928.GA14520@longonot.mountain>
 <1363337872.2444.9.camel@shinybook.infradead.org>
 <1363606563.15011.333.camel@mfleming-mobl1.ger.corp.intel.com>
 <1363622520.2553.8.camel@x230.sbx07502.somerma.wayport.net>
 <514976F3.2@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <514976F3.2-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Mar 20, 2013 at 08:44:35AM +0000, Matt Fleming wrote:
> On 03/18/2013 04:02 PM, Matthew Garrett wrote:
> > On Mon, 2013-03-18 at 11:36 +0000, Matt Fleming wrote:
> >> On Fri, 2013-03-15 at 08:57 +0000, David Woodhouse wrote:
> >>> True. It probably doesn't *matter* because the size is zero so the
> >>> firmware is just going to ignore the pointer anyway. Although in that
> >>> case I wonder why we couldn't have just passed NULL. Perhaps we expected
> >>> that some firmware might do some validation on the pointer before
> >>> getting to the size check?
> >>
> >> I doubt that the firmware checks the validity of pci_handle when size is
> >> zero, and I agree it's worth passing NULL to silence the warning (which
> >> is also more explicit that just initialising pci_handle), unless Matthew
> >> knows of a reason we shouldn't do that?
> > 
> > No reason I can think of, and any failure will be pretty immediately
> > obvious.
> 
> Anyone want to submit a patch?
> 

Sure.  I'll send one tomorrow.

regards,
dan carpenter
