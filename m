From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: Refactoring and cleanup patch on x86/efi
Date: Mon, 9 Jun 2014 14:41:27 +0100
Message-ID: <20140609134127.GD27302@console-pimps.org>
References: <D65204BE7F571446A6F75A899654E932723D6CFC@FMSMSX103.amr.corp.intel.com>
 <20140606132606.GA27302@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140606132606.GA27302-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Tangri, Saurabh" <saurabh.tangri-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Fri, 06 Jun, at 02:26:06PM, Matt Fleming wrote:
> On Wed, 04 Jun, at 02:09:15PM, Tangri, Saurabh wrote:
> > x86/efi: Move all workarounds to a separate file quirks.c
> > 
> > Currently, it's difficult to find all the workarounds that are
> > applied when running on EFI, because they're littered throughout
> > various code paths. This change moves all of them into a separate
> > file with the hope that it will be come the single location for all
> > our well documented quirks.
> 
> Thanks Saurabh, applied to the 'next' branch. I had to rebase it against
> 'next' because there's been a few changes since the patches that are in
> the 'stable' branch.
> 
> Please double check to make sure that I did the rebase correctly,
> 
>   http://git.kernel.org/cgit/linux/kernel/git/mfleming/efi.git/commit/?h=next&id=fdf46c9f56a9fdcfc4e0b250e893cd7ffcecf0d5

Turns out I didn't apply it as carefully as I should have done, and the
kbuild bot noticed,

  https://lists.01.org/pipermail/kbuild-all/2014-June/004895.html

I've fixed this up and pushed it back out along with a commit that
should also fix the long standing sparse issue described in,

 https://lists.01.org/pipermail/kbuild-all/2014-June/004896.html

-- 
Matt Fleming, Intel Open Source Technology Center
