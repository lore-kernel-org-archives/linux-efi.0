From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH] firmware: fix the compiller warning
Date: Fri, 20 Jun 2014 10:03:44 +0100
Message-ID: <20140620090344.GV24049@console-pimps.org>
References: <53A3B665.3080308@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <53A3B665.3080308-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ding Tianhong <dingtianhong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 20 Jun, at 12:19:49PM, Ding Tianhong wrote:
> When I compile the kernel, found this warning:
> 
> In file included from arch/arm64/kernel/efi-stub.c:44:0:
> arch/arm64/kernel/../../../drivers/firmware/efi/fdt.c: In function update_fdt:
> arch/arm64/kernel/../../../drivers/firmware/efi/fdt.c:66:22: warning: unused variable name [-Wunused-variable]
>    const char *type, *name;
> 
> so remove the unused variable and clean this warning.
> 
> Signed-off-by: Ding Tianhong <dingtianhong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/firmware/efi/fdt.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Thanks, for the report, but I've already queued up a fix from Catalin
and sent a pull request to the tip folks,

 http://marc.info/?l=linux-kernel&m=140325482303647 

-- 
Matt Fleming, Intel Open Source Technology Center
