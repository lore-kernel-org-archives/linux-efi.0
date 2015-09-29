From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH 2/2] arm64/efi: Don't pad between EFI_MEMORY_RUNTIME
 regions
Date: Tue, 29 Sep 2015 15:36:12 +0100
Message-ID: <20150929143612.GC4401@codeblueprint.co.uk>
References: <1443218539-7610-1-git-send-email-matt@codeblueprint.co.uk>
 <1443218539-7610-3-git-send-email-matt@codeblueprint.co.uk>
 <20150926060159.GB25877@gmail.com>
 <CAKv+Gu_JRCmx5qKq7SDDq73BegVs3LKZwe+OdvTKb4YD_CURyw@mail.gmail.com>
 <20150927070644.GC26125@gmail.com>
 <20150927104014.GA7631@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150927104014.GA7631-fF5Pk5pvG8Y@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, "stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Denys Vlasenko <dvlasenk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Brian Gerst <brgerst-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Sun, 27 Sep, at 12:40:14PM, Borislav Petkov wrote:
> On Sun, Sep 27, 2015 at 09:06:44AM +0200, Ingo Molnar wrote:
> > Could we please re-list all the arguments pro and contra of 1:1 physical mappings, 
> > in a post that also explains the background so that more people can chime in, not 
> > just people versed in EFI internals? It's very much possible that a bad decision 
> > was made.
> 
> The main reason why we did the additional, top-down mapping was kexec
> kernel wanting to use UEFI runtime facilities too and the braindead
> design of SetVirtualAddressMap() being callable only once per system
> boot. So we had to have stable mappings which are valid in the kexec-ed
> kernel too.
> 
> But this was long time ago and I most certainly have forgotten all the
> details.
 
That's a pretty good summary for x86. I think specifically the reason
we map the EFI memmap entries "backwards" (entry N has higher VA than
entry N+1) is because the code was easier to write that way, but
you'll know better than me ;-)

> And now I'm wondering why didn't we do the 1:1 thing and rebuild the
> exact same EFI pagetable in the kexec-ed kernel? Because when we do
> an EFI call, we switch to the special pagetable so why didn't we make
> the kexec-ed kernel rebuild the 1:1 pagetable which it can use for EFI
> calls...
> 
> Hmm, again, I've forgotten a lot of details so I'm sure Matt will come
> in and say "No, you can't do that because..."

I *think* the only reason was the Apple firmware problem where it
explodes if you pass the 1:1 mappings to SetVirtualAddressMap(). And
obviously people do want to use kexec with Apple machines.

It's probably worth revisiting this whole thing from the x86 side.

-- 
Matt Fleming, Intel Open Source Technology Center
