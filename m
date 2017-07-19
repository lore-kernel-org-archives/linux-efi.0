From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 4.12 26/84] x86/xen/efi: Initialize only the EFI struct
 members used by Xen
Date: Wed, 19 Jul 2017 13:12:14 +0200
Message-ID: <20170719111214.GA11941@kroah.com>
References: <20170719092322.362625377@linuxfoundation.org>
 <20170719092323.396710042@linuxfoundation.org>
 <20170719103747.GZ4448@olila.local.net-space.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170719103747.GZ4448@olila.local.net-space.pl>
Sender: stable-owner@vger.kernel.org
To: Daniel Kiper <daniel.kiper@oracle.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, andrew.cooper3@citrix.com, jgross@suse.com, linux-efi@vger.kernel.org, matt@codeblueprint.co.uk, xen-devel@lists.xenproject.org, Ingo Molnar <mingo@kernel.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Jul 19, 2017 at 12:37:47PM +0200, Daniel Kiper wrote:
> Hey Greg,
> 
> On Wed, Jul 19, 2017 at 11:43:32AM +0200, Greg Kroah-Hartman wrote:
> > 4.12-stable review patch.  If anyone has any objections, please let me know.
> 
> Why did you skip this patch for 4.11? IMO it should be applied there too.

Are you sure it actually applied?  (hint, it did not...)

If you want it in 4.11, or older kernels, please provide a working
backport.

thanks,

greg k-h
