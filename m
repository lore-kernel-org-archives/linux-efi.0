From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH] efi: fix always unregister kset of efivars in
 register_efivars
Date: Mon, 29 Oct 2012 19:11:44 +0000
Message-ID: <1351537904.14888.44.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1351493576-3094-1-git-send-email-jlee@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1351493576-3094-1-git-send-email-jlee-IBi9RG/b67k@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Lee, Chun-Yi" <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>, Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, 2012-10-29 at 14:52 +0800, Lee, Chun-Yi wrote:
> The cc9c97b76aa7235d5a1de0f74f990097f77008b4 patch introduced a
> issue that always unregister kset of efivars in register_efivars.
> 
> This patch moved the kset_unregister function call to the kobject create check
> block for fix issue.
> 
> Cc: Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: H. Peter Anvin <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
> Cc: Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
> Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Lee, Chun-Yi <jlee-IBi9RG/b67k@public.gmane.org>
> ---
>  drivers/firmware/efivars.c |    6 ++----
>  1 files changed, 2 insertions(+), 4 deletions(-)

Thanks Joey. What I ended up doing was squashing this patch with your
previous version and rebasing my 'next' branch. That way, when this
series is merged the bug will never appear.

Please take a look to make sure everything is OK.

-- 
Matt Fleming, Intel Open Source Technology Center
