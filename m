From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH 1/1] arch/x86: Add better error logging to efi main
Date: Thu, 10 Jul 2014 19:36:50 +0100
Message-ID: <20140710183650.GB5952@console-pimps.org>
References: <1404951161-2677-1-git-send-email-ulf@winkelvos.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1404951161-2677-1-git-send-email-ulf-rS3t9PEbhQ0OIzVOb1FTxg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ulf-rS3t9PEbhQ0OIzVOb1FTxg@public.gmane.org
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, 10 Jul, at 02:12:41AM, ulf-rS3t9PEbhQ0OIzVOb1FTxg@public.gmane.org wrote:
> From: Ulf Winkelvos <ulf-rS3t9PEbhQ0OIzVOb1FTxg@public.gmane.org>
> 
> Hopefully this will enable us to better debug:
> https://bugzilla.kernel.org/show_bug.cgi?id=68761
> 
> Signed-off-by: Ulf Winkelvos <ulf-rS3t9PEbhQ0OIzVOb1FTxg@public.gmane.org>
> ---
>  arch/x86/boot/compressed/eboot.c | 14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)

Thanks Ulf, applied.

-- 
Matt Fleming, Intel Open Source Technology Center
