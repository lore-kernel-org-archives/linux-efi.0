From: Matt Fleming <matt@console-pimps.org>
Subject: Re: [PATCH 5/5] efi: Capsule update support and pstore backend
Date: Thu, 17 Oct 2013 13:14:01 +0100
Message-ID: <20131017121401.GG10834@console-pimps.org>
References: <1381931460-6999-1-git-send-email-matt@console-pimps.org>
 <1381931460-6999-6-git-send-email-matt@console-pimps.org>
 <20131016201416.GG7456@tassilo.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20131016201416.GG7456@tassilo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andi Kleen <ak@linux.intel.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, Tony Luck <tony.luck@intel.com>, Seiji Aguchi <seiji.aguchi@hds.com>, x86@kernel.org, Matt Fleming <matt.fleming@intel.com>
List-Id: linux-efi@vger.kernel.org

On Wed, 16 Oct, at 01:14:16PM, Andi Kleen wrote:
> > +	  It should be noted that enabling this opton will pass a capsule
> > +	  to the firmware on every boot. Some firmware will not allow a
> > +	  user to enter the BIOS setup when a capsule has been registered
> > +	  on the previous boot.
> 
> That sounds like a problem. Can this be fixed to only do it on demand?

Incorporating something along the lines of,

    echo 1 > /sys/kernel/debug/capsule_enable

would fix this. Assuming that's the kind of thing Matthew had in mind.
 
> > +
> > +	  Many EFI machines have buggy implementations of the UpdateCapsule()
> > +	  runtime service. This option will enable code that may not function
> > +	  correctly with your firmware.
> 
> Do we need white/black lists? 
> 
> Controlling such things form CONFIG is not very good.

We have, so far, avoided creating black/white lists in any of the EFI
code and because this is an optional debug feature and is in no way
required for a user's machine to boot, I'm not sure how much value there
would be in trying to maintain such a list.

On the other hand, the case could be made for failing more gracefully if
we discover the QueryCapsuleCapabilities()/UpdateCapsule() runtime
services are broken when enabling this feature, i.e. through gratuitous
use of FW_BUG.

-- 
Matt Fleming, Intel Open Source Technology Center
