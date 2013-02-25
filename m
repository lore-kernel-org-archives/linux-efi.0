From: Tom Gundersen <teg-B22kvLQNl6c@public.gmane.org>
Subject: Re: [PATCH 1/2] efi: register efivars with efi or gsmi from module_init
Date: Mon, 25 Feb 2013 16:24:35 +0100
Message-ID: <CAG-2HqVLwj61fYfA+2uDLPzevFwEkMxMb5hw8pqJx8Q1vVgr4A@mail.gmail.com>
References: <1361149277-1026-1-git-send-email-teg@jklm.no> <1361455094.2842.15.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1361455094.2842.15.camel-ZqTwcBeJ+wsBof6jY8KHXm7IUlhRatedral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, Feb 21, 2013 at 2:58 PM, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> Guh, yes. The way I implemented this is rather silly. Thanks for the
> report! I was trying to avoid having a struct kobject * in struct
> efivars, because that inherently ties the efivar_entry API to the sysfs
> code, and the whole point of this series is that you can have EFI
> variable support without the sysfs stuff.
>
> Instead of doing the #ifdef-ery how does this look? It keeps everything
> contained within struct efivars just like the old code. Unfortunately
> it's applied against some changes I've got locally, so the context might
> look a bit weird, but you can still get the idea.

Not tested, but as far as I can tell this looks great. Thanks!

Cheers,

Tom
