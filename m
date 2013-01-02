From: Shea Levy <shea-yfkUTty7RcRWk0Htik3J/w@public.gmane.org>
Subject: Re: Revisiting EFI boot stub config file support
Date: Wed, 2 Jan 2013 12:52:21 -0500
Message-ID: <4DA0AD0B-49D1-4938-B38D-A15C378167B0@shealevy.com>
References: <50E306FB.6080607@shealevy.com> <50E31BB4.7040702@zytor.com> <710F73BE-9F65-48C9-8739-BFCF097F4B07@shealevy.com> <20130102174319.GA2590@srcf.ucam.org>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130102174319.GA2590-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Jan 2, 2013, at 12:43, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org> wrote:

> On Wed, Jan 02, 2013 at 08:26:29AM -0500, Shea Levy wrote:
> 
>> Hm, ok. Does the boot stub have access to CONFIG_CMDLINE? Or could 
>> another compile-time setting be added so that distros can ship livecds 
>> that automatically use a config file found at a hard-coded location?
> 
> Just pass the config file as the first argument?
> 

But you can't set args when booting from external media (using e.g. \boot\efi\bootx64.efi), at least not on any system I've seen. And even if you could, that'd over complicate the install process for new users.

> -- 
> Matthew Garrett | mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org
> --
> To unsubscribe from this list: send the line "unsubscribe linux-efi" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
