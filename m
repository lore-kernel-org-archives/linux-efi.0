From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/6] x86/efi: Allow invocation of arbitrary runtime services
Date: Tue, 22 Nov 2016 15:52:41 +0000
Message-ID: <24973.1479829961@warthog.procyon.org.uk>
References: <1479826691.1942.11.camel@perches.com> <20161122102018.GB1552@wunner.de> <20161117123731.GA11573@wunner.de> <147977469914.6360.17194649697208113702.stgit@warthog.procyon.org.uk> <27422.1479824220@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1479826691.1942.11.camel-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Content-ID: <24972.1479829961.1-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org> wrote:

> > > Small nit, checkpatch usually complains that this should be written as
> > > 12-character SHA-1 followed by the commit subject, i.e.
> > > 
> > > 0a637ee61247 ("x86/efi: Allow invocation of arbitrary boot services")
> > 
> > In this case, checkpatch is wrong.
>
> Why do you think so?

Actually, checkpatch doesn't complain about embedded commit IDs anymore, so in
that case, it's just about acceptable.

Apart from that, I think we should put in the full SHA-1 commit.  The
probability of a collision in a 12-digit hex number for the >5,000,000 commits
just in Linus's tree is currently at ~4.5% and gradually increasing.  Add in
all the commits in not-yet-upstreamed trees - which might be another million
commits, say - then we're over 6%..

Oh, yes, and speaking of checkpatch, can you make it so that if it sees:

commit 12345...
Author: foo <foo@bar>
Date: blah

   Subject line

   Description lines
   ...
   ...
   ...
   ...

   Signed-off-by-and-suchline-lines

diff ...

with the all description indented by 4 spaces, then assume that it's the
output of git show and not give the warnings about signed-off-by and other
things being indented?

David
