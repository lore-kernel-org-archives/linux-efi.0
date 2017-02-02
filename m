From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH 6/7] efi: Handle secure boot from UEFI-2.6 [ver #7]
Date: Thu, 2 Feb 2017 21:36:26 +0000
Message-ID: <20170202213626.GQ31613@codeblueprint.co.uk>
References: <148587558696.4026.16034622623568539004.stgit@warthog.procyon.org.uk>
 <148587564847.4026.5759345672956585977.stgit@warthog.procyon.org.uk>
 <CAKv+Gu8dnKB1sRGb3U+XB1eoA7Eyo4qSFBtPRbvGV912xPViVw@mail.gmail.com>
 <10454.1485889162@warthog.procyon.org.uk>
 <CAKv+Gu_gy6575axL6M64OSo33ZM2dnbs7cajqJRd8VtbjAXCTw@mail.gmail.com>
 <20578.1485952425@warthog.procyon.org.uk>
 <CAKv+Gu8FOcMx0UXXdd3nhE+PUPzbEn9X=kBQDfkLOZBvVu-8fg@mail.gmail.com>
 <23750.1485961217@warthog.procyon.org.uk>
 <CAKv+Gu9ACE23ZMcQN3NpZ_N-CWzg=N6qFVu3_UruH0miPe=izA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu9ACE23ZMcQN3NpZ_N-CWzg=N6qFVu3_UruH0miPe=izA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-security-module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, 01 Feb, at 03:02:14PM, Ard Biesheuvel wrote:
> 
> Let's wait for Matt to comment on the x86 bits before reissuing
> anything, but if the subsequent patches still apply cleanly, I don't
> think there is a need to resend or re-sign.

This all looks fine to me now, thanks for the re-work David.

Ard, do you want to apply these patches along with a fixup for the
multi-line comments and send a second v4.11 pull to tip?
