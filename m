From: deckard <pure.logic-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org>
Subject: Re: [PATCH 4/4] efi: A misc char interface to update EFI firmware
Date: Fri, 01 Apr 2016 03:48:50 +0100
Message-ID: <1459478930.6099.249.camel@nexus-software.ie>
References: <1458219431-24741-1-git-send-email-matt@codeblueprint.co.uk>
	 <1458219431-24741-5-git-send-email-matt@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1458219431-24741-5-git-send-email-matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: joeyli <jlee-IBi9RG/b67k@public.gmane.org>, "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Sam Protsenko <semen.protsenko-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, 2016-03-17 at 12:57 +0000, Matt Fleming wrote:
> Tested with Intel Quark Galileo GEN1 platform.

+ * If the capsule is successfully submitted to the firmware, any
+ * subsequent calls to efi_capsule_pending() will return true. @pages
+ * must not be released or modified if this function returns
+ * successfully.

The only minor nit here is that you can't actually test this on a
Galileo GEN1 since there's a non-standard header required to update the
firmware on that platform !

So I suggest dropping that particular comment in the git log, since you
can't actually *do* that on a Galileo without doing something about the
required CSH (Clanton Secure Header) prefixed to the standard Capsule
header.

Otherwise.

Reviewed-by: Bryan O'Donoghue <pure.logic-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org>
