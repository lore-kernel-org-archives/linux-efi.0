From: Valentin Rothberg <valentinrothberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [GIT PULL] EFI urgent fixes
Date: Sat, 27 Sep 2014 10:04:42 +0200
Message-ID: <CAD3Xx4JmkDZ1Cw02DFAE0fa0EaEmBi8-W-p7JCfEXLERK5yuUQ@mail.gmail.com>
References: <20140925073133.GQ18635@console-pimps.org> <20140925144127.GA3828@gmail.com>
 <1411730854.7866.10.camel@x220> <20140926114454.GV18635@console-pimps.org>
 <1411732755.7866.24.camel@x220> <20140926123429.GX18635@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140926123429.GX18635-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: Paul Bolle <pebolle-IWqWACnzNjzz+pZb47iToQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Fengguang Wu <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, Sep 26, 2014 at 2:34 PM, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org> wrote:
> On Fri, 26 Sep, at 01:59:15PM, Paul Bolle wrote:
>>
>> I have a 800 line perl monster that checks for stuff like this. It's not
>> very sophisticated but smart enough to spot typos like this one. I try
>> to have it check each linux-next (and mainline) release.
>
> Very cool.
>
>> (I think Valentin Rothberg is trying to automate this properly. See
>> http://www.linuxplumbersconf.org/2014/ocw/sessions/1863 .)
>
> Have either of you guys thought about asking for this to be included
> with the 0-day kbuild bot or submitted under scripts/?
>
> It certainly seems like a useful bit of functionality.

Yes, I was talking with Greg about including the tool in the 0-day
testing. In addition, I am working on a  patch to change the
scripts/checkkconfigsymbols script
(https://lkml.org/lkml/2014/9/22/336).

The mayor difference between my tool and the script is that the script
can only find bugs on a symbolic level (i.e., a reference on an
feature that is not defined in Kconfig). The tool that I will present
at the Plumbers Conference is additionally able to detect issue on the
logic level, for instance an #ifdef block that can never be compiled
as its precondition is contradictory. I will send some patches the
next weeks to show which bugs can be detected with the tool.

> Fengguang, the interesting bits of this thread start here,
>
>   https://lkml.kernel.org/r/1411730854.7866.10.camel@x220
>
> --
> Matt Fleming, Intel Open Source Technology Center
