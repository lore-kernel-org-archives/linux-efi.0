From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH] x86, efi: initial the local variable of DataSize to zero
Date: Fri, 3 May 2013 09:50:04 +0100
Message-ID: <20130503085004.GD2254@console-pimps.org>
References: <1367503621-13004-1-git-send-email-jlee@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1367503621-13004-1-git-send-email-jlee-IBi9RG/b67k@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Lee, Chun-Yi" <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>, Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, 02 May, at 10:07:01PM, Lee, Chun-Yi wrote:
> That will be better initial the value of DataSize to zero for the input of
> GetVariable(), otherwise we will feed a random value. The debug log of input
> DataSize like this:
> 
> ...
> [  195.915612] EFI Variables Facility v0.08 2004-May-17
> [  195.915819] efi: size: 18446744071581821342
> [  195.915969] efi:  size': 18446744071581821342
> [  195.916324] efi: size: 18446612150714306560
> [  195.916632] efi:  size': 18446612150714306560
> [  195.917159] efi: size: 18446612150714306560
> [  195.917453] efi:  size': 18446612150714306560
> ...
> 
> The size' is value that was returned by BIOS.
> 
> After applied this patch:
> [   82.442042] EFI Variables Facility v0.08 2004-May-17
> [   82.442202] efi: size: 0
> [   82.442360] efi:  size': 1039
> [   82.443828] efi: size: 0
> [   82.444127] efi:  size': 2616
> [   82.447057] efi: size: 0
> [   82.447356] efi:  size': 5832
> ...
> 
> Found on Acer Aspire V3 BIOS, it will not return the size of data if we input a
> non-zero DataSize.
> 
> Cc: Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: H. Peter Anvin <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Lee, Chun-Yi <jlee-IBi9RG/b67k@public.gmane.org>
> ---
>  arch/x86/platform/efi/efi.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

Applied, thanks.

-- 
Matt Fleming, Intel Open Source Technology Center
