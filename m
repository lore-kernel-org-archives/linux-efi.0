From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: EFI: Stash ROMs if they're not in the PCI BAR
Date: Wed, 20 Mar 2013 08:44:35 +0000
Message-ID: <514976F3.2@console-pimps.org>
References: <20130315082928.GA14520@longonot.mountain>  <1363337872.2444.9.camel@shinybook.infradead.org>  <1363606563.15011.333.camel@mfleming-mobl1.ger.corp.intel.com> <1363622520.2553.8.camel@x230.sbx07502.somerma.wayport.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1363622520.2553.8.camel-tCUS0Eywp2Pehftex57rkxo58HMYffqeLoYNBG0abjxeoWH0uzbU5w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Cc: David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 03/18/2013 04:02 PM, Matthew Garrett wrote:
> On Mon, 2013-03-18 at 11:36 +0000, Matt Fleming wrote:
>> On Fri, 2013-03-15 at 08:57 +0000, David Woodhouse wrote:
>>> True. It probably doesn't *matter* because the size is zero so the
>>> firmware is just going to ignore the pointer anyway. Although in that
>>> case I wonder why we couldn't have just passed NULL. Perhaps we expected
>>> that some firmware might do some validation on the pointer before
>>> getting to the size check?
>>
>> I doubt that the firmware checks the validity of pci_handle when size is
>> zero, and I agree it's worth passing NULL to silence the warning (which
>> is also more explicit that just initialising pci_handle), unless Matthew
>> knows of a reason we shouldn't do that?
> 
> No reason I can think of, and any failure will be pretty immediately
> obvious.

Anyone want to submit a patch?

-- 
Matt Fleming, Intel Open Source Technology Center
