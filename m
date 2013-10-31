From: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [patch 3/6] Cleanup efi_enter_virtual_mode function
Date: Thu, 31 Oct 2013 11:44:26 +0100
Message-ID: <20131031104426.GA10544@pd.tnic>
References: <20131028112045.GH4314@pd.tnic>
 <20131028112458.GD29133@dhcp-16-126.nay.redhat.com>
 <20131028145801.GM4314@pd.tnic>
 <20131028151048.GA14984@dhcp-16-126.nay.redhat.com>
 <20131029023203.GB5185@dhcp-16-126.nay.redhat.com>
 <20131029134302.GI10972@pd.tnic>
 <20131030020348.GA4332@dhcp-16-126.nay.redhat.com>
 <20131030104718.GB13290@pd.tnic>
 <20131031020405.GA4377@dhcp-16-126.nay.redhat.com>
 <20131031020714.GB4377@dhcp-16-126.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20131031020714.GB4377-je1gSBvt1TcFLmT5oZ11vB/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, horms-/R6kz+dDXgpPR4JQBCEnsQ@public.gmane.org, kexec-TuqUDEhatI4ANWPb/1PvSmm0pvjS0E/A@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Dear Mr. Young,

On Thu, Oct 31, 2013 at 10:07:14AM +0800, Dave Young wrote:
> > But Frankly I'd like to see them in list instead even with only small fixes
> > beacuse in this way there might be more people to review it carefully.
> 
> There's another shorcoming for keeping new patches in git is that nobody know
> when you push it and when is the proper date to pull from your git. I think
> it's better to use git only for the patches which have already been accepted
> and is waiting for maintainer to pull.

thank you for teaching me how to do kernel development!

The actual and real reason why I didn't send them yet is because I
didn't want to be that kaffeine-inflated dork who spams the lists every
other day with a new version of his patches.

I am running build smoketests now and will send the latest version of
the patchset later today so don't worry, the world will see them :)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
