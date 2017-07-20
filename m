From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 4.12 26/84] x86/xen/efi: Initialize only the EFI struct
 members used by Xen
Date: Thu, 20 Jul 2017 11:16:39 +0200
Message-ID: <20170720091639.GA1071@kroah.com>
References: <20170719092322.362625377@linuxfoundation.org>
 <20170719092323.396710042@linuxfoundation.org>
 <20170719103747.GZ4448@olila.local.net-space.pl>
 <20170720083910.aygobq7t7g7laszt@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170720083910.aygobq7t7g7laszt@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: Daniel Kiper <daniel.kiper@oracle.com>, linux-kernel@vger.kernel.org, stable@vger.kernel.org, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, andrew.cooper3@citrix.com, jgross@suse.com, linux-efi@vger.kernel.org, matt@codeblueprint.co.uk, xen-devel@lists.xenproject.org
List-Id: linux-efi@vger.kernel.org

On Thu, Jul 20, 2017 at 10:39:10AM +0200, Ingo Molnar wrote:
> 
> * Daniel Kiper <daniel.kiper@oracle.com> wrote:
> 
> > Hey Greg,
> > 
> > On Wed, Jul 19, 2017 at 11:43:32AM +0200, Greg Kroah-Hartman wrote:
> > > 4.12-stable review patch.  If anyone has any objections, please let me know.
> > 
> > Why did you skip this patch for 4.11? IMO it should be applied there too.
> 
> The thing is, this patch should probaly not even be in v4.12, as it should only 
> make any difference if there's a separate _bug_ in the kernel.
> 
> This patch makes things more robust going forward, but I question that it needs to 
> be in -stable.

Yeah, good point, I'm going to go drop it entirely from the 4.12-stable
tree as it obviously isn't stable material, sorry for not catching that
before.

thanks,

greg k-h
