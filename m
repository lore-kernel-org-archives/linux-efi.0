From: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Subject: Re: Revisiting EFI boot stub config file support
Date: Wed, 2 Jan 2013 17:43:19 +0000
Message-ID: <20130102174319.GA2590@srcf.ucam.org>
References: <50E306FB.6080607@shealevy.com>
 <50E31BB4.7040702@zytor.com>
 <710F73BE-9F65-48C9-8739-BFCF097F4B07@shealevy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <710F73BE-9F65-48C9-8739-BFCF097F4B07-yfkUTty7RcRWk0Htik3J/w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shea Levy <shea-yfkUTty7RcRWk0Htik3J/w@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Jan 02, 2013 at 08:26:29AM -0500, Shea Levy wrote:

> Hm, ok. Does the boot stub have access to CONFIG_CMDLINE? Or could 
> another compile-time setting be added so that distros can ship livecds 
> that automatically use a config file found at a hard-coded location?

Just pass the config file as the first argument?

-- 
Matthew Garrett | mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org
