From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [GIT PULL] EFI urgent fixes
Date: Fri, 26 Sep 2014 13:34:29 +0100
Message-ID: <20140926123429.GX18635@console-pimps.org>
References: <20140925073133.GQ18635@console-pimps.org>
 <20140925144127.GA3828@gmail.com>
 <1411730854.7866.10.camel@x220>
 <20140926114454.GV18635@console-pimps.org>
 <1411732755.7866.24.camel@x220>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1411732755.7866.24.camel@x220>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Paul Bolle <pebolle-IWqWACnzNjzz+pZb47iToQ@public.gmane.org>
Cc: Valentin Rothberg <valentinrothberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Fengguang Wu <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 26 Sep, at 01:59:15PM, Paul Bolle wrote:
> 
> I have a 800 line perl monster that checks for stuff like this. It's not
> very sophisticated but smart enough to spot typos like this one. I try
> to have it check each linux-next (and mainline) release.
 
Very cool.

> (I think Valentin Rothberg is trying to automate this properly. See
> http://www.linuxplumbersconf.org/2014/ocw/sessions/1863 .)

Have either of you guys thought about asking for this to be included
with the 0-day kbuild bot or submitted under scripts/?

It certainly seems like a useful bit of functionality.

Fengguang, the interesting bits of this thread start here,

  https://lkml.kernel.org/r/1411730854.7866.10.camel@x220

-- 
Matt Fleming, Intel Open Source Technology Center
