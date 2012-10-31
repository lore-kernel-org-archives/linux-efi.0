From: Kay Sievers <kay-tD+1rO4QERM@public.gmane.org>
Subject: Re: [systemd-devel] [PATCH] systemd: mount the EFI variable filesystem
Date: Wed, 31 Oct 2012 14:13:30 +0100
Message-ID: <CAPXgP10j+AGUcyaimtp=osb9mVVpPNJqCvsOdENWhPQEmfYC3A@mail.gmail.com>
References: <1351308202-14628-1-git-send-email-jlee@suse.com>
 <20121028130025.GD7904@tango.0pointer.de> <1351477290.21227.7.camel@linux-s257.site>
 <1351688670.9230.4.camel@lenny>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1351688670.9230.4.camel@lenny>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Colin Walters <walters-gPq2gbYjIk8dnm+yROfE0A@public.gmane.org>
Cc: joeyli <jlee-IBi9RG/b67k@public.gmane.org>, Lennart Poettering <lennart-mdGvqq1h2p+GdvJs77BJ7Q@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, systemd-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Oct 31, 2012 at 2:04 PM, Colin Walters <walters-gPq2gbYjIk8dnm+yROfE0A@public.gmane.org> wrote:
> On Mon, 2012-10-29 at 10:21 +0800, joeyli wrote:
>
>> I tested this patch on my UEFI notebook with latest EFI kernel git tree,
>> the efivarfs mounted normally after system boot and I can delete/add EFI
>> variable through /sys/firmware/efi/efivars.
>
> This causes systemd to output a warning if the kernel doesn't have an
> efivars module.  I suppose to do this kind of thing "right" we'd
> have to conditionalize the module loads on available kernel version they
> first appeared in?

We should probably suppress the warning that the module cannot be
loaded. And then maybe make the mount conditional, depending on the
existence of the target directory.

This should make all that only trigger when the kernel module is
available or it is compiled-in (libkmod tells the same), and do
nothing on older kernel, kernels without the filesysystem, or
platforms without EFI.

We generally never want to depend on specific kernel versions, because
people are free to backport stuff to older kernel versions or free to
disable things in the kernel which are not absolutely required.

Kay
