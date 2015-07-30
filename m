From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH] x86/mm, efi: Check for valid image type
Date: Thu, 30 Jul 2015 14:02:35 +0100
Message-ID: <20150730130235.GF2725@codeblueprint.co.uk>
References: <1437579164-20176-1-git-send-email-bigeasy@linutronix.de>
 <20150728205157.GD2773@codeblueprint.co.uk>
 <20150729001034.GD8671@cloud>
 <55B88F3B.2000902@linutronix.de>
 <20150729093752.GF31695@dhcp-128-89.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150729093752.GF31695@dhcp-128-89.nay.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Young <dyoung@redhat.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>, josh@joshtriplett.org, Matt Fleming <matt.fleming@intel.com>, x86@kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Wed, 29 Jul, at 05:37:52PM, Dave Young wrote:
> 
> Not sure if BGRT is useful in kexec kernel, it seems not worth to copy
> it between kernels.
> 
> IMO just return in case if (efi_setup) is true make sense.

Yes, I think it makes sense to skip touching the BGRT on kexec boot.

As a side note, we should really look at using one of the efi_enabled()
bits to signal when we're booting a kexec'd kernel because it is not at
all obvious that 'efi_setup != 0' means we're in kexec kernel.

But that wants to be a separate patch from this issue.

-- 
Matt Fleming, Intel Open Source Technology Center
