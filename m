From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH 15/15] kexec: Support kexec/kdump on EFI systems
Date: Tue, 1 Jul 2014 22:23:51 +0100
Message-ID: <20140701212351.GK7539@console-pimps.org>
References: <1403814824-7587-1-git-send-email-vgoyal@redhat.com>
 <1403814824-7587-16-git-send-email-vgoyal@redhat.com>
 <20140701194605.GJ7539@console-pimps.org>
 <20140701131419.454a3fc32fcc84a43b668c50@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140701131419.454a3fc32fcc84a43b668c50-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, chaowang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tue, 01 Jul, at 01:14:19PM, Andrew Morton wrote:
> 
> This?
> 
> From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> Subject: kexec-support-kexec-kdump-on-efi-systems-fix
> 
> s/get_efi/efi_get/g, per Matt
> 
> Cc: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
> Signed-off-by: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

Yep, looks spot on. Thanks Andrew.

-- 
Matt Fleming, Intel Open Source Technology Center
