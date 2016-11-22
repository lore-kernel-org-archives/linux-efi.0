From: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 1/6] x86/efi: Allow invocation of arbitrary runtime
 services
Date: Tue, 22 Nov 2016 08:25:39 -0800
Message-ID: <1479831939.1942.13.camel@perches.com>
References: <1479826691.1942.11.camel@perches.com>
         <20161122102018.GB1552@wunner.de> <20161117123731.GA11573@wunner.de>
         <147977469914.6360.17194649697208113702.stgit@warthog.procyon.org.uk>
         <27422.1479824220@warthog.procyon.org.uk>
         <24973.1479829961@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <24973.1479829961-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tue, 2016-11-22 at 15:52 +0000, David Howells wrote:
> Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org> wrote:
> 
> > > > Small nit, checkpatch usually complains that this should be written as
> > > > 12-character SHA-1 followed by the commit subject, i.e.
> > > > 
> > > > 0a637ee61247 ("x86/efi: Allow invocation of arbitrary boot services")
> > > 
> > > In this case, checkpatch is wrong.
> > 
> > Why do you think so?
> 
> Actually, checkpatch doesn't complain about embedded commit IDs anymore, so in
> that case, it's just about acceptable.

checkpatch still emits warnings about the format of
commmit IDs.

What version of checkpatch are yuu using?

> Apart from that, I think we should put in the full SHA-1 commit.  The
> probability of a collision in a 12-digit hex number for the >5,000,000 commits
> just in Linus's tree is currently at ~4.5% and gradually increasing.  Add in
> all the commits in not-yet-upstreamed trees - which might be another million
> commits, say - then we're over 6%..

Umm, no, that's not correct.
SHA-1 lengths of 12 are unique for quite awhile yet.

https://blog.cuviper.com/2013/11/10/how-short-can-git-abbreviate/

Using Linus' tree today, from commit 3b404a519815
the current output of the git-uniq-abbrev script is:

$ git-uniq-abbrev 
5048673 objects
 4: 5048673 / 65536
 5: 5007413 / 998721
 6: 1312496 / 623343
 7: 94487 / 47089
 8: 6163 / 3081
 9: 416 / 208
10: 28 / 14
11: 4 / 2
12: 0 / 0
d597639e2036f04f0226761e2d818b31f2db7820
d597639e203a100156501df8a0756fd09573e2de
ef91b6e893a00d903400f8e1303efc4d52b710af
ef91b6e893afc4c4ca488453ea9f19ced5fa5861

> Oh, yes, and speaking of checkpatch, can you make it so that if it sees:
> 
> commit 12345...
> Author: foo <foo@bar>
> Date: blah
> 
>    Subject line
> 
>    Description lines
>    ...
>    ...
>    ...
>    ...
> 
>    Signed-off-by-and-suchline-lines
> 
> diff ...
> 
> with the all description indented by 4 spaces, then assume that it's the
> output of git show and not give the warnings about signed-off-by and other
> things being indented?

No.  Use --format=email as appropriate instead.
