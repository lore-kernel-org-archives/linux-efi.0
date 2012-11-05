From: Josh Boyer <jwboyer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [systemd-devel] [PATCH] systemd: mount the EFI variable filesystem
Date: Mon, 5 Nov 2012 15:55:04 -0500
Message-ID: <CA+5PVA55f6Gdh8myQ4D4Jd=ox7Zh=8ZHxyeiZ7gLspwWJbdoEg@mail.gmail.com>
References: <1351308202-14628-1-git-send-email-jlee@suse.com>
	<20121028130025.GD7904@tango.0pointer.de>
	<1351477290.21227.7.camel@linux-s257.site>
	<1351688670.9230.4.camel@lenny>
	<CAPXgP10j+AGUcyaimtp=osb9mVVpPNJqCvsOdENWhPQEmfYC3A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAPXgP10j+AGUcyaimtp=osb9mVVpPNJqCvsOdENWhPQEmfYC3A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kay Sievers <kay-tD+1rO4QERM@public.gmane.org>
Cc: Colin Walters <walters-gPq2gbYjIk8dnm+yROfE0A@public.gmane.org>, joeyli <jlee-IBi9RG/b67k@public.gmane.org>, Lennart Poettering <lennart-mdGvqq1h2p+GdvJs77BJ7Q@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, systemd-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Oct 31, 2012 at 9:13 AM, Kay Sievers <kay-tD+1rO4QERM@public.gmane.org> wrote:
> On Wed, Oct 31, 2012 at 2:04 PM, Colin Walters <walters-gPq2gbYjIk8dnm+yROfE0A@public.gmane.org> wrote:
>> On Mon, 2012-10-29 at 10:21 +0800, joeyli wrote:
>>
>>> I tested this patch on my UEFI notebook with latest EFI kernel git tree,
>>> the efivarfs mounted normally after system boot and I can delete/add EFI
>>> variable through /sys/firmware/efi/efivars.
>>
>> This causes systemd to output a warning if the kernel doesn't have an
>> efivars module.  I suppose to do this kind of thing "right" we'd
>> have to conditionalize the module loads on available kernel version they
>> first appeared in?
>
> We should probably suppress the warning that the module cannot be
> loaded. And then maybe make the mount conditional, depending on the
> existence of the target directory.
>
> This should make all that only trigger when the kernel module is
> available or it is compiled-in (libkmod tells the same), and do
> nothing on older kernel, kernels without the filesysystem, or
> platforms without EFI.

Yes to all of that.

For those wanting a distro kernel to play with that has this support,
we've included efivarfs in Fedora rawhide and soon in F18.

josh
