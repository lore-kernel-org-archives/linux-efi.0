From: Srikar Dronamraju <srikar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: v4.4-rc8 based tip tree kernel hangs on boot.
Date: Mon, 11 Jan 2016 22:17:12 +0530
Message-ID: <20160111164712.GE17012@linux.vnet.ibm.com>
References: <20160110192921.GD17012@linux.vnet.ibm.com>
 <20160111140140.GA2644@codeblueprint.co.uk>
 <20160111151030.GA23096@gmail.com>
Reply-To: Srikar Dronamraju <srikar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160111151030.GA23096-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

> >  
> > What info is there?
> > 

https://goo.gl/photos/1izrwCtAWj8aK7hi7
Unfortunately I am unable to get a text console. So this is all I see.


> > > Tried reverting Commit 21cdb6b56 "x86/mm: Page align the '_end'
> > > symbol to avoid pfn conversion bugs" but that doesnt help.
> > 
> > Odd. Could you try booting the tip/x86/efi branch instead? There's
> > only a handful of patches on that branch so it should be pretty easy
> > to narrow down the problematic change.
> 
> Yes, that would be nice, you can get it via:
> 

# git reset --hard tip/x86/efi
HEAD is now at e2c90dd x86/efi-bgrt: Replace early_memremap() with memremap()

Tried to boot with the above commit; but it doesnt boot.

-- 
Thanks and Regards
Srikar

>   git checkout v4.4
>   git pull git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86/efi
> 
> Meanwhile I'm holding off on sending the pending EFI bits to Linus, conditional on 
> the outcome of this regression report.
> 
> Thanks,
> 
> 	Ingo
> 

-- 
Thanks and Regards
Srikar Dronamraju
