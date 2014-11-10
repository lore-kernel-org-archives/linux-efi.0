From: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Subject: Re: [PATCH] rtc: Disable EFI rtc for x86
Date: Mon, 10 Nov 2014 21:26:53 +0000
Message-ID: <20141110212652.GA9212@srcf.ucam.org>
References: <1412339576-17972-1-git-send-email-matt@console-pimps.org>
 <20141109182231.GA29337@pd.tnic>
 <1415618533.14686.239.camel@mfleming-mobl1.ger.corp.intel.com>
 <201411101723.49197@pali>
 <5460EB92.1090501@gmail.com>
 <20141110170417.GA17286@srcf.ucam.org>
 <5461220E.20605@gmail.com>
 <546126FF.3070600@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <546126FF.3070600-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alessandro Zummo <a.zummo-BfzFCNDTiLLj+vYz1yj4TQ@public.gmane.org>, rtc-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Nov 10, 2014 at 12:58:39PM -0800, H. Peter Anvin wrote:

> It could also be that the non-CSM BIOS somehow remaps the CMOS registers.

We should be getting that information from ACPI - cmos_pnp_probe() 
doesn't have hardcoded assumptions about registers.

-- 
Matthew Garrett | mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org
