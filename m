From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH] x86/efi: Fix multiple GOP device support
Date: Wed, 14 Oct 2015 16:10:02 +0100
Message-ID: <20151014151002.GD2782@codeblueprint.co.uk>
References: <1444659236-24837-1-git-send-email-matt@codeblueprint.co.uk>
 <1444659236-24837-2-git-send-email-matt@codeblueprint.co.uk>
 <20151014144715.GA17890@gmail.com>
 <20151014145103.GB17890@gmail.com>
 <20151014150215.GC2782@codeblueprint.co.uk>
 <20151014150426.GC21330@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151014150426.GC21330@gmail.com>
Sender: stable-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>, =?utf-8?B?S8WRdsOhZ8OzLCBab2x0w6Fu?= <dirty.ice.hu@gmail.com>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Matthew Garrett <mjg59@srcf.ucam.org>, stable@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>
List-Id: linux-efi@vger.kernel.org

On Wed, 14 Oct, at 05:04:26PM, Ingo Molnar wrote:
> 
> * Matt Fleming <matt@codeblueprint.co.uk> wrote:
> 
> > > So the fix patch is fine as-is for v4.3, but needs a conflict resolution for 
> > > the pending v4.4 commit.
> > > 
> > > I've applied it that way.
> > 
> > Do you need me to send a patch on top or have you taken care of the
> > semantic conflict for v4.4? (the change you originally proposed,
> > s/u32/u64/, looked fine)
> 
> So to not break bisection in hard to debug ways, I made this fixup in the merge 
> commit of your changes, and documented it all in the merge commit message:
> 
> commit 790a2ee2427852cff50993c98f15ed88511e9af0
> Merge: c7d77a7980e4 0f96a99dab36
> Author: Ingo Molnar <mingo@kernel.org>
> Date:   Wed Oct 14 16:05:40 2015 +0200

[...]

>     Note: there is a semantic conflict between the following two commits:
>     
>       8a53554e12e9 ("x86/efi: Fix multiple GOP device support")
>       ae2ee627dc87 ("efifb: Add support for 64-bit frame buffer addresses")
>     
>     I fixed up the interaction in the merge commit, changing the type of
>     current_fb_base from u32 to u64.
>     
>     Signed-off-by: Ingo Molnar <mingo@kernel.org>

Awesome, thanks Ingo.

-- 
Matt Fleming, Intel Open Source Technology Center
