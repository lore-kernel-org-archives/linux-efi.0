From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] efi: split efisubsystem from efivars
Date: Mon, 04 Feb 2013 10:26:21 +0000
Message-ID: <1359973581.7515.101.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1359128215-1331-1-git-send-email-teg@jklm.no>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1359128215-1331-1-git-send-email-teg-B22kvLQNl6c@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tom Gundersen <teg-B22kvLQNl6c@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kay Sievers <kay-tD+1rO4QERM@public.gmane.org>, Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Chun-Yi Lee <jlee-IBi9RG/b67k@public.gmane.org>, Andy Whitcroft <apw-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 2013-01-25 at 16:36 +0100, Tom Gundersen wrote:
> This registers /sys/firmware/efi{,/efivars} whenever EFI is enabled
> and the system supports it.
> 
> This allows
>  *) userspace to check for the existence of /sys/firmware/efi as a way
>     to determine whether or it is running on an EFI system.
>  *) 'mount -t efivarfs none /sys/firmware/efi/efivars' without manually
>     loading any modules.
> 
> Signed-off-by: Tom Gundersen <teg-B22kvLQNl6c@public.gmane.org>
> Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Kay Sievers <kay-tD+1rO4QERM@public.gmane.org>
> Cc: Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
> Cc: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
> Cc: Chun-Yi Lee <jlee-IBi9RG/b67k@public.gmane.org>
> Cc: Andy Whitcroft <apw-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
> ---
>  drivers/firmware/Makefile    |  1 +
>  drivers/firmware/efisubsys.c | 52 ++++++++++++++++++++++++++++++++++++++++++++
>  drivers/firmware/efivars.c   | 30 +++++--------------------
>  3 files changed, 59 insertions(+), 24 deletions(-)
>  create mode 100644 drivers/firmware/efisubsys.c

Tom, this patch is still on my radar. It's just that I thought it was
*such* a good idea I decided to chainsaw the existing efivars code to
make it more modular and eventually split things up into a new
drivers/firmware/efi directory.

Please bear with me.
