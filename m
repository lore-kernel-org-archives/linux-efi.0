From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH] ignore ,keep for efi earlyprintk
Date: Fri, 25 Apr 2014 12:53:45 +0100
Message-ID: <20140425115345.GC26088@console-pimps.org>
References: <20140424093658.GA7158@dhcp-16-198.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140424093658.GA7158-je1gSBvt1Tc/CGXRbJeUwh/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, 24 Apr, at 05:36:58PM, Dave Young wrote:
> earlyprint=efi,keep results a kernel hang after "Freeing unused kernel memory"
 
Are you sure it hangs and it's not just that nothing is output to the
console after that point?

> Actually efi earlyprintk is using __init functions such as early_ioremap etc.
> Thus efi earlyconsole can not be kept.
 
Urgh, good point, that's a bug. However I'm sure I've had this working
in the past and have in fact used it to debug stuff.

Could you try and fix this up so it works with 'keep'?

-- 
Matt Fleming, Intel Open Source Technology Center
