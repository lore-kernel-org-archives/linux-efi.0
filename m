From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH V5 00/18] ARM EFI stub common code
Date: Wed, 25 Sep 2013 13:11:20 +0100
Message-ID: <20130925121120.GI21381@console-pimps.org>
References: <1379889942-3135-1-git-send-email-roy.franz@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1379889942-3135-1-git-send-email-roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Sun, 22 Sep, at 03:45:24PM, Roy Franz wrote:
> This patch is the common/x86 portion of the ARM EFI stub
> patchset broken out.  These changes support the addition
> of EFI stub support for the ARM and ARM64 architectures.
> The common code that is now shared in efi-stub-helper.c
> is based on code in the x86 stub that has been generalized
> to support other architectures.

OK, I've applied this patch series (excluding PATCH 10) to the
'arm/common' branch in the EFI repository at,

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git

At the request of Grant, the patches series from both Roy and Leif are
available in a clean branch with a linear history at 'efi-arm', which is
based on v3.11. Grant, feel free to pull that branch into wherever it is
required. If this layout doesn't work for you guys then just shout and
we can come up with a scheme that does.

I'm going to send a pull request for the 'next' branch to the tip folks,
so that these patches can get some testing via linux-next.

-- 
Matt Fleming, Intel Open Source Technology Center
