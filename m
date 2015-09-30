From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH 2/2] arm64/efi: Don't pad between EFI_MEMORY_RUNTIME
 regions
Date: Wed, 30 Sep 2015 10:33:39 +0200
Message-ID: <20150930083339.GB6033@pd.tnic>
References: <1443218539-7610-1-git-send-email-matt@codeblueprint.co.uk>
 <1443218539-7610-3-git-send-email-matt@codeblueprint.co.uk>
 <20150926060159.GB25877@gmail.com>
 <CAKv+Gu_JRCmx5qKq7SDDq73BegVs3LKZwe+OdvTKb4YD_CURyw@mail.gmail.com>
 <20150927070644.GC26125@gmail.com>
 <20150927104014.GA7631@pd.tnic>
 <20150929143612.GC4401@codeblueprint.co.uk>
 <560B3327.9020801@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <560B3327.9020801-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, "stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Denys Vlasenko <dvlasenk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Brian Gerst <brgerst-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Sep 29, 2015 at 05:56:07PM -0700, H. Peter Anvin wrote:
> On 09/29/2015 07:36 AM, Matt Fleming wrote:
> >  
> > That's a pretty good summary for x86. I think specifically the reason
> > we map the EFI memmap entries "backwards" (entry N has higher VA than
> > entry N+1) is because the code was easier to write that way, but
> > you'll know better than me ;-)
> > 
> 
> There were two reasons:
> 
> 1. The code was easier to write.
> 2. Windows did it that way.
> 
> Windows apparently broke and was changed due to this feature, too.

So can we do the 1:1 thing again?

I mean, we do create a special pagetable for EFI anyway, we can put in
there whatever we want.

I know, some apple boxes reportedly fail when 1:1 mapping is in use but
we can do the VA mapping as a workaround for them. I.e., have the 1:1
mapping be the default.

Apparently, there's not a single OS or tool which is used by fw writers
to test their brain dumplings. Windoze breakage case-in-point.

Because if there were, we'd simply do what that OS/tool does and be done
with it.

What really makes me climb the walls is when half-cooked, untested fw
hits the wild and we have to support it indefinitely.

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
