From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [GIT PULL] EFI changes for v3.8
Date: Tue, 13 Nov 2012 22:20:45 +0000
Message-ID: <1352845245.15747.113.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1352844053.15747.111.camel@mfleming-mobl1.ger.corp.intel.com>
	 <50A2C572.30307@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50A2C572.30307-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 2012-11-13 at 14:10 -0800, H. Peter Anvin wrote:
> On 11/13/2012 02:00 PM, Matt Fleming wrote:
> > Hi guys,
> > 
> > The following changes since commit 5189c2a7c7769ee9d037d76c1a7b8550ccf3481c:
> > 
> >   x86: efi: Turn off efi_enabled after setup on mixed fw/kernel (2012-10-25 19:09:40 +0100)
> > 
> > are available in the git repository at:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-for-3.8
> > 
> > for you to fetch changes up to fdafa1c8261d4fe2350e63e8dd315bfd58674455:
> > 
> 
> This is a lambda merge... are the commits in efi-for-3.7 already
> upstream?  If so, there is no reason to include them in this pull request.

Yes, they are already upstream.

> For now I am going to put efi/next into -tip as core/efi.  Please let me
> know if we should put the efi-for-3.7 into an urgent branch.

OK, thanks. No need to put efi-for-3.7 into an urgent branch.

-- 
Matt Fleming, Intel Open Source Technology Center
