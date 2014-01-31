From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [BUG] Linux 3.14 fails to boot with new EFI changes
Date: Fri, 31 Jan 2014 08:04:28 +0000
Message-ID: <20140131080428.GA29136@console-pimps.org>
References: <20140124183730.GC11788@pd.tnic>
 <20140124184842.GD11788@pd.tnic>
 <20140124191709.GT18196@sgi.com>
 <20140127222129.GK6839@pd.tnic>
 <20140128110552.GA815@pd.tnic>
 <20140128200754.GZ18196@sgi.com>
 <20140128225905.GN815@pd.tnic>
 <20140128234036.GB18196@sgi.com>
 <20140129141822.GC24887@pd.tnic>
 <20140130221950.GJ3105@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140130221950.GJ3105-sJ/iWh9BUns@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>
Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Russ Anderson <rja-sJ/iWh9BUns@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, 30 Jan, at 04:19:50PM, Alex Thorlton wrote:
> Re-adding lkml.
 
Also add linux-efi.

> The quick answer is I think it is a virtual address, because
> it does not work in physical mode.  If you ever see "virtefi"
> on the RHEL bootline it is because RH switched the default
> to physical mode, which caused UV to not boot.  "virtefi"
> forced it back to virtual mode.

Do you have details of the failure, links to bug reports? Is it a
limitation of the firmware?

-- 
Matt Fleming, Intel Open Source Technology Center
