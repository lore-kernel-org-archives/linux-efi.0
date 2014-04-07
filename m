From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH 3/5] efi: x86: Improve cmdline conversion
Date: Mon, 7 Apr 2014 14:19:12 +0100
Message-ID: <20140407131912.GG5222@console-pimps.org>
References: <1396614350-20889-1-git-send-email-leif.lindholm@linaro.org>
 <1396614350-20889-4-git-send-email-leif.lindholm@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1396614350-20889-4-git-send-email-leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 04 Apr, at 01:25:48PM, Leif Lindholm wrote:
> From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
> 
> Improve the conversion of the UTF-16 EFI command line
> to UTF-8 for passing to the kernel.
> 
> Signed-off-by: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> Signed-off-by: H. Peter Anvin <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

This Signed-off-by chain looks a little wonky because it reads as though
the patch was sent by Roy to Peter, who sent it to Leif. Not only that,
I don't have a record of Peter using his zytor.com account to submit
this patch, only his linux.intel.com address.

*rummage* *rummage*.... this is what I have in my inbox,

    From 7d6cf630c1adbb9787a24c2994230373c2b20a8f Mon Sep 17 00:00:00 2001
    From: "H. Peter Anvin" <hpa-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
    Date: Fri, 20 Sep 2013 09:55:39 -0500
    Subject: [PATCH] efi: Handle arbitrary Unicode characters

    Instead of truncating UTF-16 assuming all characters is ASCII,
    properly convert it to UTF-8.

    Signed-off-by: H. Peter Anvin <hpa-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
    ---
     arch/x86/boot/compressed/eboot.c       |  3 +-
     drivers/firmware/efi/efi-stub-helper.c | 89 ++++++++++++++++++++++++++--------
     2 files changed, 71 insertions(+), 21 deletions(-)

It looks like some unnecessary patch munging has gone on here. Now if
Roy has modified Peter's patch in some way, that's fine, but it needs to
be called out in the SoB chain, e.g.

    Signed-off-by: H. Peter Anvin <hpa-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
    [ Add func foobar() and refactored code for XXX ]
    Signed-off-by: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
    Signed-off-by: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

Make sense?

-- 
Matt Fleming, Intel Open Source Technology Center
