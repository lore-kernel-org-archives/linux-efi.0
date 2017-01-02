From: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH] efi: use typed function pointers for runtime services
 table
Date: Mon, 2 Jan 2017 11:42:55 +0100
Message-ID: <20170102104255.GA20016@wunner.de>
References: <1479897764-29871-1-git-send-email-ard.biesheuvel@linaro.org>
 <20161124213451.GA3549@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161124213451.GA3549-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, Nov 24, 2016 at 09:34:51PM +0000, Matt Fleming wrote:
> On Wed, 23 Nov, at 10:42:44AM, Ard Biesheuvel wrote:
> > Instead of using void pointers, and casting them to correctly typed
> > function pointers upon use, declare the runtime services pointers
> > as function pointers using their respective prototypes, for which
> > typedefs are already available.
> > 
> > Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> > ---
> > 
> > Build tested on arm64 only
> 
> Builds fine for i386, x86-64 and ia64 too.
> 
> Reviewed-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>

This hasn't been applied to efi.git/next yet so I resubmitted as part
of my consification series.  (And I'm afraid I forgot to include your
Reviewed-by, sorry.)

Thanks,

Lukas
