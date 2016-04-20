From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH v3 0/9] EFI framebuffer support for ARM and arm64
Date: Wed, 20 Apr 2016 20:02:24 +0100
Message-ID: <20160420190224.GC2829@codeblueprint.co.uk>
References: <1459526735-24936-1-git-send-email-ard.biesheuvel@linaro.org>
 <CAKv+Gu_WPCbGgG1TjnY5tQ4YPgR_LDdaeR1fm-S=C894OsXiGQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu_WPCbGgG1TjnY5tQ4YPgR_LDdaeR1fm-S=C894OsXiGQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, 20 Apr, at 02:51:09PM, Ard Biesheuvel wrote:
> 
> Matt: FYI the memremap() patches for ARM that this series (and the
> memory attributes one as well, for that matter) depends on have been
> pulled by Russell and should turn up in -next shortly. That means
> these patches are good to go, as far as I am concerned (unless there
> are remaining concerns?)

Understood. I don't think there were any remaining concerns but I
haven't reviewed the v3 series yet. I'll do that and get back to you.
