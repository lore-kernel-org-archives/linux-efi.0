From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] efi: libstub: treat missing SecureBoot variable as S/B disabled
Date: Fri, 17 Feb 2017 08:56:21 +0000
Message-ID: <12887.1487321781@warthog.procyon.org.uk>
References: <CAKv+Gu_=BwvYJoyuf89PUVjnrJeJyvr-p6yFAu4Mw+ErLc4nxQ@mail.gmail.com> <1487268503-21570-1-git-send-email-ard.biesheuvel@linaro.org> <20170217051355.GA1141@wunner.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKv+Gu_=BwvYJoyuf89PUVjnrJeJyvr-p6yFAu4Mw+ErLc4nxQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-ID: <12886.1487321781.1-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Josh Boyer <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:

> But I did not appreciate at the time that this was a change in
> behavior nonetheless, and printing errors that are not errors only
> confuses people.

Perhaps just take the error message out and leave it to the main kernel to
deal with?

David
