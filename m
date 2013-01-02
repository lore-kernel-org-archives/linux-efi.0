From: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Subject: Re: Revisiting EFI boot stub config file support
Date: Wed, 2 Jan 2013 17:54:23 +0000
Message-ID: <20130102175423.GA2881@srcf.ucam.org>
References: <50E306FB.6080607@shealevy.com>
 <50E31BB4.7040702@zytor.com>
 <710F73BE-9F65-48C9-8739-BFCF097F4B07@shealevy.com>
 <20130102174319.GA2590@srcf.ucam.org>
 <4DA0AD0B-49D1-4938-B38D-A15C378167B0@shealevy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4DA0AD0B-49D1-4938-B38D-A15C378167B0-yfkUTty7RcRWk0Htik3J/w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shea Levy <shea-yfkUTty7RcRWk0Htik3J/w@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Jan 02, 2013 at 12:52:21PM -0500, Shea Levy wrote:

> But you can't set args when booting from external media (using e.g. 
> \boot\efi\bootx64.efi), at least not on any system I've seen. And even 
> if you could, that'd over complicate the install process for new 
> users.

So have an initial wrapper that launches the kernel and passes an 
argument. You're going to need something equivalent if you want to 
support Secure Boot.

-- 
Matthew Garrett | mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org
