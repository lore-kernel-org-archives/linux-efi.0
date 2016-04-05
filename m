From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH 4/4] efi: A misc char interface to update EFI firmware
Date: Tue, 5 Apr 2016 10:48:12 +0100
Message-ID: <20160405094812.GA2701@codeblueprint.co.uk>
References: <1458219431-24741-1-git-send-email-matt@codeblueprint.co.uk>
 <1458219431-24741-5-git-send-email-matt@codeblueprint.co.uk>
 <1459478930.6099.249.camel@nexus-software.ie>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1459478930.6099.249.camel-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: deckard <pure.logic-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, joeyli <jlee-IBi9RG/b67k@public.gmane.org>, "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Sam Protsenko <semen.protsenko-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 01 Apr, at 03:48:50AM, Bryan O'Donoghue wrote:
> On Thu, 2016-03-17 at 12:57 +0000, Matt Fleming wrote:
> > Tested with Intel Quark Galileo GEN1 platform.
> 
> + * If the capsule is successfully submitted to the firmware, any
> + * subsequent calls to efi_capsule_pending() will return true. @pages
> + * must not be released or modified if this function returns
> + * successfully.
> 
> The only minor nit here is that you can't actually test this on a
> Galileo GEN1 since there's a non-standard header required to update the
> firmware on that platform !
> 
> So I suggest dropping that particular comment in the git log, since you
> can't actually *do* that on a Galileo without doing something about the
> required CSH (Clanton Secure Header) prefixed to the standard Capsule
> header.
> 
> Otherwise.
> 
> Reviewed-by: Bryan O'Donoghue <pure.logic-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org>

Thanks Bryan. I've updated the commit log and added your Reviewed-by.
