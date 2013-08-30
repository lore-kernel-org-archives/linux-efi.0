From: Grant Likely <grant.likely-s3s/WqlpOiPyB63q8FvJNQ@public.gmane.org>
Subject: Re: [PATCH 01/16] Move common EFI stub code from x86 arch code to common location
Date: Fri, 30 Aug 2013 13:45:18 +0100
Message-ID: <20130830124518.68BBA3E102A@localhost>
References: <1376090777-20090-1-git-send-email-roy.franz@linaro.org> <1376090777-20090-2-git-send-email-roy.franz@linaro.org> <1376402180.27484.12.camel@t520.redhat.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1376402180.27484.12.camel-CeaHKw3YYu2ny3qCrzbmXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, dave.martin-5wv7dgnIgG8@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tue, 13 Aug 2013 09:56:20 -0400, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Fri, 2013-08-09 at 16:26 -0700, Roy Franz wrote:
> > No code changes made, just moving functions from x86 arch directory
> > to common location.
> > Code is shared using #include, similar to how decompression code
> > is shared among architectures.
> > 
> > Signed-off-by: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> > ---
> 
> Tested on arm64.
> 
> Acked-by: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Looks okay to me. I'm not a big fan of #including .c files, but I'm okay
with it as-is for the time being. It can be revisited later to
investigate a clean way to compile these functions as a separate .o file.

Reviewed-by: Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

g.
