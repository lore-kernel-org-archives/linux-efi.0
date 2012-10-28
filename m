From: Lennart Poettering <lennart-mdGvqq1h2p+GdvJs77BJ7Q@public.gmane.org>
Subject: Re: [PATCH] systemd: mount the EFI variable filesystem
Date: Sun, 28 Oct 2012 14:00:25 +0100
Message-ID: <20121028130025.GD7904@tango.0pointer.de>
References: <1351308202-14628-1-git-send-email-jlee@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1351308202-14628-1-git-send-email-jlee-IBi9RG/b67k@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Lee, Chun-Yi" <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: systemd-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>, Kay Sievers <kay-tD+1rO4QERM@public.gmane.org>, Mantas =?utf-8?Q?Mikul=C4=97nas?= <grawity-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Zbigniew =?utf-8?Q?J=C4=99drzejewski-Szmek?= <zbyszek-wrcVdnn0TatmR6Xm/wNWPw@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Sat, 27.10.12 11:23, Lee, Chun-Yi (joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org) wrote:

> Add efivarfs to the mount_table in mount-setup.c, so the EFI variable
> filesystem will be mounted when systemd executed.
> 
> The EFI variable filesystem will merge in v3.7 or v3.8 linux kernel.

I can't really test this, but looks reasonably simple, and I assume this
has been tested, so I merged this.

Thanks!

Lennart

-- 
Lennart Poettering - Red Hat, Inc.
