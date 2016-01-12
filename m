From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: v4.4-rc8 based tip tree kernel hangs on boot.
Date: Tue, 12 Jan 2016 11:30:44 +0100
Message-ID: <20160112103043.GA5707@gmail.com>
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

> > Tried reverting Commit 21cdb6b56 "x86/mm: Page align the '_end'
> > symbol to avoid pfn conversion bugs" but that doesnt help.
> 
> Odd. Could you try booting the tip/x86/efi branch instead? There's
> only a handful of patches on that branch so it should be pretty easy
> to narrow down the problematic change.

So he already appears to have done that, when performing the bisection:

 # first bad commit: [21cdb6b568435738cc0b303b2b3b82742396310c] x86/mm: Page align the '_end' symbol to avoid pfn conversion bugs

commit 21cdb6b568 is part of tip:x86/efi:

 triton:~/tip> gll linus..x86/efi
 e2c90dd7e11e x86/efi-bgrt: Replace early_memremap() with memremap()
 98f91276900f Merge tag 'efi-next' of git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi into x86/efi
 50a0cb565246 x86/efi-bgrt: Fix kernel panic when mapping BGRT data
 26d7f65fbd22 x86/efi: Preface all print statements with efi* tag
 3bb9eee61c64 doc: efi-stub.txt: Fix arm64 paths
 7f83773ced2f efi/esrt: Don't preformat name
 ff3d0a12fb2d Documentation/x86: Update EFI memory region description
 67a9108ed431 x86/efi: Build our own page table structures
 c9f2a9a65e48 x86/efi: Hoist page table switching code into efi_call_virt()
 b61a76f8850d x86/efi: Map RAM into the identity page table for mixed mode
 edc3b9129cec x86/mm/pat: Ensure cpa->pfn only contains page frame numbers
 21cdb6b56843 x86/mm: Page align the '_end' symbol to avoid pfn conversion bugs

it's the first commit in the branch in fact.

To double check, it would be nice to check that applying that commit to v4.4 
breaks the boot too:

  git checkout v4.4
  git cherry-pick 21cdb6b568

... but assuming the bisection is reliable, I'd say the evidence is pretty 
conclusive already.

Srikar, could you please send the good and bad System.map files, so that we see 
what the effects of the aligning were? The two interesting sha1's to test are:

  21cdb6b56843: first bad commit
  6ffeba960734: last good commit (parent commit of 21cdb6b56843)

Thanks,

	Ingo
