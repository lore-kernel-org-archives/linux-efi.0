From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 4.12 26/84] x86/xen/efi: Initialize only the EFI struct
 members used by Xen
Date: Wed, 19 Jul 2017 13:19:58 +0200
Message-ID: <20170719111958.GA13157@kroah.com>
References: <20170719092322.362625377@linuxfoundation.org>
 <20170719092323.396710042@linuxfoundation.org>
 <20170719103747.GZ4448@olila.local.net-space.pl>
 <20170719111214.GA11941@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170719111214.GA11941@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Kiper <daniel.kiper@oracle.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, andrew.cooper3@citrix.com, jgross@suse.com, linux-efi@vger.kernel.org, matt@codeblueprint.co.uk, xen-devel@lists.xenproject.org, Ingo Molnar <mingo@kernel.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Jul 19, 2017 at 01:12:14PM +0200, Greg Kroah-Hartman wrote:
> On Wed, Jul 19, 2017 at 12:37:47PM +0200, Daniel Kiper wrote:
> > Hey Greg,
> > 
> > On Wed, Jul 19, 2017 at 11:43:32AM +0200, Greg Kroah-Hartman wrote:
> > > 4.12-stable review patch.  If anyone has any objections, please let me know.
> > 
> > Why did you skip this patch for 4.11? IMO it should be applied there too.
> 
> Are you sure it actually applied?  (hint, it did not...)
> 
> If you want it in 4.11, or older kernels, please provide a working
> backport.

And, in the future, if you want it to be applied to older kernels, or be
notified if it can not be, please add a kernel version number in the
stable marking:
	Cc: stable@vger.kernel.org # 4.0+
or use the Fixes: tag:
	Fixes: SHASHAHSA ("short description")
which I pick up on and let you know if the patch does not actually apply
back to the kernel that the fixes: tag was in.

hope this helps,

greg k-h
