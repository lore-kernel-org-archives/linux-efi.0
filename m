From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/5] security, efi: Set lockdown if in secure boot mode
Date: Tue, 06 Jun 2017 10:34:51 +0100
Message-ID: <25009.1496741691@warthog.procyon.org.uk>
References: <CAKv+Gu_vXASr=yDJ3MwT960eApqeWKEd-hqGoEyGsJKip7N+KQ@mail.gmail.com> <149563711758.9419.11406612723056598045.stgit@warthog.procyon.org.uk> <CAKv+Gu_5gUWwx7Sxgm8d03L4t4nF8dDe+AXqOqto4B7AVSZ9CA@mail.gmail.com> <21606.1496222635@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKv+Gu_vXASr=yDJ3MwT960eApqeWKEd-hqGoEyGsJKip7N+KQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-ID: <25008.1496741691.1-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, linux-security-module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:

> and print a subsequent line for every lockdown feature that is enabled, e.g.,
> 
> lockdown: disabling MSRs
> lockdown: disabling hibernate support

There's another problem with this idea: the lockdown facility is passive - it
doesn't go looking for things to lock down; rather, things that can be locked
down inquire as to whether lockdown is in effect at the point someone tries to
use them.

Now, I could reserve a variable for each thing we lock down to make sure that
we don't emit the message more than once, but I'm loathe to waste memory this
way.

I can't so easily switch the facility to being active either, since a lot of
the lockdownables are in modules.

David
