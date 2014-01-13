From: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 1/2] efi: Fix krealloc defect
Date: Mon, 13 Jan 2014 09:47:21 -0800
Message-ID: <1389635241.24849.22.camel@joe-AO722>
References: <cover.1388793978.git.joe@perches.com>
	 <9a8eb1c9478049318e834d5223053a5fb7484bff.1388793978.git.joe@perches.com>
	 <20140113140334.GB3256@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140113140334.GB3256-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Mon, 2014-01-13 at 14:03 +0000, Matt Fleming wrote:
> On Fri, 03 Jan, at 04:08:47PM, Joe Perches wrote:
> > krealloc should use a temporary pointer for allocations
> > and check the temporary pointer returned against NULL too.
> > 
> > Signed-off-by: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
> > cc: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
> > ---
> >  arch/x86/platform/efi/efi.c | 12 +++++++++---
> >  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> Thanks Joe, but I've already got the following commit queued up from
> Borislav that addresses this,

Hi Matt.  That's great.

If it's queued up in some tree of yours, should that
tree be included in Stephen Rothwell's -next?

cheers, Joe
