From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH v2] efi: Introduce EFI bootloader control driver
Date: Tue, 29 Mar 2016 13:53:45 +0100
Message-ID: <20160329125345.GD3625@codeblueprint.co.uk>
References: <1458295910-26557-1-git-send-email-daniel.baluta@intel.com>
 <20160318161505.GU2619@codeblueprint.co.uk>
 <1458328697.16385.21.camel@intel.com>
 <20160324144741.GA4328@codeblueprint.co.uk>
 <1458836156.14677.9.camel@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1458836156.14677.9.camel-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Stanacar, Stefan" <stefan.stanacar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Baluta, Daniel" <daniel.baluta-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dvhart-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org" <dvhart-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Gumbel, Matthew K" <matthew.k.gumbel-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Purdila, Octavian" <octavian.purdila-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Abbas, Mohamed" <mohamed.abbas-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Musca, Constantin" <constantin.musca-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, 24 Mar, at 04:15:56PM, Stanacar, Stefan wrote:
> 
> Ok, that's funny somehow... I wouldn't be surprised if I'd find 3 more
> variations of the same driver in different vendor trees :(.

Right. And that does add weight to getting a version merged upstream;
to discourage people carrying their own.

> I'll ping the author of the patch, thanks!

I haven't reviewed the patch in detail, but it did look like the
correct general approach.
