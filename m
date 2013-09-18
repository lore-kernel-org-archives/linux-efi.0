From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH V4 00/17] ARM EFI stub common code
Date: Wed, 18 Sep 2013 14:21:20 +0100
Message-ID: <20130918132120.GK3409@console-pimps.org>
References: <1379391093-27948-1-git-send-email-roy.franz@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1379391093-27948-1-git-send-email-roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Mon, 16 Sep, at 09:11:16PM, Roy Franz wrote:
> This patch is the common/x86 portion of the ARM EFI stub
> patchset broken out.  These changes support the addition
> of EFI stub support for the ARM and ARM64 architectures.
> The common code that is now shared in efi-stub-helper.c
> is based on code in the x86 stub that has been generalized
> to support other architectures.

Apart from PATCH 8/17, these all look good to me and work on my test
machines.

If you can respin PATCH 8 based on my comments I'll pull this series
into my efi tree and get it into linux-next.

-- 
Matt Fleming, Intel Open Source Technology Center
