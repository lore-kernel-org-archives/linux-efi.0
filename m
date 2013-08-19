From: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Subject: Re: UEFI Plugfest 2013 -- New Orleans
Date: Mon, 19 Aug 2013 18:47:43 +0100
Message-ID: <20130819174743.GA25193@srcf.ucam.org>
References: <20130816152030.GL2133@tuxdriver.com>
 <1376900735.2322.26.camel@shinybook.infradead.org>
 <20130819125507.GA19093@srcf.ucam.org>
 <1376925765.2069.24.camel@dabdike.int.hansenpartnership.com>
 <20130819160018.GA22532@srcf.ucam.org>
 <1376931775.2069.46.camel@dabdike.int.hansenpartnership.com>
 <20130819172139.GA24393@srcf.ucam.org>
 <1376933926.2069.52.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1376933926.2069.52.camel-sFMDBYUN5F8GjUHQrlYNx2Wm91YjaHnnhRte9Li2A+AAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "John W. Linville" <linville-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Mon, Aug 19, 2013 at 10:38:46AM -0700, James Bottomley wrote:

> It's not about us removing the code, it's about us having an accurate
> compliance test.  There are two reasons for having a fully correct
> compliance test
> 
>      1. Our work arounds have unintended consequences which have knock
>         on effects which mean that you don't know if a test failure is
>         real or an unintended consequence of a work around.

It doesn't matter. If a platform is supposed to run Linux 3.6 then it 
has to run Linux 3.6 regardless of whether or not the failure is due to 
a firmware bug or a bug in the kernel. The platform vendor will be 
obliged to fix it in the firmware no matter what the test suite says.

>      2. New features in specs tend to build on previous features, so
>         we're going to have a hard time constructing accurate tests for
>         layered features where we've done a work around for the base
>         feature.

Which is easily rectified if the specification is modified to describe 
reality instead.

-- 
Matthew Garrett | mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org
