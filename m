From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH] efi: use typed function pointers for runtime services
 table
Date: Thu, 24 Nov 2016 21:34:51 +0000
Message-ID: <20161124213451.GA3549@codeblueprint.co.uk>
References: <1479897764-29871-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1479897764-29871-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, 23 Nov, at 10:42:44AM, Ard Biesheuvel wrote:
> Instead of using void pointers, and casting them to correctly typed
> function pointers upon use, declare the runtime services pointers
> as function pointers using their respective prototypes, for which
> typedefs are already available.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
> 
> Build tested on arm64 only

Builds fine for i386, x86-64 and ia64 too.

Reviewed-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
