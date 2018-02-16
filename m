From: Matthew Garrett <mjg59-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/2] efivars: reading variables can generate SMIs
Date: Fri, 16 Feb 2018 22:03:37 +0000
Message-ID: <CACdnJuvR4NTdCwp=jT3AoW898EXuq6zakfo5hm6dd9mP-SWoGQ@mail.gmail.com>
References: <20180215182208.35003-1-joe.konno@linux.intel.com>
 <CAKv+Gu80pJ5tbGoJqBm8CCKrEZXdkE83c944383KbQ5jREUC0Q@mail.gmail.com>
 <1518814319.4419.10.camel@HansenPartnership.com> <3908561D78D1C84285E8C5FCA982C28F7B37942B@ORSMSX110.amr.corp.intel.com>
 <CALCETrXD4qCwgnDcwnybUXzVk7zyJtzHC2xzLfcZvzrXvAB8PQ@mail.gmail.com>
 <CACdnJutPvMPUTWWjS3oRadQAqn+HpRpY+fhO0pXBj6OsQkAAag@mail.gmail.com> <3908561D78D1C84285E8C5FCA982C28F7B3795A3@ORSMSX110.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F7B3795A3-8oqHQFITsIHTXloPLtfHfbfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, joe.konno-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, linux-efi <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, jk-mnsaURCQ41sdnm+yROfE0A@public.gmane.org, ak-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org, pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Fri, Feb 16, 2018 at 2:02 PM Luck, Tony <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:

> > If the default is 600 then it makes sense to allow a privileged service
to
> > selectively make certain variables world readable at runtime.

> As soon as you make one variable world readable you are vulnerable to
> a local user launching a DoS attack by reading that variable over and over
> generating a flood of SMIs.

I'm not terribly worried about untrusted users on my laptop, but I would
prefer to run as little code as root as possible.
