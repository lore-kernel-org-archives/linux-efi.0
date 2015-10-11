From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH v7 1/2] efi: export efi_capsule_supported() function
 symbol
Date: Sun, 11 Oct 2015 20:03:38 +0100
Message-ID: <20151011190338.GA2688@codeblueprint.co.uk>
References: <1444076155-19295-1-git-send-email-hock.leong.kweh@intel.com>
 <1444076155-19295-2-git-send-email-hock.leong.kweh@intel.com>
 <20151005131350.GA26329@nazgul.tnic>
 <20151010220202.GH2723@codeblueprint.co.uk>
 <F54AEECA5E2B9541821D670476DAE19C4A875128@PGSMSX102.gar.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <F54AEECA5E2B9541821D670476DAE19C4A875128-j2khPEwRog0FyVwBAnZdSLfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "Ong, Boon Leong" <boon.leong.ong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sam Protsenko <semen.protsenko-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Fleming, Matt" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Sun, 11 Oct, at 02:28:30PM, Kweh Hock Leong wrote:
> > -----Original Message-----
> > From: Matt Fleming [mailto:matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org]
> > Sent: Sunday, October 11, 2015 6:02 AM
> > 
> > I agree that it makes sense to fold this patch into your PATCH 2, because then
> > we know why we need the above symbol to be exported.
> > 
> 
> Okay, I will squash that into my patch and re-submit v9. Before that,
> are there any comments to my v8 patchset?

Yeah, I've got some comments on your v8. Please wait until I send them
before mailing the next version of this patch series.

-- 
Matt Fleming, Intel Open Source Technology Center
