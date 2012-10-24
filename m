From: =?UTF-8?Q?Mantas_Mikul=C4=97nas?= <grawity-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [systemd-devel] [PATCH] Add syste-firmware-efi-efivars.mount for
 support automount EFI variable filesystem
Date: Wed, 24 Oct 2012 14:07:51 +0300
Message-ID: <CAPWNY8VVtW6C6gmXBcJBbKeQ+YVTUvFx2xynP0mknr68uJO_SQ@mail.gmail.com>
References: <1351075322-3824-1-git-send-email-jlee@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1351075322-3824-1-git-send-email-jlee-IBi9RG/b67k@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Lee, Chun-Yi" <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: systemd-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Kay Sievers <kay-tD+1rO4QERM@public.gmane.org>, "Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Oct 24, 2012 at 1:42 PM, Lee, Chun-Yi <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>=
 wrote:
> Add units/sys-firmware-efi-efivars.mount rule for support automount E=
=46I variable filesystem
> [...]
> +
> +[Mount]
> +What=3Defivarfs
> +Where=3D/sys/firmware/efi/efivars
> +Type=3Defivarfs

Out of curiosity: Which kernels actually use a separate filesystem
type for this? I'm using 3.6 (Arch) here, and it doesn't even
recognize "efivarfs" -- it exports the variables directly via sysfs at
/sys/firmware/efi/vars...

--=20
Mantas Mikul=C4=97nas
