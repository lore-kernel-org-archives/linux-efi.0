From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [PATCH 0/2] efivars: reading variables can generate SMIs
Date: Fri, 16 Feb 2018 12:51:59 -0800
Message-ID: <1518814319.4419.10.camel@HansenPartnership.com>
References: <20180215182208.35003-1-joe.konno@linux.intel.com>
         <CAKv+Gu80pJ5tbGoJqBm8CCKrEZXdkE83c944383KbQ5jREUC0Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKv+Gu80pJ5tbGoJqBm8CCKrEZXdkE83c944383KbQ5jREUC0Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Joe Konno <joe.konno-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Matthew Garrett <mjg59-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jeremy Kerr <jk-mnsaURCQ41sdnm+yROfE0A@public.gmane.org>, Andi Kleen <ak-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 2018-02-16 at 10:41 +0000, Ard Biesheuvel wrote:
> On 15 February 2018 at 18:22, Joe Konno <joe.konno-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> wrote:
> > 
> > From: Joe Konno <joe.konno-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > 
> > It was pointed out that normal, unprivileged users reading certain
> > EFI
> > variables (through efivarfs) can generate SMIs. Given these nodes
> > are created
> > with 0644 permissions, normal users could generate a lot of SMIs.
> > By
> > restricting permissions a bit (patch 1), we can make it harder for
> > normal users
> > to generate spurious SMIs.
> > 
> > A normal user could generate lots of SMIs by reading the efivarfs
> > in a trivial
> > loop:
> > 
> > ```
> > while true; do
> >     cat /sys/firmware/efi/evivars/* > /dev/null
> > done
> > ```
> > 
> > Patch 1 in this series limits read and write permissions on
> > efivarfs to the
> > owner/superuser. Group and world cannot access.
> > 
> > Patch 2 is for consistency and hygiene. If we restrict permissions
> > for either
> > efivarfs or efi/vars, the other interface should get the same
> > treatment.
> > 
> 
> I am inclined to apply this as a fix, but I will give the x86 guys a
> chance to respond as well.

It would break my current efi certificate tools because right at the
moment you can read the EFI secure boot variables as an unprivileged
user.

That said, I'm not sure how many non-root users run the toolkit to
extract their EFI certificates or check on the secure boot status of
the system, but I suspect it might be non-zero: I can see the tinfoil
hat people wanting at least to check the secure boot status when they
log in.

James
