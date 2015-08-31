From: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] drivers/firmware: make efi/esrt.c driver explicitly
 non-modular
Date: Mon, 31 Aug 2015 09:52:02 -0400
Message-ID: <20150831135201.GA17921@redhat.com>
References: <1440543648-27328-1-git-send-email-paul.gortmaker@windriver.com>
 <20150826171128.GA2837@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150826171128.GA2837-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Paul Gortmaker <paul.gortmaker-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, Aug 26, 2015 at 06:11:28PM +0100, Matt Fleming wrote:
> On Tue, 25 Aug, at 07:00:48PM, Paul Gortmaker wrote:
> > The Kconfig for this driver is currently hidden with:
> > 
> > config EFI_ESRT
> >         bool
> > 
> > ...meaning that it currently is not being built as a module by anyone.
> > Lets remove the modular code that is essentially orphaned, so that
> > when reading the driver there is no doubt it is builtin-only.
> > 
> > Since module_init translates to device_initcall in the non-modular
> > case, the init ordering remains unchanged with this commit.
> > 
> > We leave some tags like MODULE_AUTHOR for documentation purposes.
> > 
> > We don't replace module.h with init.h since the file already has that.
> > 
> > Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Cc: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > Signed-off-by: Paul Gortmaker <paul.gortmaker-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>
> 
> Looks good to me. I know Peter is on vacation right now, so I'm still
> expecting a response from him. In the meantime, I'll queue this up in
> the EFI 'next' branch. Thanks!

Looks fine to me as well.

-- 
        Peter
