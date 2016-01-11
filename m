From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: v4.4-rc8 based tip tree kernel hangs on boot.
Date: Mon, 11 Jan 2016 16:10:30 +0100
Message-ID: <20160111151030.GA23096@gmail.com>
References: <20160110192921.GD17012@linux.vnet.ibm.com>
 <20160111140140.GA2644@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160111140140.GA2644-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Srikar Dronamraju <srikar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-efi@vger.kernel.org


* Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:

> On Mon, 11 Jan, at 12:59:21AM, Srikar Dronamraju wrote:
> > On a x86_64 machine, I see kernel v4.4-rc8 based tip tree hangs on boot.
> > However v4.4-rc8 with the same config boots well on the same machine.
> > 
> > git bisect results are as follows
> > 
> > git bisect start
> > # bad: [fc4e8fa9f80e0f099838f3a9997019de36d9a4ba] Merge branch 'WIP.x86/mm'
> > git bisect bad fc4e8fa9f80e0f099838f3a9997019de36d9a4ba
> > # good: [168309855a7d1e16db751e9c647119fe2d2dc878] Linux 4.4-rc8
> > git bisect good 168309855a7d1e16db751e9c647119fe2d2dc878
> > # good: [76e17c25ebc9f6619f9f8fd93f3905b0def8dc6f] Merge branch 'perf/core'
> > git bisect good 76e17c25ebc9f6619f9f8fd93f3905b0def8dc6f
> > # good: [e8998ce7e8ce42419d0c7bb08c105bd860eb3218] Merge branch 'timers/urgent'
> > git bisect good e8998ce7e8ce42419d0c7bb08c105bd860eb3218
> > # good: [af51cdabdbea5355ed388b8b3a7cf9bfc0864b9c] Merge branch 'x86/cpu'
> > git bisect good af51cdabdbea5355ed388b8b3a7cf9bfc0864b9c
> > # bad: [5852b88267adcc78722fc5d4f45751fb6e261bd2] Merge branch 'x86/urgent'
> > git bisect bad 5852b88267adcc78722fc5d4f45751fb6e261bd2
> > # bad: [c236714fd39fb26993af2d5fde9c3bfc32361323] Merge branch 'x86/fpu'
> > git bisect bad c236714fd39fb26993af2d5fde9c3bfc32361323
> > # bad: [ff3d0a12fb2dc123e2b46e9524ebf4e08de5c59c] Documentation/x86: Update EFI memory region description
> > git bisect bad ff3d0a12fb2dc123e2b46e9524ebf4e08de5c59c
> > # bad: [b61a76f8850d2979550abc42d7e09154ebb8d785] x86/efi: Map RAM into the identity page table for mixed mode
> > git bisect bad b61a76f8850d2979550abc42d7e09154ebb8d785
> > # bad: [edc3b9129cecd0f0857112136f5b8b1bc1d45918] x86/mm/pat: Ensure cpa->pfn only contains page frame numbers
> > git bisect bad edc3b9129cecd0f0857112136f5b8b1bc1d45918
> > # bad: [21cdb6b568435738cc0b303b2b3b82742396310c] x86/mm: Page align the '_end' symbol to avoid pfn conversion bugs
> > git bisect bad 21cdb6b568435738cc0b303b2b3b82742396310c
> > # first bad commit: [21cdb6b568435738cc0b303b2b3b82742396310c] x86/mm: Page align the '_end' symbol to avoid pfn conversion bugs
> > 
> > Not much info on the console, when the kernel hangs.
>  
> What info is there?
> 
> > Tried reverting Commit 21cdb6b56 "x86/mm: Page align the '_end'
> > symbol to avoid pfn conversion bugs" but that doesnt help.
> 
> Odd. Could you try booting the tip/x86/efi branch instead? There's
> only a handful of patches on that branch so it should be pretty easy
> to narrow down the problematic change.

Yes, that would be nice, you can get it via:

  git checkout v4.4
  git pull git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86/efi

Meanwhile I'm holding off on sending the pending EFI bits to Linus, conditional on 
the outcome of this regression report.

Thanks,

	Ingo
