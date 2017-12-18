From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH] x86: move parse_early_param to earlier code for
 add_efi_memmap
Date: Mon, 18 Dec 2017 13:11:19 +0000
Message-ID: <20171218131119.GA3891@codeblueprint.co.uk>
References: <20171130052327.GA3500@dhcp-128-65.nay.redhat.com>
 <20171214104119.GA2437@dhcp-128-65.nay.redhat.com>
 <20171215151822.GB3204@codeblueprint.co.uk>
 <20171216140632.462yk7pmlvpmz6if@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171216140632.462yk7pmlvpmz6if@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: Dave Young <dyoung@redhat.com>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, ard.biesheuvel@linaro.org
List-Id: linux-efi@vger.kernel.org

On Sat, 16 Dec, at 03:06:32PM, Ingo Molnar wrote:
> 
> * Matt Fleming <matt@codeblueprint.co.uk> wrote:
> 
> > >  	x86_init.oem.arch_setup();
> > > @@ -962,6 +959,8 @@ void __init setup_arch(char **cmdline_p)
> > >  
> > >  	parse_early_param();
> > >  
> > > +	if (efi_enabled(EFI_BOOT))
> > > +		efi_memblock_x86_reserve_range();
> > >  #ifdef CONFIG_MEMORY_HOTPLUG
> > >  	/*
> > >  	 * Memory used by the kernel cannot be hot-removed because Linux
> > > 
> > 
> > I prefer this version. Please re-send a full patch and update the
> > subject line to include the "fix" somewhere; it wasn't obvious to me
> > from the start that this is a bug fix.
> 
> Agreed.
> 
> I dropped the commit I just applied to tip:efi/core, since you are handling this, 
> so this patch should come through the regular EFI channels, right?

Yep, that's right. Me or Ard will take care of it.
